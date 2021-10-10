import 'dart:isolate';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:convert/convert.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'generated/l10n.dart';
import 'main.dart';

part 'store.g.dart';

class Settings = _Settings with _$Settings;

abstract class _Settings with Store {
  @observable
  bool linkHooksInitialized = false;

  @observable
  String ldUrl = "";

  @observable
  String ldUrlChoice = "";

  @observable
  int anchorOffset = 10;

  @observable
  bool getTx = true;

  @observable
  int rowsPerPage = 10;

  @observable
  String theme = "";

  @observable
  String themeBrightness = "";

  @observable
  ThemeData themeData = ThemeData.light();

  @observable
  bool showConfirmations = false;

  @observable
  String currency = "USD";

  @observable
  List<String> currencies = ["USD"];

  @observable
  String chartRange = '1Y';

  @observable
  bool shieldBalance = false;

  @observable
  double autoShieldThreshold = 0.0;

  @observable
  bool useUA = false;

  @observable
  bool autoHide = true;

  @observable
  bool protectSend = false;

  @action
  Future<bool> restore() async {
    final prefs = await SharedPreferences.getInstance();
    linkHooksInitialized = prefs.getBool('link_hooks') ?? false;
    ldUrlChoice = prefs.getString('lightwalletd_choice') ?? "Lightwalletd";
    ldUrl = prefs.getString('lightwalletd_custom') ?? "";
    prefs.setString('lightwalletd_choice', ldUrlChoice);
    prefs.setString('lightwalletd_custom', ldUrl);
    anchorOffset = prefs.getInt('anchor_offset') ?? 3;
    getTx = prefs.getBool('get_txinfo') ?? true;
    rowsPerPage = prefs.getInt('rows_per_age') ?? 10;
    theme = prefs.getString('theme') ?? "gold";
    themeBrightness = prefs.getString('theme_brightness') ?? "dark";
    showConfirmations = prefs.getBool('show_confirmations') ?? false;
    currency = prefs.getString('currency') ?? "USD";
    chartRange = prefs.getString('chart_range') ?? "1Y";
    shieldBalance = prefs.getBool('shield_balance') ?? false;
    autoShieldThreshold = prefs.getDouble('autoshield_threshold') ?? 0.0;
    useUA = prefs.getBool('use_ua') ?? false;
    autoHide = prefs.getBool('auto_hide') ?? true;
    protectSend = prefs.getBool('protect_send') ?? false;
    _updateThemeData();
    Future.microtask(_loadCurrencies); // lazily
    return true;
  }

