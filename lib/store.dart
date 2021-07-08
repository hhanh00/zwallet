import 'dart:isolate';

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

import 'main.dart';

part 'store.g.dart';

class Settings = _Settings with _$Settings;

abstract class _Settings with Store {
  @observable
  ThemeMode mode;

  nextMode() {
    return mode == ThemeMode.light ? "Dark Mode" : "Light Mode";
  }

  @action
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final prefMode = prefs.getString('theme') ?? "light";
    if (prefMode == "light")
      mode = ThemeMode.light;
    else
      mode = ThemeMode.dark;
  }

  @action
  Future<void> toggle() async {
    mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', mode == ThemeMode.light ? "light" : "dark");
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
    this.active = account;
    WarpApi.setMempoolAccount(account.id);
    final List<Map> res = await db
        .rawQuery("SELECT sk FROM accounts WHERE id_account = ?1", [active.id]);
    canPay = res.isNotEmpty && res[0]['sk'] != null;
    await fetchNotesAndHistory();
  }

  @action
  setActiveAccountId(int idAccount) {
    final account = accounts.firstWhere((account) => account.id == idAccount,
        orElse: () => accounts.isNotEmpty ? accounts[0] : null);
    setActiveAccount(account);
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

  Future<int> _getBalance() async {
    final List<Map> res = await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND (spent IS NULL OR spent = 0)",
        [active.id]);
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
  }

  @action
  Future<void> updateBalance() async {
    if (active == null) return;
    balance = await _getBalance();
  }

  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @action
  Future<void> fetchNotesAndHistory() async {
    if (active == null) return;
    await updateBalance();
    final List<Map> res = await db.rawQuery(
        "SELECT n.height, n.value, t.timestamp FROM received_notes n, transactions t WHERE n.account = ?1 AND (n.spent IS NULL OR n.spent = 0) AND n.tx = t.id_tx",
        [active.id]);
    notes = res.map((row) {
      final height = row['height'];
      final timestamp = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      return Note(height, timestamp, row['value'] / ZECUNIT);
    }).toList();

    final List<Map> res2 = await db.rawQuery(
        "SELECT txid, height, timestamp, value FROM transactions WHERE account = ?1",
        [active.id]);
    txs = res2.map((row) {
      final txid = hex.encode(row['txid']).substring(0, 8);
      final timestamp = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000));
      return Tx(row['height'], timestamp, txid, row['value'] / ZECUNIT);
    }).toList();
  }

  @action
  Future<void> convertToWatchOnly() async {
    await db.rawUpdate("UPDATE accounts SET seed = NULL, sk = NULL WHERE id_account = ?1", [active.id]);
    canPay = false;
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
  int height;
  String timestamp;
  String txid;
  double value;

  Tx(this.height, this.timestamp, this.txid, this.value);
}
