import 'dart:isolate';
import 'dart:typed_data';

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
  ThemeData themeData;

  @action
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final prefMode = prefs.getString('theme') ?? "light";
    ldUrlChoice = prefs.getString('lightwalletd_choice') ?? "lightwalletd";
    ldUrl = prefs.getString('lightwalletd_custom') ?? "";
    prefs.setString('lightwalletd_choice', ldUrlChoice);
    prefs.setString('lightwalletd_custom', ldUrl);
    anchorOffset = prefs.getInt('anchor_offset') ?? 3;
    getTx = prefs.getBool('get_txinfo') ?? true;
    rowsPerPage = prefs.getInt('rows_per_age') ?? 10;
    theme = prefs.getString('theme') ?? "zcash";
    themeBrightness = prefs.getString('theme_brightness') ?? "dark";
    _updateThemeData();
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
      case 'zcash': scheme = FlexScheme.mango; break;
      case 'blue': scheme = FlexScheme.bahamaBlue; break;
      case 'pink': scheme = FlexScheme.sakura; break;
      case 'coffee': scheme = FlexScheme.espresso; break;
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
  int tbalance = 0;

  @observable
  List<Note> notes = [];

  @observable
  List<Tx> txs = [];

  @observable
  List<Account> accounts = [];

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
    if (res1.isNotEmpty) taddress = res1[0]['address'];

    WarpApi.setMempoolAccount(account.id);
    final List<Map> res2 = await db.rawQuery(
        "SELECT sk FROM accounts WHERE id_account = ?1", [account.id]);
    canPay = res2.isNotEmpty && res2[0]['sk'] != null;
    await _fetchNotesAndHistory(account.id);
    active = account;
    print("Active account = ${account.id}");
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

  Future<String> getBackup() async {
    final List<Map> res = await db.rawQuery(
        "SELECT seed, sk, ivk FROM accounts WHERE id_account = ?1",
        [active.id]);
    if (res.isEmpty) return null;
    final row = res[0];
    final backup = row['seed'] ?? row['sk'] ?? row['ivk'];
    return backup;
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
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND (spent IS NULL OR spent = 0) AND height <= ?2",
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
  Future<void> updateBalance() async {
    if (active == null) return;
    balance = await _getBalance(active.id);
  }

  @action
  Future<void> fetchNotesAndHistory() async {
    if (active == null) return;
    await _fetchNotesAndHistory(active.id);
  }

  final DateFormat noteDateFormat = DateFormat("yy-MM-dd HH:mm");
  final DateFormat txDateFormat = DateFormat("MM-dd HH:mm");

  Future<void> _updateBalance(int accountId) async {
    balance = await _getBalance(accountId);
  }

  @action
  Future<void> _fetchNotesAndHistory(int accountId) async {
    await _updateBalance(accountId);
    final List<Map> res = await db.rawQuery(
        "SELECT n.height, n.value, t.timestamp FROM received_notes n, transactions t WHERE n.account = ?1 AND (n.spent IS NULL OR n.spent = 0) AND n.tx = t.id_tx",
        [accountId]);
    notes = res.map((row) {
      final height = row['height'];
      final timestamp = noteDateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      return Note(height, timestamp, row['value'] / ZECUNIT);
    }).toList();

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
  }

  @action
  Future<void> convertToWatchOnly() async {
    await db.rawUpdate(
        "UPDATE accounts SET seed = NULL, sk = NULL WHERE id_account = ?1",
        [active.id]);
    canPay = false;
  }

  void updateTBalance() {
    if (active == null) return;
    int balance = WarpApi.getTBalance(active.id);
    if (balance != tbalance) tbalance = balance;
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
    final base = "api.binance.com";
    final uri = Uri.https(base, '/api/v3/avgPrice', {'symbol': 'ZECUSDT'});
    final rep = await http.get(uri);
    if (rep.statusCode == 200) {
      final json = convert.jsonDecode(rep.body) as Map<String, dynamic>;
      final price = double.parse(json['price']);
      zecPrice = price;
    }
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
    final _syncedHeight = Sqflite.firstIntValue(
            await _db.rawQuery("SELECT MAX(height) FROM blocks")) ??
        0;
    if (_syncedHeight > 0) syncedHeight = _syncedHeight;
    latestHeight = await WarpApi.getLatestHeight();
    print("$syncedHeight / $latestHeight");
    return syncedHeight == latestHeight;
  }
}

var progressPort = ReceivePort();
var progressStream = progressPort.asBroadcastStream();

class Note {
  int height;
  String timestamp;
  double value;

  Note(this.height, this.timestamp, this.value);
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
