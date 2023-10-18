import 'dart:async';

import 'package:YWallet/appsettings.dart';
import 'package:YWallet/store2.dart';
import 'package:reflectable/reflectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'coin/coins.dart';
import 'package:mobx/mobx.dart';
import 'db.dart';
import 'package:warp_api/warp_api.dart';

import 'coin/coin.dart';
import 'main.dart';
import 'store.dart';

part 'accounts.g.dart';

class Account {
  final int coin;
  final int id;
  final String name;
  final int balance;
  final int type;
  bool active = false;
  int tbalance = 0;

  Account(
      this.coin, this.id, this.name, this.type, this.balance, this.tbalance);

  String get address {
    return id != 0
        ? WarpApi.getAddress(this.coin, this.id, settings.uaType)
        : "";
  }
}

final Account emptyAccount = Account(0, 0, "", 0, 0, 0);

class AccountList {
  List<Account> list = [];

  AccountList() {
    refresh();
  }

  void refresh() {
    List<Account> _list = [];
    for (var coin in coins) {
      var accounts = WarpApi.getAccountList(coin.coin)
          .map(
              (a) => Account(coin.coin, a.id, a.name!, a.keyType, a.balance, 0))
          .toList();
      final id = WarpApi.getActiveAccountId(coin.coin);
      if (id != 0) {
        accounts.firstWhere((a) => a.id == id).active = true;
      }
      _list.addAll(accounts);
    }
    list = _list;
  }

  bool get isEmpty {
    return list.isEmpty;
  }

  Future<void> updateTBalance() async {
    for (var a in list) {
      final tbalance = await WarpApi.getTBalanceAsync(a.coin, a.id);
      a.tbalance = tbalance;
    }
  }

  void delete(int coin, int id) {
    WarpApi.deleteAccount(coin, id);
    active.checkAndUpdate();
  }

  Future<void> changeAccountName(int coin, int id, String name) async {
    WarpApi.updateAccountName(coin, id, name);
    refresh();
  }

  Account get(int coin, int id) =>
      list.firstWhere((e) => e.coin == coin && e.id == id,
          orElse: () => emptyAccount);
}

AccountId? getAvailableId(int coin) {
  final nid = getActiveAccountId(coin);
  if (nid.id != 0) return nid;
  for (var coinData in settings.coins) {
    // look for an account in any other coin
    if (coinData.coin != coin) {
      final nid = getActiveAccountId(coinData.coin);
      if (nid.id != 0) return nid;
    }
  }
  // We have no accounts
  return null;
}

AccountId getActiveAccountId(int coin) {
  final id = WarpApi.getActiveAccountId(coin);
  return AccountId(coin, id);
}

class ActiveAccount = _ActiveAccount with _$ActiveAccount;

abstract class _ActiveAccount with Store {
  @observable
  int dataEpoch = 0;

  @observable
  int coin = 0;
  @observable
  int id = 0;

  Account account = emptyAccount;
  CoinBase coinDef = zcash;
  bool canPay = false;
  bool external = false;
  Balances balances = Balances();
  @observable
  String taddress = "";
  int tbalance = 0;
  @observable
  PoolBalanceT poolBalances = PoolBalanceT();

  @observable
  List<Note> notes = [];
  @observable
  List<Tx> txs = [];
  @observable
  List<Spending> spendings = [];
  @observable
  List<TimeSeriesPoint<double>> accountBalances = [];
  @observable
  List<PnL> pnls = [];
  @observable
  ObservableList<ZMessage> messages = ObservableList();
  @observable
  int unread = 0;
  @observable
  String banner = "";

  @observable
  int addrMode = 0;

  @observable
  SortConfig noteSortConfig = SortConfig("", SortOrder.Unsorted);

  @observable
  SortConfig txSortConfig = SortConfig("", SortOrder.Unsorted);

  @observable
  int pnlSeriesIndex = 0;

  @observable
  bool pnlDesc = false;

  @observable
  Recipient? draftRecipient;

  AccountId toId() {
    return AccountId(coin, id);
  }