  @action
  Future<void> setLinkHooksInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    linkHooksInitialized = true;
    prefs.setBool('link_hooks', true);
  }

  @action
  Future<void> setURLChoice(String choice) async {
    ldUrlChoice = choice;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lightwalletd_choice', ldUrlChoice);
    updateLWD();
  }

  @action
  Future<void> setURL(String url) async {
    ldUrl = url;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lightwalletd_custom', ldUrl);
    updateLWD();
  }

  @action
  Future<void> setAnchorOffset(int offset) async {
    final prefs = await SharedPreferences.getInstance();
    anchorOffset = offset;
    prefs.setInt('anchor_offset', offset);
  }

  @action
  Future<void> setTheme(String thm) async {
    final prefs = await SharedPreferences.getInstance();
    theme = thm;
    prefs.setString('theme', thm);
    _updateThemeData();
  }

  @action
  Future<void> setThemeBrightness(String brightness) async {
    final prefs = await SharedPreferences.getInstance();
    themeBrightness = brightness;
    prefs.setString('theme_brightness', brightness);
    _updateThemeData();
  }

  void _updateThemeData() {
    FlexScheme scheme;
    switch (theme) {
      case 'gold':
        scheme = FlexScheme.mango;
        break;
      case 'blue':
        scheme = FlexScheme.bahamaBlue;
        break;
      case 'pink':
        scheme = FlexScheme.sakura;
        break;
      case 'purple':
        scheme = FlexScheme.deepPurple;
        break;
      default:
        scheme = FlexScheme.mango;
    }
    switch (themeBrightness) {
      case 'light':
        themeData = FlexColorScheme.light(scheme: scheme).toTheme;
        break;
      case 'dark':
        themeData = FlexColorScheme.dark(scheme: scheme).toTheme;
        break;
    }
  }

  @action
  Future<void> setChartRange(String v) async {
    final prefs = await SharedPreferences.getInstance();
    chartRange = v;
    prefs.setString('chart_range', chartRange);
    accountManager.fetchChartData();
  }

  String getLWD() {
    switch (ldUrlChoice) {
      case "custom":
        return ldUrl;
      default:
        return coin.lwd
            .firstWhere((lwd) => lwd.name == ldUrlChoice,
                orElse: () => coin.lwd.first)
            .url;
    }
  }

  void updateLWD() {
    WarpApi.updateLWD(getLWD());
  }

  @action
  Future<void> updateGetTx(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    getTx = v;
    prefs.setBool('get_txinfo', v);
  }

  @action
  Future<void> setRowsPerPage(int v) async {
    final prefs = await SharedPreferences.getInstance();
    rowsPerPage = v;
    prefs.setInt('rows_per_age', v);
  }

  @action
  Future<void> toggleShowConfirmations() async {
    final prefs = await SharedPreferences.getInstance();
    showConfirmations = !showConfirmations;
    prefs.setBool('show_confirmations', showConfirmations);
  }

  @action
  Future<void> setCurrency(String newCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    currency = newCurrency;
    prefs.setString('currency', currency);
    await priceStore.fetchZecPrice();
    await accountManager.fetchChartData();
  }

  @action
  Future<void> _loadCurrencies() async {
    final base = "api.coingecko.com";
    final uri = Uri.https(base, '/api/v3/simple/supported_vs_currencies');
    final rep = await http.get(uri);
    if (rep.statusCode == 200) {
      final _currencies = convert.jsonDecode(rep.body) as List<dynamic>;
      final c = _currencies.map((v) => (v as String).toUpperCase()).toList();
      c.sort();
      currencies = c;
    }
  }

  @action
  Future<void> setShieldBalance(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    shieldBalance = v;
    prefs.setBool('shield_balance', shieldBalance);
  }

  @action
  Future<void> setAutoShieldThreshold(double v) async {
    final prefs = await SharedPreferences.getInstance();
    autoShieldThreshold = v;
    prefs.setDouble('autoshield_threshold', autoShieldThreshold);
  }

  @action
  Future<void> setUseUA(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    useUA = v;
    prefs.setBool('use_ua', useUA);
  }

  @action
  Future<void> setAutoHide(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    autoHide = v;
    prefs.setBool('auto_hide', autoHide);
  }

  @action
  Future<void> setProtectSend(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    protectSend = v;
    prefs.setBool('protect_send', protectSend);
  }
}

class AccountManager = _AccountManager with _$AccountManager;

abstract class _AccountManager with Store {
  late Database db;

  @observable
  Account active = Account(0, "", "", 0);

  @observable
  bool canPay = false;

  @observable
  int balance = 0;

  @observable
  int unconfirmedBalance = 0;

  @observable
  String taddress = "";

  @observable
  bool showTAddr = false;

  @observable
  int tbalance = 0;

  @observable
  List<Note> notes = [];

  @observable
  List<Tx> txs = [];

  @observable
  int lastTxHeight = 0;

  @observable
  int dataEpoch = 0;

  @observable
  List<Spending> spendings = [];

  @observable
  List<TimeSeriesPoint<double>> accountBalances = [];

  @observable
  List<PnL> pnls = [];

  @observable
  List<Account> accounts = [];

  @observable
  SortConfig noteSortConfig = SortConfig("", SortOrder.Unsorted);

  @observable
  SortConfig txSortConfig = SortConfig("", SortOrder.Unsorted);

  @observable
  int pnlSeriesIndex = 0;

  @observable
  bool pnlDesc = false;

  Future<void> init(Database db) async {
    this.db = db;
    await resetToDefaultAccount();
  }

