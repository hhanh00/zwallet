import 'package:shared_preferences/shared_preferences.dart';
import 'coin/coins.dart';
import 'package:mobx/mobx.dart';
import 'db.dart';
import 'package:warp_api/warp_api.dart';

import 'backup.dart';
import 'coin/coin.dart';
import 'coin/zcash.dart';
import 'main.dart';
import 'store.dart';

part 'accounts.g.dart';

class Account {
  final int coin;
  final int id;
  final String name;
  final String address;
  final int balance;
  int tbalance = 0;
  final ShareInfo? share;

  Account(this.coin, this.id, this.name, this.address, this.balance, this.tbalance, this.share);
}

final Account emptyAccount = Account(0, 0, "", "", 0, 0, null);

class AccountManager2 = _AccountManager2 with _$AccountManager2;

abstract class _AccountManager2 with Store {
  @observable int epoch = 0;
  List<Account> list = [];

  @action
  Future<void> refresh() async {
    List<Account> _list = [];
    _list.addAll(await _getList(0));
    _list.addAll(await _getList(1));
    list = _list;
    epoch += 1;
  }

  bool get isEmpty { return list.isEmpty; }

  @action
  Future<void> updateTBalance() async {
    for (var a in list) {
      final tbalance = await WarpApi.getTBalanceAsync(a.coin, a.id);
      a.tbalance = tbalance;
    }
    epoch += 1;
  }

  @action
  Future<void> delete(int coin, int id) async {
    WarpApi.deleteAccount(coin, id);
    if (active.coin == coin && active.id == id)
      active.reset();
  }

  @action
  Future<void> changeAccountName(int coin, int id, String name) async {
    final c = settings.coins[coin].def; // TODO: Do in backend would be cleaner
    final db = c.db;
    await db.execute("UPDATE accounts SET name = ?2 WHERE id_account = ?1",
        [id, name]);
    await refresh();
  }

  void saveActive(int coin, int id) {
    settings.coins[coin].active = id;
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final def = settings.coins[coin].def;
      prefs.setInt("${def.ticker}.active", id);
    });
  }

  Account get(int coin, int id) => list.firstWhere((e) => e.coin == coin && e.id == id, orElse: () => emptyAccount);

  Future<bool> hasAccount(int coin) async {
    final c = settings.coins[coin].def;
    final db = c.db;
    final List<Map> res = await db.rawQuery(
        "SELECT 1 FROM accounts",
        []);
    return res.isNotEmpty;
  }

  static Future<List<Account>> _getList(int coin) async {
    final c = settings.coins[coin].def;
    final db = c.db;
    List<Account> accounts = [];

    final List<Map> res = await db.rawQuery(
        "WITH notes AS (SELECT a.id_account, a.name, a.address, CASE WHEN r.spent IS NULL THEN r.value ELSE 0 END AS nv FROM accounts a LEFT JOIN received_notes r ON a.id_account = r.account),"
            "accounts2 AS (SELECT id_account, name, address, COALESCE(sum(nv), 0) AS balance FROM notes GROUP by id_account) "
            "SELECT a.id_account, a.name, a.address, a.balance FROM accounts2 a",
        []);
    for (var r in res) {
      final int id = r['id_account'];
      // final shareInfo = r['secret'] != null
      //     ? ShareInfo(
      //     r['idx'], r['threshold'], r['participants'], r['secret'])
      //     : null; // TODO: Multisig
      final account = Account(
          coin,
          id,
          r['name'],
          r['address'],
          r['balance'],
          0,
          null);
      accounts.add(account);
    }
    return accounts;
  }
}

class ActiveAccount = _ActiveAccount with _$ActiveAccount;

abstract class _ActiveAccount with Store {
  @observable int dataEpoch = 0;

  @observable int coin = 0;
  @observable int id = 0;

  Account account = emptyAccount;
  CoinBase coinDef = zcash;
  bool canPay = false;
  @observable Balances balances = Balances.zero;
  String taddress = "";
  int tbalance = 0;

  @observable List<Note> notes = [];
  @observable List<Tx> txs = [];
  @observable List<Spending> spendings = [];
  @observable List<TimeSeriesPoint<double>> accountBalances = [];
  @observable List<PnL> pnls = [];
  @observable ObservableList<ZMessage> messages = ObservableList();
  @observable int unread = 0;
  @observable String banner = "";

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