  @action
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final coin = prefs.getInt('coin') ?? 0;
    var id = prefs.getInt('account') ?? 0;
    if (WarpApi.checkAccount(coin, id)) setActiveAccount(coin, id);
    checkAndUpdate();
  }

  void checkAndUpdate() {
    final aid = getAvailableId(active.coin);
    if (aid == null) {
      setActiveAccount(0, 0);
    } else if (aid != active.toId()) {
      setActiveAccount(aid.coin, aid.id);
    }
  }

  void setActiveAccount(int coin, int id) {
    WarpApi.setActiveAccount(coin, id);
    if (coin != this.coin || id != this.id) {
      this.coin = coin;
      this.id = id;
      _refreshAccount();
    }
    Future(Action(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('coin', coin);
      prefs.setInt('account', id);
      await priceStore.updateChart(force: true);
      dataEpoch += 1;
    }));
    Future(() => priceStore.fetchCoinPrice(active.coin));
    dataEpoch += 1;
  }

  void _refreshAccount() {
    coinDef = settings.coins[coin].def;

    final accounts = AccountList();
    accounts.refresh();
    account = accounts.get(coin, id);

    if (id > 0) {
      taddress = WarpApi.getTAddr(coin, id);
      external = coinDef.supportsLedger &&
          !isMobile() &&
          WarpApi.ledgerHasAccount(coin, id);
      canPay = WarpApi.getSK(coin, id).isNotEmpty || external;
    }

    addrMode = 0;
    balances.initialized = false;
    draftRecipient = null;

    update();
    Future(priceStore.updateChart);
  }

  @action
  Future<void> refreshTAddr() async {
    taddress = WarpApi.getTAddr(coin, id);
  }

  @action
  void updateAddrMode(int v) {
    addrMode = v;
  }

  @action
  Future<void> updateTBalance() async {
    try {
      tbalance = await WarpApi.getTBalance(coin, id);
    } on String {}
  }

  @action
  void updateBalances() {
    final initialized = balances.initialized;
    final prevBalance = balances.balance;
    final b = WarpApi.getBalance(coin, id, syncStatus.confirmHeight);
    balances.update(b.balance, b.shielded, b.unconfirmedSpent, b.underConfirmed,
        b.excluded);
    if (initialized && prevBalance != balances.balance) {
      showBalanceNotification(prevBalance, balances.balance);
    }
  }
  
  @action
  void updatePoolBalances() {
    final b = WarpApi.getPoolBalances(active.coin, active.id, appSettings.anchorOffset);
    poolBalances = b.unpack();
  }

  @action
  void clear() {
    messages.clear();
    notes.clear();
    txs.clear();
    unread = 0;
    dataEpoch += 1;
  }

  @action
  Future<void> update() async {
    updateBalances();
    await updateTBalance();

    updatePoolBalances();
    print(poolBalances);
    final dbr = DbReader(coin, id);
    notes = await dbr.getNotes(syncStatus2.latestHeight);
    txs = await dbr.getTxs(syncStatus2.latestHeight);
    messages = ObservableList.of(await dbr.getMessages());
    unread = messages.where((m) => !m.read).length;
    dataEpoch += 1;
    print(DateTime.now());
  }

  @action
  void setDraftRecipient(Recipient? v) {
    draftRecipient = v;
  }

  String getDiversifiedAddress(int uaType, int time) {
    return WarpApi.getDiversifiedAddress(uaType & settings.uaType, time);
  }

  String getAddress(int uaType) {
    return WarpApi.getAddress(coin, id, uaType);
  }

  @computed
  List<Note> get sortedNotes {
    // ignore: unused_local_variable
    final _unused = syncStatus.syncedHeight;
    var notes2 = [...notes];
    switch (noteSortConfig.field) {
      case "time":
        return _sort(notes2, (Note note) => note.height, noteSortConfig.order);
      case "amount":
        return _sort(notes2, (Note note) => note.value, noteSortConfig.order);
    }
    return notes2;
  }

  @computed
  List<Tx> get sortedTxs {
    // ignore: unused_local_variable
    final _unused = syncStatus.syncedHeight;
    var txs2 = [...txs];
    switch (txSortConfig.field) {
      case "time":
        return _sort(txs2, (Tx tx) => tx.height, txSortConfig.order);
      case "amount":
        return _sort(txs2, (Tx tx) => tx.value, txSortConfig.order);
      case "txid":
        return _sort(txs2, (Tx tx) => tx.txId, txSortConfig.order);
      case "address":
        return _sort(txs2, (Tx tx) => tx.contact ?? tx.address ?? '',
            txSortConfig.order);
      case "memo":
        return _sort(txs2, (Tx tx) => tx.memo ?? '', txSortConfig.order);
    }
    return txs2;
  }

  @action
  void sortNotes(String field) {
    noteSortConfig = noteSortConfig.sortOn(field);
  }

  @action
  void sortTx(String field) {
    txSortConfig = txSortConfig.sortOn(field);
  }

  List<C> _sort<C extends HasHeight, T extends Comparable>(
      List<C> items, T Function(C) project, SortOrder order) {
    switch (order) {
      case SortOrder.Ascending:
        items.sort((a, b) => project(a).compareTo(project(b)));
        break;
      case SortOrder.Descending:
        items.sort((a, b) => -project(a).compareTo(project(b)));
        break;
      case SortOrder.Unsorted:
        items.sort((a, b) => -a.height.compareTo(b.height));
        break;
    }
    return items;
  }

  @action
  void setPnlSeriesIndex(int index) {
    pnlSeriesIndex = index;
  }

  @computed
  List<PnL> get pnlSorted {
    if (pnlDesc) {
      var _pnls = [...pnls.reversed];
      return _pnls;
    }
    return pnls;
  }

  @action
  void togglePnlDesc() {
    pnlDesc = !pnlDesc;
  }

  @action
  void excludeNote(Note note) {
    WarpApi.updateExcluded(coin, note.id, note.excluded);
    notes = notes.toList();
  }

  @action
  void invertExcludedNotes() {
    WarpApi.invertExcluded(coin, id);
    notes = notes.map((n) => n.invertExcluded).toList();
  }

  @action
  void fetchChartData() {
    final dbr = active.dbReader;
    pnls = dbr.getPNL(active.id);
    spendings = dbr.getSpending(active.id);
    accountBalances =
        dbr.getAccountBalanceTimeSeries(active.id, active.balances.balance);
  }

  @action
  void markMessageAsRead(int index) {
    if (!messages[index].read) {
      WarpApi.markMessageAsRead(messages[index].id, true);
      messages[index] = messages[index].withRead(true);
      unread = unread - 1;
    }
  }

  @action
  void markAllMessagesAsRead() {
    WarpApi.markAllMessagesAsRead(true);
    for (var i = 0; i < messages.length; i++) {
      messages[i] = messages[i].withRead(true);
    }
    unread = 0;
  }

  int prevInThread(int index) {
    final message = messages[index];
    final pn =
        WarpApi.getPrevNextMessage(coin, id, message.subject, message.height);
    return pn.prev;
  }

  int nextInThread(int index) {
    final message = messages[index];
    final pn =
        WarpApi.getPrevNextMessage(coin, id, message.subject, message.height);
    return pn.next;
  }

  @action
  void setBanner(String msg) {
    banner = msg;
  }

  String get address {
    return account.address;
  }

  DbReader get dbReader => DbReader(coin, id);
  int get availabeAddrs => WarpApi.getAvailableAddrs(coin, id);

  SortConfig2? noteOrder;
  SortConfig2? txOrder;
  SortConfig2? messageOrder;

  Tuple2<SortConfig2?, List<T>> setSortOrder<T extends HasHeight>(String field, SortConfig2? order, List<T> items) {
    if (order == null)
      order = SortConfig2(field, 1);
    else
      order = order.next(field);

    final o = order;
    if (o == null)
      items = items.sortedByNum((n) => -n.height);
    else {
      items = items.sortedBy((a, b) {
        final ra = reflector.reflect(a);
        final va = ra.invokeGetter(field)! as dynamic;
        final rb = reflector.reflect(b);
        final vb = rb.invokeGetter(field)! as dynamic;
        return va.compareTo(vb) * o.orderBy;
      });
    }
    return Tuple2(o, items);
  }

  @action
  void setNoteSortOrder(String field) {
    final r = setSortOrder(field, noteOrder, notes);
    noteOrder = r.item1;
    notes = r.item2;
  }

  @action
  void setTxSortOrder(String field) {
    final r = setSortOrder(field, txOrder, txs);
    txOrder = r.item1;
    txs = r.item2;
  }

  @action
  void setMessageSortOrder(String field) {
    final r = setSortOrder(field, messageOrder, messages);
    messageOrder = r.item1;
    messages = ObservableList.of(r.item2);
  }
}