  Future<void> resetToDefaultAccount() async {
    await refresh();
    if (accounts.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final account = prefs.getInt('account') ?? accounts[0].id;
      setActiveAccountId(account);
    }
  }

  refresh() async {
    accounts = await _list();
  }

  @action
  Future<void> setActiveAccount(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('account', account.id);
    final List<Map> res1 = await db.rawQuery(
        "SELECT address FROM taddrs WHERE account = ?1", [account.id]);
    taddress = res1.isNotEmpty ? res1[0]['address'] : "";
    showTAddr = false;

    WarpApi.setMempoolAccount(account.id);
    final List<Map> res2 = await db.rawQuery(
        "SELECT sk FROM accounts WHERE id_account = ?1", [account.id]);
    canPay = res2.isNotEmpty && res2[0]['sk'] != null;
    active = account;

    balance = 0;
    tbalance = 0;
    await _fetchData(account.id, true);
  }

  @action
  Future<void> setActiveAccountId(int idAccount) async {
    final account = accounts.firstWhere((account) => account.id == idAccount,
        orElse: () => accounts[0]);
    await setActiveAccount(account);
  }

  String newAddress() {
    return WarpApi.newAddress(active.id);
  }

  Future<Backup> getBackup(int account) async {
    final List<Map> res = await db.rawQuery(
        "SELECT seed, sk, ivk FROM accounts WHERE id_account = ?1",
        [account]);
    if (res.isEmpty) throw Exception("Account N/A");
    final row = res[0];
    final seed = row['seed'];
    final sk = row['sk'];
    final ivk = row['ivk'];
    int type = 0;
    if (seed != null)
      type = 0;
    else if (sk != null)
      type = 1;
    else if (ivk != null) type = 2;
    return Backup(type, seed, sk, ivk);
  }