  @action
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final coin = prefs.getInt('coin') ?? 0;
    final id = prefs.getInt('account') ?? 0;
    await setActiveAccount(coin, id);
  }

  Future<void> reset() async {
    for (var coin_data in settings.coins) {
      if (await refreshId(coin_data.coin) != 0)
        return;
    }
    await setActiveAccount(0, 0);
  }

  // check that the active account still exists
  // if not, pick any account
  // if there are none, return null
  Future<int> refreshId(int coin) async {
    coinDef = settings.coins[coin].def;
    final db = coinDef.db;
    final List<Map> res1 = await db.rawQuery(
        "SELECT 1 FROM accounts WHERE id_account = ?1", [active.id]);
    if (res1.isNotEmpty)
      return active.id;
    final List<Map> res2 = await db.rawQuery(
        "SELECT id_account FROM accounts", []);
    if (res2.isNotEmpty) {
      final id = res2[0]['id_account'];
      await setActiveAccount(coin, id);
      return id;
    }
    return 0;
  }

  @action
  Future<void> setActiveAccount(int _coin, int _id) async {
    if (coin == _coin && id == _id) return;

    coin = _coin;
    id = _id;
    accounts.saveActive(coin, id);

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('coin', coin);
    prefs.setInt('account', id);

    coinDef = settings.coins[coin].def;
    final db = coinDef.db;

    account = accounts.get(coin, id);

    if (id > 0) {
      final List<Map> res1 = await db.rawQuery(
          "SELECT address FROM taddrs WHERE account = ?1", [id]);
      taddress = res1.isNotEmpty ? res1[0]['address'] : "";

      final List<Map> res2 = await db.rawQuery(
          "SELECT sk FROM accounts WHERE id_account = ?1", [id]);
      canPay = res2.isNotEmpty && res2[0]['sk'] != null;
    }

    showTAddr = false;
    balances = Balances.zero;
    WarpApi.setActiveAccount(coin, id);

    await update();
    await priceStore.updateChart();
  }

  @action
  Future<void> updateAccount() async {
    final a = accounts.get(coin, id);
    if (a.id != active.id)
      await setActiveAccount(a.coin, a.id);
  }

  @action
  void toggleShowTAddr() {
    showTAddr = !showTAddr;
  }

  @action
  void updateTBalance() {
    tbalance = WarpApi.getTBalance();
  }

  @action
  Future<void> updateBalances() async {
    final dbr = DbReader(coin, id);
    balances = await dbr.getBalance(syncStatus.confirmHeight);
  }

  @action
  Future<void> update() async {
    await updateBalances();
    updateTBalance();
    final dbr = DbReader(coin, id);
    notes = await dbr.getNotes();
    txs = await dbr.getTxs();
    messages = ObservableList.of(await dbr.getMessages(account.address));
    unread = messages.where((m) => !m.read).length;
    dataEpoch += 1;
  }

  String newAddress() {
    return WarpApi.newDiversifiedAddress();
  }

  @computed
  List<Note> get sortedNotes {
    final _1 = syncStatus.syncedHeight;
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
    final _1 = syncStatus.syncedHeight;
    var txs2 = [...txs];
    switch (txSortConfig.field) {
      case "time":
        return _sort(txs2, (Tx tx) => tx.height, txSortConfig.order);
      case "amount":
        return _sort(txs2, (Tx tx) => tx.value, txSortConfig.order);
      case "txid":
        return _sort(txs2, (Tx tx) => tx.txid, txSortConfig.order);
      case "address":
        return _sort(
            txs2, (Tx tx) => tx.contact ?? tx.address, txSortConfig.order);
      case "memo":
        return _sort(txs2, (Tx tx) => tx.memo, txSortConfig.order);
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
  Future<void> excludeNote(Note note) async {
    await coinDef.db.execute(
        "UPDATE received_notes SET excluded = ?2 WHERE id_note = ?1",
        [note.id, note.excluded]);
  }

  @action
  Future<void> invertExcludedNotes() async {
    await coinDef.db.execute(
        "UPDATE received_notes SET excluded = NOT(COALESCE(excluded, 0)) WHERE account = ?1",
        [active.id]);
    notes = notes.map((n) => n.invertExcluded).toList();
  }

  @action
  Future<void> fetchChartData() async {
    final dbr = DbReader(active.coin, active.id);
    pnls = await dbr.getPNL(active.id);
    spendings = await dbr.getSpending(active.id);
    accountBalances = await dbr.getAccountBalanceTimeSeries(active.id, active.balances.balance);
  }

  @action
  Future<void> convertToWatchOnly() async {
    await coinDef.db.rawUpdate(
        "UPDATE accounts SET seed = NULL, sk = NULL WHERE id_account = ?1",
        [active.id]);
    canPay = false;
  }

  @action
  void markMessageAsRead(int index) {
    if (!messages[index].read) {
      WarpApi.markMessageAsRead(messages[index].id, true);
      messages[index] = messages[index].withRead(true);
      unread = unread - 1;
      print("UNREAD $unread");
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

  Future<int?> prevInThread(int index) async {
    final message = messages[index];
    final dbr = DbReader(active.coin, active.id);
    return await dbr.getPrevMessage(message.subject, message.height, id);
  }

  Future<int?> nextInThread(int index) async {
    final message = messages[index];
    final dbr = DbReader(active.coin, active.id);
    return await dbr.getNextMessage(message.subject, message.height, id);
  }

  @action
  void setBanner(String msg) {
    banner = msg;
  }
}

Future<Backup> getBackup(AccountId account) async {
  final c = settings.coins[account.coin].def;
  final db = c.db;
  final List<Map> res = await db.rawQuery(
      "SELECT name, seed, aindex, sk, ivk FROM accounts WHERE id_account = ?1",
      [account.id]);
  if (res.isEmpty) throw Exception("Account N/A");
  // final share = await getShareInfo(account); // Multisig
  final row = res[0];
  final name = row['name'];
  final seed = row['seed'];
  final index = row['aindex'];
  final sk = row['sk'];
  final ivk = row['ivk'];
  int type = 0;
  if (seed != null)
    type = 0;
  else if (sk != null)
    type = 1;
  else if (ivk != null) type = 2;
  return Backup(type, name, seed, index, sk, ivk, null);
}
