import 'package:shared_preferences/shared_preferences.dart';
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
  bool active = false;
  int tbalance = 0;

  Account(this.coin, this.id, this.name, this.balance, this.tbalance);

  String get address {
    return id != 0
        ? WarpApi.getAddress(this.coin, this.id, settings.uaType)
        : "";
  }
}

final Account emptyAccount = Account(0, 0, "", 0, 0);

class AccountList {
  List<Account> list = [];

  AccountList() {
    refresh();
  }

  void refresh() {
    List<Account> _list = [];
    for (var coin in coins) {
      var accounts = WarpApi.getAccountList(coin.coin)
          .map((a) => Account(coin.coin, a.id, a.name!, a.balance, 0))
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
  Balances balances = Balances();
  @observable
  String taddress = "";
  int tbalance = 0;
  PoolBalances poolBalances = PoolBalances();

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
  bool showTAddr = false;

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
      canPay = WarpApi.getSK(coin, id).isNotEmpty;
    }

    showTAddr = false;
    balances.initialized = false;
    draftRecipient = null;

    update();
    Future.microtask(priceStore.updateChart);
  }

  @action
  Future<void> refreshTAddr() async {
    taddress = WarpApi.getTAddr(coin, id);
  }

  @action
  void toggleShowTAddr() {
    showTAddr = !showTAddr;
  }

  @action
  void updateTBalance() {
    try {
      tbalance = WarpApi.getTBalance();
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
  void clear() {
    messages.clear();
    notes.clear();
    txs.clear();
    unread = 0;
    dataEpoch += 1;
  }

  @action
  void update() {
    updateBalances();
    updateTBalance();
    poolBalances.update();

    final dbr = DbReader(coin, id);
    notes = dbr.getNotes();
    txs = dbr.getTxs();
    messages = ObservableList.of(dbr.getMessages());
    unread = messages.where((m) => !m.read).length;
    dataEpoch += 1;
  }

  @action
  void setDraftRecipient(Recipient? v) {
    draftRecipient = v;
  }

  String getDiversifiedAddress(int time) {
    return WarpApi.getDiversifiedAddress(settings.uaType, time);
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
        return _sort(txs2, (Tx tx) => tx.txid, txSortConfig.order);
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

class PoolBalances = _PoolBalances with _$PoolBalances;

abstract class _PoolBalances with Store {
  @observable
  int transparent = 0;
  @observable
  int sapling = 0;
  @observable
  int orchard = 0;

  void update() {
    final b =
        WarpApi.getBalance(active.coin, active.id, syncStatus.confirmHeight);
    _update(active.tbalance, b.sapling, b.orchard);
  }

  @action
  _update(int t, int s, int o) {
    transparent = t;
    sapling = s;
    orchard = o;
  }
}
