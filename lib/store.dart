import 'dart:isolate';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:json_annotation/json_annotation.dart';

import 'package:charts_flutter/flutter.dart' as charts show MaterialPalette;
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

import 'main.dart';

part 'store.g.dart';

class Settings = _Settings with _$Settings;

abstract class _Settings with Store {
  @observable
  String ldUrl;

  @observable
  String ldUrlChoice;

  @observable
  int anchorOffset;

  @observable
  bool getTx;

  @observable
  int rowsPerPage;

  @observable
  String theme;

  @observable
  String themeBrightness;

  @observable
  ThemeData themeData = ThemeData.light();

  @observable
  bool showConfirmations = false;

  @observable
  String currency = "USD";

  @observable
  List<String> currencies = ["USD"];

  var palette = charts.MaterialPalette.blue;

  @action
  Future<bool> restore() async {
    final prefs = await SharedPreferences.getInstance();
    ldUrlChoice = prefs.getString('lightwalletd_choice') ?? "lightwalletd";
    ldUrl = prefs.getString('lightwalletd_custom') ?? "";
    prefs.setString('lightwalletd_choice', ldUrlChoice);
    prefs.setString('lightwalletd_custom', ldUrl);
    anchorOffset = prefs.getInt('anchor_offset') ?? 3;
    getTx = prefs.getBool('get_txinfo') ?? true;
    rowsPerPage = prefs.getInt('rows_per_age') ?? 10;
    theme = prefs.getString('theme') ?? "zcash";
    themeBrightness = prefs.getString('theme_brightness') ?? "dark";
    showConfirmations = prefs.getBool('show_confirmations') ?? false;
    currency = prefs.getString('currency') ?? "USD";
    _updateThemeData();
    Future.microtask(_loadCurrencies); // lazily
    return true;
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
    print(brightness);
    final prefs = await SharedPreferences.getInstance();
    themeBrightness = brightness;
    prefs.setString('theme_brightness', brightness);
    _updateThemeData();
  }

  void _updateThemeData() {
    FlexScheme scheme;
    switch (theme) {
      case 'zcash':
        scheme = FlexScheme.mango;
        palette = charts.MaterialPalette.gray;
        break;
      case 'blue':
        scheme = FlexScheme.bahamaBlue;
        palette = charts.MaterialPalette.blue;
        break;
      case 'pink':
        scheme = FlexScheme.sakura;
        palette = charts.MaterialPalette.pink;
        break;
      case 'coffee':
        scheme = FlexScheme.espresso;
        palette = charts.MaterialPalette.gray;
        break;
    }
    switch (themeBrightness) {
      case 'light': themeData = FlexColorScheme.light(scheme: scheme).toTheme; break;
      case 'dark': themeData = FlexColorScheme.dark(scheme: scheme).toTheme; break;
    }
  }