  Future<int> _getBalance(int accountId) async {
    final List<Map> res = await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND (spent IS NULL OR spent = 0)",
        [accountId]);
    if (res.isEmpty) return 0;
    return res[0]['value'] ?? 0;
  }

  Future<int> getShieldedBalance() async {
    return Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND spent IS NULL",
        [active.id])) ?? 0;
  }

  Future<int> getUnconfirmedSpentBalance() async {
    return Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND spent = 0",
        [active.id])) ?? 0;
  }

  Future<int> getUnderConfirmedBalance() async {
    final height = syncStatus.latestHeight - settings.anchorOffset;
    return Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND height > ?2",
        [active.id, height])) ?? 0;
  }

  Future<int> getExcludedBalance() async {
    final height = syncStatus.latestHeight - settings.anchorOffset;
    final amount = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) FROM received_notes WHERE account = ?1 AND spent IS NULL "
        "AND height <= ?2 AND excluded",
        [active.id, height])) ?? 0;
    return amount;
  }

  @action
  Future<void> updateUnconfirmedBalance() async {
    unconfirmedBalance = await WarpApi.mempoolSync();
  }

  isEmpty() async {
    final List<Map> res = await db.rawQuery("SELECT name FROM accounts", []);
    return res.isEmpty;
  }

  Future<List<Account>> _list() async {
    final List<Map> res = await db.rawQuery(
        "WITH notes AS (SELECT a.id_account, a.name, a.address, CASE WHEN r.spent IS NULL THEN r.value ELSE 0 END AS nv FROM accounts a LEFT JOIN received_notes r ON a.id_account = r.account) "
        "SELECT id_account, name, address, COALESCE(sum(nv), 0) AS balance FROM notes GROUP by id_account",
        []);
    return res
        .map((r) =>
            Account(r['id_account'], r['name'], r['address'], r['balance']))
        .toList();
  }

  @action
  Future<void> delete(int account) async {
    WarpApi.deleteAccount(account);
    if (account == active.id)
      resetToDefaultAccount();
  }

  @action
  Future<void> changeAccountName(String name) async {
    await db.execute("UPDATE accounts SET name = ?2 WHERE id_account = ?1",
        [active.id, name]);
    await refresh();
    await setActiveAccountId(active.id);
  }

  @action
  Future<void> updateBalance() async {
    balance = await _getBalance(active.id);
  }

  @action
  Future<void> fetchAccountData(bool force) async {
    await _fetchData(active.id, force);
  }

  @action
  void toggleShowTAddr() {
    showTAddr = !showTAddr;
  }

  Future<void> _fetchData(int accountId, bool force) async {
    await _updateBalance(accountId);
    await _updateTBalance(accountId);

    final hasNewTx = await _fetchNotesAndHistory(accountId, force);
    int countNewPrices = await WarpApi.syncHistoricalPrices(settings.currency);
    if (hasNewTx) {
      await _fetchSpending(accountId);
      await _fetchAccountBalanceTimeSeries(accountId);
    }
    if (countNewPrices > 0 || pnls.isEmpty || hasNewTx)
      await _fetchPNL(accountId);
  }

  final DateFormat noteDateFormat = DateFormat("yy-MM-dd HH:mm");
  final DateFormat txDateFormat = DateFormat("MM-dd HH:mm");

  Future<void> _updateBalance(int accountId) async {
    final _balance = await _getBalance(accountId);
    if (_balance == balance) return;
    balance = _balance;
    dataEpoch = DateTime.now().millisecondsSinceEpoch;
  }

  Future<bool> _fetchNotesAndHistory(int accountId, bool force) async {
    final List<Map> res0 = await db.rawQuery(
        "SELECT MAX(height) as height FROM transactions WHERE account = ?1",
        [accountId]);
    if (res0.isEmpty) return false;

    final _lastTxHeight = res0[0]['height'] ?? 0;
    if (!force && lastTxHeight == _lastTxHeight) return false;
    lastTxHeight = _lastTxHeight;

    final List<Map> res = await db.rawQuery(
        "SELECT n.id_note, n.height, n.value, t.timestamp, n.excluded, n.spent FROM received_notes n, transactions t "
        "WHERE n.account = ?1 AND (n.spent IS NULL OR n.spent = 0) "
        "AND n.tx = t.id_tx ORDER BY n.height DESC",
        [accountId]);
    notes = res.map((row) {
      final id = row['id_note'];
      final height = row['height'];
      final timestamp = noteDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      final excluded = (row['excluded'] ?? 0) != 0;
      final spent = row['spent'] == 0;
      return Note(
          id, height, timestamp, row['value'] / ZECUNIT, excluded, spent);
    }).toList();

    final List<Map> res2 = await db.rawQuery(
        "SELECT id_tx, txid, height, timestamp, t.address, c.name, value, memo FROM transactions t "
        "LEFT JOIN contacts c ON t.address = c.address WHERE account = ?1 ORDER BY height DESC",
        [accountId]);
    txs = res2.map((row) {
      Uint8List txid = row['txid'];
      final fullTxId = hex.encode(txid.reversed.toList());
      final shortTxid = fullTxId.substring(0, 8);
      final timestamp = txDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      return Tx(row['id_tx'], row['height'], timestamp, shortTxid, fullTxId,
          row['value'] / ZECUNIT, row['address'] ?? "", row['name'], row['memo'] ?? "");
    }).toList();

    dataEpoch = DateTime.now().millisecondsSinceEpoch;
    return true;
  }

  @computed
  List<Note> get sortedNotes {
    var notes2 = [...notes];
    switch (noteSortConfig.field) {
      case "time": return _sort(notes2, (Note note) => note.height, noteSortConfig.order);
      case "amount": return _sort(notes2, (Note note) => note.value, noteSortConfig.order);
    }
    return notes2;
  }

  @action
  Future<void> sortNotes(String field) async {
    noteSortConfig.sortOn(field);
  }

  @computed
  List<Tx> get sortedTxs {
    var txs2 = [...txs];
    switch (txSortConfig.field) {
      case "time": return _sort(txs2, (Tx tx) => tx.height, txSortConfig.order);
      case "amount": return _sort(txs2, (Tx tx) => tx.value, txSortConfig.order);
      case "txid": return _sort(txs2, (Tx tx) => tx.txid, txSortConfig.order);
      case "address": return _sort(txs2, (Tx tx) => tx.contact ?? tx.address, txSortConfig.order);
      case "memo": return _sort(txs2, (Tx tx) => tx.memo, txSortConfig.order);
    }
    return txs2;
  }

  @action
  Future<void> sortTx(String field) async {
    txSortConfig.sortOn(field);
  }

  List<C>  _sort<C extends HasHeight, T extends Comparable>(List<C> txs, T Function(C) project, SortOrder order) {
    switch (order) {
      case SortOrder.Ascending:
        txs.sort((a, b) => project(a).compareTo(project(b)));
        break;
      case SortOrder.Descending:
        txs.sort((a, b) => -project(a).compareTo(project(b)));
        break;
      case SortOrder.Unsorted:
        txs.sort((a, b) => -a.height.compareTo(b.height));
        break;
    }
    return txs;
  }

  TimeRange getChartRange() {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final start = today.add(Duration(days: -chartRangeInt()));
    final cutoff = start.millisecondsSinceEpoch;
    return TimeRange(cutoff, today.millisecondsSinceEpoch);
  }

  Future<void> _fetchSpending(int accountId) async {
    final range = getChartRange();
    final List<Map> res = await db.rawQuery(
        "SELECT SUM(value) as v, t.address, c.name FROM transactions t LEFT JOIN contacts c ON t.address = c.address "
        "WHERE account = ?1 AND timestamp >= ?2 AND value < 0 GROUP BY t.address ORDER BY v ASC LIMIT 5",
        [accountId, range.start ~/ 1000]);
    spendings = res.map((row) {
      final address = row['address'] ?? "";
      final value = -row['v'] / ZECUNIT;
      final contact = row['name'];
      return Spending(address, value, contact);
    }).toList();
  }

  Future<void> _fetchAccountBalanceTimeSeries(int accountId) async {
    final range = getChartRange();
    final List<Map> res = await db.rawQuery(
        "SELECT timestamp, value FROM transactions WHERE account = ?1 AND timestamp >= ?2 ORDER BY timestamp DESC",
        [accountId, range.start ~/ 1000]);
    List<AccountBalance> _accountBalances = [];
    var b = balance;
    _accountBalances.add(AccountBalance(DateTime.now(), b / ZECUNIT));
    for (var row in res) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final value = row['value'] as int;
      final ab = AccountBalance(timestamp, b / ZECUNIT);
      _accountBalances.add(ab);
      b -= value;
    }
    _accountBalances.add(AccountBalance(DateTime.fromMillisecondsSinceEpoch(range.start), b / ZECUNIT));
    _accountBalances = _accountBalances.reversed.toList();
    accountBalances = sampleDaily<AccountBalance, double, double>(
        _accountBalances,
        range.start,
        range.end,
        (AccountBalance ab) => ab.time.millisecondsSinceEpoch ~/ DAY_MS,
        (AccountBalance ab) => ab.balance,
        (acc, v) => v,
        0.0);
  }

  @action
  Future<void> fetchChartData() async {
    await _fetchPNL(active.id);
    await _fetchSpending(active.id);
    await _fetchAccountBalanceTimeSeries(active.id);
  }

  int chartRangeInt() {
    switch (settings.chartRange) {
      case '1M':
        return 30;
      case '3M':
        return 90;
      case '6M':
        return 180;
    }
    return 365;
  }

  Future<void> _fetchPNL(int accountId) async {
    final range = getChartRange();

    final List<Map> res1 = await db.rawQuery(
        "SELECT timestamp, value FROM transactions WHERE timestamp >= ?2 AND account = ?1",
        [accountId, range.start ~/ 1000]);
    final List<Trade> trades = [];
    for (var row in res1) {
      final dt = DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final qty = row['value'] / ZECUNIT;
      trades.add(Trade(dt, qty));
    }

    final portfolioTimeSeries = sampleDaily<Trade, Trade, double>(
        trades,
        range.start,
        range.end,
        (t) => t.dt.millisecondsSinceEpoch ~/ DAY_MS,
        (t) => t,
        (acc, t) => acc + t.qty,
        0.0);

    final List<Map> res2 = await db.rawQuery(
        "SELECT timestamp, price FROM historical_prices WHERE timestamp >= ?2 AND currency = ?1",
        [settings.currency, range.start ~/ 1000]);
    final List<Quote> quotes = [];
    for (var row in res2) {
      final dt = DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final price = row['price'];
      quotes.add(Quote(dt, price));
    }

    var prevBalance = 0.0;
    var cash = 0.0;
    var realized = 0.0;
    final List<PnL> _pnls = [];
    final len = math.min(quotes.length, portfolioTimeSeries.length);
    for (var i = 0; i < len; i++) {
      final dt = quotes[i].dt;
      final price = quotes[i].price;
      final balance = portfolioTimeSeries[i].value;
      final qty = balance - prevBalance;

      final closeQty = qty * balance < 0
          ? math.min(qty.abs(), prevBalance.abs()) * qty.sign
          : 0.0;
      final openQty = qty - closeQty;
      final avgPrice = prevBalance != 0 ? cash / prevBalance : 0.0;

      cash += openQty * price + closeQty * avgPrice;
      realized += closeQty * (avgPrice - price);
      final unrealized = price * balance - cash;

      final pnl = PnL(dt, price, balance, realized, unrealized);
      _pnls.add(pnl);

      prevBalance = balance;
    }
    pnls = _pnls;
  }

  @action
  void togglePnlDesc() {
    pnlDesc = !pnlDesc;
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
  Future<void> convertToWatchOnly() async {
    await db.rawUpdate(
        "UPDATE accounts SET seed = NULL, sk = NULL WHERE id_account = ?1",
        [active.id]);
    canPay = false;
  }

  @action
  Future<void> excludeNote(Note note) async {
    await db.execute(
        "UPDATE received_notes SET excluded = ?2 WHERE id_note = ?1",
        [note.id, note.excluded]);
  }

  @action
  Future<void> updateTBalance() async {
    _updateTBalance(active.id);
  }

  _updateTBalance(int accountId) {
    int balance = WarpApi.getTBalance(accountId);
    if (balance != tbalance) tbalance = balance;
  }

  void autoshield() {
    if (settings.autoShieldThreshold != 0.0 && tbalance / ZECUNIT >= settings.autoShieldThreshold) {
      WarpApi.shieldTAddr(active.id);
    }
  }

  @action
  void setPnlSeriesIndex(int index) {
    pnlSeriesIndex = index;
  }

  Future<Map<int, int>> getAllTBalances() async {
    final Map<int, int> balances = {};
    for (var a in accounts) {
      final b = await WarpApi.getTBalanceAsync(a.id);
      balances[a.id] = b;
    }

    return balances;
  }
}