class SortConfig2 {
  String field;
  int orderBy; // 1: asc, -1: desc
  SortConfig2(this.field, this.orderBy);

  SortConfig2? next(String newField) {
    if (newField == field) {
      if (orderBy > 0) return SortConfig2(field, -orderBy);
      return null;
    }
    return SortConfig2(newField, 1);
  }

  String indicator(String field) {
    if (this.field != field) return '';
    if (orderBy > 0) return ' \u2191';
    return ' \u2193';
  }
}



class Balances = _Balances with _$Balances;

abstract class _Balances with Store {
  bool initialized = false;
  @observable
  int balance = 0;
  @observable
  int shieldedBalance = 0;
  @observable
  int unconfirmedSpentBalance = 0;
  @observable
  int underConfirmedBalance = 0;
  @observable
  int excludedBalance = 0;

  @action
  void update(int balance, int shieldedBalance, int unconfirmedSpentBalance,
      int underConfirmedBalance, int excludedBalance) {
    this.balance = balance;
    this.shieldedBalance = shieldedBalance;
    this.unconfirmedSpentBalance = unconfirmedSpentBalance;
    this.underConfirmedBalance = underConfirmedBalance;
    this.excludedBalance = excludedBalance;
    this.initialized = true;
  }
}

class AccountId {
  final int coin;
  final int id;
  AccountId(this.coin, this.id);
}