  String getLWD() {
    switch (ldUrlChoice) {
      case "custom": return ldUrl;
      case "lightwalletd": return "https://mainnet.lightwalletd.com:9067";
      case "zecwallet": return "https://lwdv3.zecwallet.co";
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
    await accountManager.fetchCashFlows();
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
}

class AccountManager = _AccountManager with _$AccountManager;

abstract class _AccountManager with Store {
  Database db;

  @observable
  Account active;

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
  int dataEpoch = 0;

  @observable
  List<Spending> spendings = [];

  @observable
  List<AccountBalance> accountBalances = [];

  @observable
  List<PnL> pnls = [];

  @observable
  List<Account> accounts = [];

  @observable
  SortOrder noteSortOrder = SortOrder.Unsorted;

  @observable
  SortOrder txSortOrder = SortOrder.Unsorted;

  @observable
  int pnlSeriesIndex = 0;

  @observable
  List<Contact> contacts = [];

  Future<void> init() async {
    db = await getDatabase();
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
    if (account == null) return;
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
    print("Active account = ${account.id}");
    await _fetchData(account.id);
  }

  @action
  Future<void> setActiveAccountId(int idAccount) async {
    final account = accounts.firstWhere((account) => account.id == idAccount,
        orElse: () => accounts.isNotEmpty ? accounts[0] : null);
    await setActiveAccount(account);
  }

  String newAddress() {
    return WarpApi.newAddress(active.id);
  }

  Future<Backup> getBackup() async {
    final List<Map> res = await db.rawQuery(
        "SELECT seed, sk, ivk FROM accounts WHERE id_account = ?1",
        [active.id]);
    if (res.isEmpty) return null;
    final row = res[0];
    final seed = row['seed'];
    final sk = row['sk'];
    final ivk = row['ivk'];
    int type;
    if (seed != null) type = 0;
    else if (sk != null) type = 1;
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

  Future<int> getBalanceSpendable(int height) async {
    final List<Map> res = await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND (spent IS NULL OR spent = 0) "
            "AND height <= ?2 AND (excluded IS NULL OR NOT excluded)",
        [active.id, height]);
    if (res.isEmpty) return 0;
    return res[0]['value'] ?? 0;
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
    await db.rawDelete("DELETE FROM accounts WHERE id_account = ?1", [account]);
    await db.rawDelete("DELETE FROM taddrs WHERE account = ?1", [account]);
  }

  @action
  Future<void> changeAccountName(String name) async {
    await db.execute("UPDATE accounts SET name = ?2 WHERE id_account = ?1", [active.id, name]);
    await refresh();
    await setActiveAccountId(active.id);
  }

  @action
  Future<void> updateBalance() async {
    if (active == null) return;
    balance = await _getBalance(active.id);
  }

  @action
  Future<void> fetchAccountData() async {
    if (active == null) return;
    await _fetchData(active.id);
  }

  @action
  Future<void> fetchCashFlows() async {
    if (active == null) return;
    await _fetchCashFlows(active.id);
  }

  @action
  void toggleShowTAddr() {
    showTAddr = !showTAddr;
  }

  Future<void> _fetchData(int accountId) async {
    await _fetchNotesAndHistory(accountId);
    await _fetchSpending(accountId);
    await _fetchAccountBalanceTimeSeries(accountId);
    await _fetchContacts(accountId);
    int countNewPrices = await WarpApi.syncHistoricalPrices(settings.currency);
    if (countNewPrices > 0 || pnls.isEmpty)
      await _fetchCashFlows(accountId);
    dataEpoch = DateTime.now().millisecondsSinceEpoch;
  }

  final DateFormat noteDateFormat = DateFormat("yy-MM-dd HH:mm");
  final DateFormat txDateFormat = DateFormat("MM-dd HH:mm");

  Future<void> _updateBalance(int accountId) async {
    balance = await _getBalance(accountId);
  }

  Future<void> _fetchNotesAndHistory(int accountId) async {
    await _updateBalance(accountId);
    final List<Map> res = await db.rawQuery(
        "SELECT n.id_note, n.height, n.value, t.timestamp, n.excluded FROM received_notes n, transactions t "
            "WHERE n.account = ?1 AND (n.spent IS NULL OR n.spent = 0) "
            "AND n.tx = t.id_tx",
        [accountId]);
    notes = res.map((row) {
      final id = row['id_note'];
      final height = row['height'];
      final timestamp = noteDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      final excluded = (row['excluded'] ?? 0) != 0;
      return Note(id, height, timestamp, row['value'] / ZECUNIT, excluded);
    }).toList();
    _sortNoteAmount(noteSortOrder);

    final List<Map> res2 = await db.rawQuery(
        "SELECT id_tx, txid, height, timestamp, address, value, memo FROM transactions WHERE account = ?1",
        [accountId]);
    txs = res2.map((row) {
      Uint8List txid = row['txid'];
      final fullTxId = hex.encode(txid.reversed.toList());
      final shortTxid = fullTxId.substring(0, 8);
      final timestamp = txDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      return Tx(row['id_tx'], row['height'], timestamp, shortTxid, fullTxId, row['value'] / ZECUNIT, row['address'], row['memo']);
    }).toList();
    _sortTxAmount(txSortOrder);
  }

  @action
  Future<void> sortNoteAmount() async {
    noteSortOrder = nextSortOrder(noteSortOrder);
    _sortNoteAmount(noteSortOrder);
  }

  void _sortNoteAmount(SortOrder order) {
    switch (order) {
      case SortOrder.Ascending:
        notes.sort((a, b) => a.value.compareTo(b.value));
        break;
      case SortOrder.Descending:
        notes.sort((a, b) => -a.value.compareTo(b.value));
        break;
      case SortOrder.Unsorted:
        notes.sort((a, b) => -a.height.compareTo(b.height));
        break;
    }
  }

  @action
  Future<void> sortTxAmount() async {
    txSortOrder = nextSortOrder(txSortOrder);
    _sortTxAmount(txSortOrder);
  }

  void _sortTxAmount(SortOrder order) {
    switch (order) {
      case SortOrder.Ascending:
        txs.sort((a, b) => a.value.compareTo(b.value));
        break;
      case SortOrder.Descending:
        txs.sort((a, b) => -a.value.compareTo(b.value));
        break;
      case SortOrder.Unsorted:
        txs.sort((a, b) => -a.height.compareTo(b.height));
        break;
    }
  }

  Future<void> _fetchSpending(int accountId) async {
    final cutoff = DateTime.now().add(Duration(days: -30)).millisecondsSinceEpoch / 1000;
    final List<Map> res = await db.rawQuery(
        "SELECT SUM(value) as v, address FROM transactions WHERE account = ?1 AND timestamp >= ?2 AND value < 0 GROUP BY address ORDER BY v ASC LIMIT 10",
        [accountId, cutoff]);
    spendings = res.map((row) {
      final address = row['address'] ?? "";
      final value = -row['v'] / ZECUNIT;
      return Spending(addressLeftTrim(address), value);
    }).toList();
  }

  Future<void> _fetchAccountBalanceTimeSeries(int accountId) async {
    final cutoff = DateTime.now().add(Duration(days: -30)).millisecondsSinceEpoch / 1000;
    final List<Map> res = await db.rawQuery(
        "SELECT timestamp, value FROM transactions WHERE account = ?1 AND timestamp >= ?2 ORDER BY timestamp DESC",
        [accountId, cutoff]);
    accountBalances = [];
    var b = balance;
    accountBalances.add(AccountBalance(DateTime.now(), b / ZECUNIT));
    for (var row in res) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final value = row['value'];
      final ab = AccountBalance(timestamp, b / ZECUNIT);
      accountBalances.add(ab);
      b -= value;
    }
  }

  Future<void> _fetchCashFlows(int accountId) async {
    final cutoff = DateTime.now().add(Duration(days: -365)).millisecondsSinceEpoch / 1000;
    final List<Map> res = await db.rawQuery(
        "WITH t AS (SELECT value, timestamp/86400 AS day FROM transactions WHERE account = ?1), p AS (SELECT price, timestamp, timestamp/86400 AS day FROM historical_prices WHERE currency = ?3) "
        "SELECT t.value, p.price, p.timestamp FROM t, p WHERE t.day = p.day AND p.timestamp >= ?2 ORDER BY p.day",
        [accountId, cutoff, settings.currency]);
    var cash = 0.0;
    var balance = 0.0;
    var realized = 0.0;

    Map<int, PnL> pnlMap = {};

    for (var row in res) {
      final ts = row['timestamp'];
      final value = (row['value'] / ZECUNIT) as double;
      final price = row['price'] as double;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

      final closeQty = value * balance < 0 ? math.min(value.abs(), balance.abs()) * value.sign : 0.0;
      final openQty = value - closeQty;
      final avgPrice = balance != 0 ? cash / balance : 0.0;
      cash += openQty * price + closeQty * avgPrice;
      realized += closeQty * (price - avgPrice);
      balance += value;
      final unrealized = price * balance - cash;

      pnlMap[ts] = PnL(timestamp, price, balance, realized, unrealized);
    }

    final _pnls = pnlMap.values.toList();
    _pnls.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    pnls = _pnls;
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

  void updateTBalance() {
    if (active == null) return;
    int balance = WarpApi.getTBalance(active.id);
    if (balance != tbalance) tbalance = balance;
  }

  Future<void> _fetchContacts(int accountId) async {
    List<Map> res = await db.rawQuery("SELECT name, address FROM contacts WHERE account = ?1 ORDER BY name", [accountId]);
    contacts = [];
    for (var c in res) {
      final contact = Contact(c['name'], c['address']);
      contacts.add(contact);
    }
  }

  @action
  void setPnlSeriesIndex(int index) {
    pnlSeriesIndex = index;
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
    final uri = Uri.https(base, '/api/v3/simple/price', {'ids': 'zcash', 'vs_currencies': settings.currency});
    final rep = await http.get(uri);
    if (rep.statusCode == 200) {
      final json = convert.jsonDecode(rep.body) as Map<String, dynamic>;
      final p = json['zcash'][settings.currency.toLowerCase()];
      zecPrice = (p is double) ? p : (p as int).toDouble();
    }
    else zecPrice = 0.0;
  }
}

class SyncStatus = _SyncStatus with _$SyncStatus;

abstract class _SyncStatus with Store {
  Database _db;

  init() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zec.db');
    _db = await openDatabase(path);
    await update();
  }

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
    if (_syncedHeight > 0) syncedHeight = _syncedHeight;
    return syncedHeight == latestHeight;
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

var progressPort = ReceivePort();
var progressStream = progressPort.asBroadcastStream();

class Note {
  int id;
  int height;
  String timestamp;
  double value;
  bool excluded;

  Note(this.id, this.height, this.timestamp, this.value, this.excluded);
}

class Tx {
  int id;
  int height;
  String timestamp;
  String txid;
  String fullTxId;
  double value;
  String address;
  String memo;

  Tx(this.id, this.height, this.timestamp, this.txid, this.fullTxId, this.value, this.address, this.memo);
}

class Spending {
  final String address;
  final double amount;

  Spending(this.address, this.amount);
}

class AccountBalance {
  final DateTime time;
  final double balance;

  AccountBalance(this.time, this.balance);
}

class Backup {
  int type;
  final String seed;
  final String sk;
  final String ivk;

  Backup(this.type, this.seed, this.sk, this.ivk);

  String value() {
    switch (type) {
      case 0: return seed;
      case 1: return sk;
      case 2: return ivk;
    }
    return "";
  }
}

class Contact {
  final String name;
  final String address;

  Contact(this.name, this.address);
}

String addressLeftTrim(String address) => "..." + address.substring(math.max(address.length - 6, 0));

enum SortOrder {
  Unsorted,
  Ascending,
  Descending,
}

SortOrder nextSortOrder(SortOrder order) => SortOrder.values[(order.index + 1) % 3];

@JsonSerializable()
class Recipient {
  final String address;
  final int amount;
  final String memo;

  Recipient(this.address, this.amount, this.memo);

  factory Recipient.fromJson(Map<String, dynamic> json) => _$RecipientFromJson(json);
  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

class PnL {
  final DateTime timestamp;
  final double price;
  final double amount;
  final double realized;
  final double unrealized;

  PnL(this.timestamp, this.price, this.amount, this.realized, this.unrealized);
}