class Account {
  final int id;
  final String name;
  final String address;
  final int balance;

  Account(this.id, this.name, this.address, this.balance);
}

class PriceStore = _PriceStore with _$PriceStore;

abstract class _PriceStore with Store {
  @observable
  double zecPrice = 0.0;

  @action
  Future<void> fetchZecPrice() async {
    final base = "api.coingecko.com";
    final uri = Uri.https(base, '/api/v3/simple/price',
        {'ids': coin.currency, 'vs_currencies': settings.currency});
    final rep = await http.get(uri);
    if (rep.statusCode == 200) {
      final json = convert.jsonDecode(rep.body) as Map<String, dynamic>;
      final p = json[coin.currency][settings.currency.toLowerCase()];
      zecPrice = (p is double) ? p : (p as int).toDouble();
    } else
      zecPrice = 0.0;
  }
}

class SyncStatus = _SyncStatus with _$SyncStatus;

abstract class _SyncStatus with Store {
  late Database _db;

  init() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zec.db');
    _db = await openDatabase(path);
    await update();
  }

  @observable
  bool accountRestored = false;

  @observable
  bool syncing = false;

  @observable
  int syncedHeight = -1;

  @observable
  int latestHeight = 0;

  bool isSynced() {
    return syncedHeight < 0 || syncedHeight == latestHeight;
  }

  @action
  setSyncHeight(int height) {
    syncedHeight = height;
  }

  @action
  Future<bool> update() async {
    latestHeight = await WarpApi.getLatestHeight();
    final _syncedHeight = Sqflite.firstIntValue(
            await _db.rawQuery("SELECT MAX(height) FROM blocks")) ??
        0;
    if (_syncedHeight > 0) setSyncHeight(_syncedHeight);
    return syncedHeight == latestHeight;
  }

  @action
  Future<void> sync(BuildContext context) async {
    eta.reset();
    syncing = true;
    final snackBar =
    SnackBar(content: Text(S
        .of(context)
        .rescanRequested));
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    setSyncHeight(0);
    WarpApi.rewindToHeight(0);
    WarpApi.truncateData();
    contacts.markContactsDirty(false);
    await syncStatus.update();
    final params = SyncParams(settings.getTx, settings.anchorOffset, syncPort.sendPort);
    await compute(WarpApi.warpSync, params);
    syncing = false;
    eta.reset();
  }

  @action
  void setAccountRestored(bool v) {
    accountRestored = v;
  }

  @action
  void setSyncedToLatestHeight() {
    setSyncHeight(latestHeight);
    WarpApi.skipToLastHeight();
  }
}

class MultiPayStore = _MultiPayStore with _$MultiPayStore;

abstract class _MultiPayStore with Store {
  @observable
  ObservableList<Recipient> recipients = ObservableList.of([]);

  @action
  void addRecipient(Recipient recipient) {
    recipients.add(recipient);
  }

  @action
  void removeRecipient(int index) {
    recipients.removeAt(index);
  }

  @action
  void clear() {
    recipients.clear();
  }
}

class ETAStore = _ETAStore with _$ETAStore;

abstract class _ETAStore with Store {
  @observable
  ETACheckpoint? prev;

  @observable
  ETACheckpoint? current;

  @action
  void reset() {
    prev = null;
    current = null;
  }

  @action
  void checkpoint(int height, DateTime timestamp) {
    prev = current;
    current = ETACheckpoint(height, timestamp);
  }

  @computed
  String get eta {
    final p = prev;
    final c = current;
    if (p == null || c == null) return "";
    if (c.timestamp.millisecondsSinceEpoch == p.timestamp.millisecondsSinceEpoch) return "";
    final speed = (c.height - p.height) / (c.timestamp.millisecondsSinceEpoch - p.timestamp.millisecondsSinceEpoch);
    if (speed == 0) return "";
    final eta = (syncStatus.latestHeight - c.height) / speed;
    if (eta <= 0) return "";
    final duration = Duration(milliseconds: eta.floor()).toString().split('.')[0];
    return "(ETA: $duration)";
  }
}

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {
  late Database db;

  @observable
  bool dirty = false;

  @observable
  ObservableList<Contact> contacts = ObservableList<Contact>.of([]);

  Future<void> init(Database db) async {
    this.db = db;
    final prefs = await SharedPreferences.getInstance();
    dirty = prefs.getBool('contacts_dirty') ?? false;
  }

  @action
  Future<void> fetchContacts() async {
    await _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    List<Map> res = await db.rawQuery(
        "SELECT id, name, address FROM contacts WHERE address <> '' ORDER BY name");
    contacts.clear();
    for (var c in res) {
      final contact = Contact(c['id'], c['name'], c['address']);
      contacts.add(contact);
    }
  }

  @action
  Future<void> markContactsDirty(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    dirty = v;
    prefs.setBool('contacts_dirty', dirty);
  }

  @action
  Future<void> add(Contact c) async {
    WarpApi.storeContact(c.id, c.name, c.address, true);
    await markContactsDirty(true);
    await _fetchContacts();
  }

  @action
  Future<void> remove(Contact c) async {
    contacts.removeWhere((contact) => contact.id == c.id);
    WarpApi.storeContact(c.id, c.name, "", true);
    await markContactsDirty(true);
    await _fetchContacts();
  }
}

class ETACheckpoint {
  int height;
  DateTime timestamp;

  ETACheckpoint(this.height, this.timestamp);
}

var progressPort = ReceivePort();
var progressStream = progressPort.asBroadcastStream();

var syncPort = ReceivePort();
var syncStream = syncPort.asBroadcastStream();

abstract class HasHeight {
  int height = 0;
}

class Note extends HasHeight {
  int id;
  int height;
  String timestamp;
  double value;
  bool excluded;
  bool spent;

  Note(this.id, this.height, this.timestamp, this.value, this.excluded,
      this.spent);
}

class Tx extends HasHeight {
  int id;
  int height;
  String timestamp;
  String txid;
  String fullTxId;
  double value;
  String address;
  String? contact;
  String memo;

  Tx(this.id, this.height, this.timestamp, this.txid, this.fullTxId, this.value,
      this.address, this.contact, this.memo);
}

class Spending {
  final String address;
  final double amount;
  final String? contact;

  Spending(this.address, this.amount, this.contact);
}

class AccountBalance {
  final DateTime time;
  final double balance;

  AccountBalance(this.time, this.balance);
}

class Backup {
  int type;
  final String? seed;
  final String? sk;
  final String ivk;

  Backup(this.type, this.seed, this.sk, this.ivk);

  String value() {
    switch (type) {
      case 0:
        return seed!;
      case 1:
        return sk!;
      case 2:
        return ivk;
    }
    return "";
  }
}

class Contact {
  final int id;
  final String name;
  final String address;

  Contact(this.id, this.name, this.address);

  factory Contact.empty() => Contact(0, "", "");
}

enum SortOrder {
  Unsorted,
  Ascending,
  Descending,
}

SortOrder nextSortOrder(SortOrder order) =>
    SortOrder.values[(order.index + 1) % 3];

@JsonSerializable()
class Recipient {
  final String address;
  final int amount;
  final String memo;

  Recipient(this.address, this.amount, this.memo);

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

class PnL {
  final DateTime timestamp;
  final double price;
  final double amount;
  final double realized;
  final double unrealized;

  PnL(this.timestamp, this.price, this.amount, this.realized, this.unrealized);

  @override
  String toString() {
    return "$timestamp $price $amount $realized $unrealized";
  }
}

class TimeSeriesPoint<V> {
  final int day;
  final V value;

  TimeSeriesPoint(this.day, this.value);
}

class Trade {
  final DateTime dt;
  final qty;

  Trade(this.dt, this.qty);
}

class Portfolio {
  final DateTime dt;
  final qty;

  Portfolio(this.dt, this.qty);
}

class Quote {
  final DateTime dt;
  final price;

  Quote(this.dt, this.price);
}

class TimeRange {
  final int start;
  final int end;

  TimeRange(this.start, this.end);
}

class SortConfig {
  @observable
  String field;

  @observable
  SortOrder order;

  SortConfig(this.field, this.order);

  @action
  void sortOn(String field) {
    if (field != this.field)
      order = SortOrder.Ascending;
    else
      order = nextSortOrder(order);
    this.field = field;
  }

  String getIndicator(String field) {
    if (this.field != field) return '';
    if (order == SortOrder.Ascending)
      return ' \u2191';
    if (order == SortOrder.Descending)
      return ' \u2193';
    return '';
  }
}

@JsonSerializable()
class DecodedPaymentURI {
  String address;
  int amount;
  String memo;

  DecodedPaymentURI(this.address, this.amount, this.memo);

  factory DecodedPaymentURI.fromJson(Map<String, dynamic> json) =>
      _$DecodedPaymentURIFromJson(json);

  Map<String, dynamic> toJson() => _$DecodedPaymentURIToJson(this);
}

class SendPageArgs {
  final Contact? contact;
  final String? uri;

  SendPageArgs({this.contact, this.uri});
}
