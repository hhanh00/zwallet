import 'dart:math';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/types.dart';
import 'accounts.dart';
import 'store.dart';
import 'package:warp_api/warp_api.dart';
import 'package:convert/convert.dart';
import 'main.dart';

final DateFormat noteDateFormat = DateFormat("yy-MM-dd HH:mm");
final DateFormat txDateFormat = DateFormat("MM-dd HH:mm");
final DateFormat msgDateFormat = DateFormat("MM-dd HH:mm");
final DateFormat msgDateFormatFull = DateFormat("yy-MM-dd HH:mm:ss");

class DbReader {
  int coin;
  int id;
  Database db;

  DbReader(int coin, int id): this.init(coin, id, settings.coins[coin].def.db);
  DbReader.init(this.coin, this.id, this.db);

  Future<bool> hasAccount() async {
    final List<Map> res = await db.rawQuery(
        "SELECT 1 FROM accounts",
        []);
    return res.isNotEmpty;
  }

  Future<List<Account>> getAccountList() async {
    List<Account> accounts = [];

    final List<Map> res = await db.rawQuery(
        "WITH notes AS (SELECT a.id_account, a.name, CASE WHEN r.spent IS NULL THEN r.value ELSE 0 END AS nv FROM accounts a LEFT JOIN received_notes r ON a.id_account = r.account),"
            "accounts2 AS (SELECT id_account, name, COALESCE(sum(nv), 0) AS balance FROM notes GROUP by id_account) "
            "SELECT a.id_account, a.name, a.balance FROM accounts2 a",
        []);
    for (var r in res) {
      final int id = r['id_account'];
      final account = Account(
          coin,
          id,
          r['name'],
          r['balance'],
          0,
          null);
      accounts.add(account);
    }
    return accounts;
  }

  // check that the account still exists
  // if not, pick any account
  // if there are none, return 0
  Future<AccountId?> getAvailableAccountId() async {
    final List<Map> res1 = await db.rawQuery(
        "SELECT 1 FROM accounts WHERE id_account = ?1", [id]);
    if (res1.isNotEmpty)
      return AccountId(coin, id);
    final List<Map> res2 = await db.rawQuery(
        "SELECT id_account FROM accounts", []);
    if (res2.isNotEmpty) {
      final id = res2[0]['id_account'];
      return AccountId(coin, id);
    }
    return null;
  }

  Future<String> getTAddr() async {
    final List<Map> res1 = await db.rawQuery(
        "SELECT address FROM taddrs WHERE account = ?1", [id]);
    final taddress = res1.isNotEmpty ? res1[0]['address'] : "";
    return taddress;
  }

  Future<String?> getSK() async {
    final List<Map> res1 = await db.rawQuery(
        "SELECT sk FROM accounts WHERE id_account = ?1", [id]);
    final sk = res1.isNotEmpty ? res1[0]['address'] : null;
    return sk;
  }

  Future<void> changeAccountName(String name) async {
    await db.execute("UPDATE accounts SET name = ?2 WHERE id_account = ?1",
        [id, name]);
  }

  Future<BlockInfo?> getDbSyncedHeight() async {
    final rows = await db.rawQuery("SELECT height, timestamp FROM blocks WHERE height = (SELECT MAX(height) FROM blocks)");
    if (rows.isNotEmpty) {
      final row = rows.first;
      final height = row['height'] as int;
      final timestampEpoch = row['timestamp'] as int;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampEpoch * 1000);
      final blockInfo = BlockInfo(height, timestamp);
      return blockInfo;
    }
    return null;
  }

  Future<void> updateBalances(int confirmHeight, Balances balances) async {
    final balance = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND (spent IS NULL OR spent = 0)",
        [id])) ?? 0;
    final shieldedBalance = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND spent IS NULL",
        [id])) ?? 0;
    final unconfirmedSpentBalance = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND spent = 0",
        [id])) ?? 0;
    final underConfirmedBalance = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) AS value FROM received_notes WHERE account = ?1 AND spent IS NULL AND height > ?2",
        [id, confirmHeight])) ?? 0;
    final excludedBalance = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(value) FROM received_notes WHERE account = ?1 AND spent IS NULL "
            "AND height <= ?2 AND excluded",
        [id, confirmHeight])) ?? 0;

    balances.update(balance, shieldedBalance, unconfirmedSpentBalance, underConfirmedBalance, excludedBalance);
  }

  Future<int> getSaplingBalance() async {
    return Sqflite.firstIntValue(await db.rawQuery("SELECT SUM(value) FROM received_notes WHERE account = ?1 AND spent IS NULL AND orchard = 0",
      [id])) ?? 0;
  }

  Future<int> getOrchardBalance() async {
    return Sqflite.firstIntValue(await db.rawQuery("SELECT SUM(value) FROM received_notes WHERE account = ?1 AND spent IS NULL AND orchard = 1",
      [id])) ?? 0;
  }

  Future<List<Note>> getNotes() async {
    final List<Map> res = await db.rawQuery(
        "SELECT n.id_note, n.height, n.value, t.timestamp, n.orchard, n.excluded, n.spent FROM received_notes n, transactions t "
            "WHERE n.account = ?1 AND (n.spent IS NULL OR n.spent = 0) "
            "AND n.tx = t.id_tx ORDER BY n.height DESC",
        [id]);
    final notes = res.map((row) {
      final id = row['id_note'];
      final height = row['height'];
      final timestamp = DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final orchard = row['orchard'] != 0;
      final excluded = (row['excluded'] ?? 0) != 0;
      final spent = row['spent'] == 0;
      return Note(
          id, height, timestamp, row['value'] / ZECUNIT, orchard, excluded, spent);
    }).toList();
    print("NOTES ${notes.length}");
    return notes;
  }

  Future<List<Tx>> getTxs() async {
    final List<Map> res2 = await db.rawQuery(
        "SELECT id_tx, txid, height, timestamp, t.address, c.name AS cname, a.name AS aname, value, memo FROM transactions t "
        "LEFT JOIN contacts c ON t.address = c.address "
        "LEFT JOIN accounts a ON a.address = t.address "
        "WHERE account = ?1 ORDER BY height DESC",
        [id]);
    final txs = res2.map((row) {
      Uint8List txid = row['txid'];
      final fullTxId = hex.encode(txid.reversed.toList());
      final shortTxid = fullTxId.substring(0, 8);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final String? contactName = row['cname'];
      final String? accountName = row['aname'];
      final name = contactName ?? accountName;
      return Tx(
          row['id_tx'],
          row['height'],
          timestamp,
          shortTxid,
          fullTxId,
          row['value'] / ZECUNIT,
          row['address'] ?? "",
          name,
          row['memo'] ?? "");
    }).toList();
    print("TXS ${txs.length}");
    return txs;
  }

  Future<List<PnL>> getPNL(int accountId) async {
    final range = _getChartRange();

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
    final List<PnL> pnls = [];
    final len = min(quotes.length, portfolioTimeSeries.length);
    for (var i = 0; i < len; i++) {
      final dt = quotes[i].dt;
      final price = quotes[i].price;
      final balance = portfolioTimeSeries[i].value;
      final qty = balance - prevBalance;

      final closeQty = qty * balance < 0
          ? min(qty.abs(), prevBalance.abs()) * qty.sign
          : 0.0;
      final openQty = qty - closeQty;
      final avgPrice = prevBalance != 0 ? cash / prevBalance : 0.0;

      cash += openQty * price + closeQty * avgPrice;
      realized += closeQty * (avgPrice - price);
      final unrealized = price * balance - cash;

      final pnl = PnL(dt, price, balance, realized, unrealized);
      pnls.add(pnl);

      prevBalance = balance;
    }
    return pnls;
  }

  Future<List<Spending>> getSpending(int accountId) async {
    final range = _getChartRange();
    final List<Map> res = await db.rawQuery(
        "SELECT SUM(value) as v, t.address, c.name FROM transactions t LEFT JOIN contacts c ON t.address = c.address "
            "WHERE account = ?1 AND timestamp >= ?2 AND value < 0 GROUP BY t.address ORDER BY v ASC LIMIT 5",
        [accountId, range.start ~/ 1000]);
    final spendings = res.map((row) {
      final address = row['address'] ?? "";
      final value = -row['v'] / ZECUNIT;
      final contact = row['name'];
      return Spending(address, value, contact);
    }).toList();
    return spendings;
  }

  Future<List<TimeSeriesPoint<double>>> getAccountBalanceTimeSeries(int accountId, int balance) async {
    final range = _getChartRange();
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
    _accountBalances.add(AccountBalance(
        DateTime.fromMillisecondsSinceEpoch(range.start), b / ZECUNIT));
    _accountBalances = _accountBalances.reversed.toList();
    final accountBalances = sampleDaily<AccountBalance, double, double>(
        _accountBalances,
        range.start,
        range.end,
            (AccountBalance ab) => ab.time.millisecondsSinceEpoch ~/ DAY_MS,
            (AccountBalance ab) => ab.balance,
            (acc, v) => v,
        0.0);
    return accountBalances;
  }

  Future<List<ZMessage>> getMessages() async {
    final List<Map> res = await db.rawQuery(
        "SELECT m.id, m.id_tx, m.timestamp, m.sender, m.recipient, m.incoming, c.name as scontact, a.name as saccount, c2.name as rcontact, a2.name as raccount, "
        "subject, body, height, read FROM messages m "
        "LEFT JOIN contacts c ON m.sender = c.address "
        "LEFT JOIN accounts a ON m.sender = a.address "
        "LEFT JOIN contacts c2 ON m.recipient = c2.address "
        "LEFT JOIN accounts a2 ON m.recipient = a2.address "
        "WHERE account = ?1 ORDER BY timestamp DESC",
        [id]);
    List<ZMessage> messages = [];
    for (var row in res) {
      final id = row['id'];
      final txId = row['id_tx'] ?? 0;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(row['timestamp'] * 1000);
      final height = row['height'];
      final sender = row['sender'];
      final from = row['scontact'] ?? row['saccount'] ?? sender;
      final recipient = row['recipient'];
      final to = row['rcontact'] ?? row['raccount'] ?? recipient;
      final subject = row['subject'];
      final body = row['body'];
      final read = row['read'] == 1;
      final incoming = row['incoming'] == 1;
      messages.add(ZMessage(id, txId, incoming, from, to, subject, body, timestamp, height, read));
    }
    return messages;
  }

  Future<int?> getPrevMessage(String subject, int height, int account) async {
    final id = await Sqflite.firstIntValue(await db.rawQuery(
        "SELECT MAX(id) FROM messages WHERE subject = ?1 AND height < ?2 and account = ?3",
        [subject, height, account]));
    return id;
  }

  Future<int?> getNextMessage(String subject, int height, int account) async {
    final id = await Sqflite.firstIntValue(await db.rawQuery(
        "SELECT MIN(id) FROM messages WHERE subject = ?1 AND height > ?2 and account = ?3",
        [subject, height, account]));
    return id;
  }

  Future<List<TAccount>> getTAccounts() async {
    final List<Map> res = await db.rawQuery(
        "SELECT aindex, address, value FROM taddr_scan", []);
    List<TAccount> accounts = [];
    for (var row in res) {
      final aindex = row['aindex'];
      final address = row['address'];
      final balance = row['value'];
      final account = TAccount(aindex, address, balance);
      accounts.add(account);
    }
    db.execute("DELETE FROM taddr_scan");
    return accounts;
  }

  TimeRange _getChartRange() {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final start = today.add(Duration(days: -_chartRangeDays()));
    final cutoff = start.millisecondsSinceEpoch;
    return TimeRange(cutoff, today.millisecondsSinceEpoch);
  }

  Future<List<SendTemplateId>> loadTemplates() async {
    final List<Map> res = await db.rawQuery(
        "SELECT id_send_template, title FROM send_templates", []);
    List<SendTemplateId> templateIds = [];
    for (var row in res) {
      final id = row['id_send_template'];
      final title = row['title'];
      final templateId = SendTemplateId(id, title);
      templateIds.add(templateId);
    }
    return templateIds;
  }

  Future<SendTemplate?> loadTemplate(int id) async {
    final List<Map> res = await db.rawQuery(
        "SELECT title, address, amount, fiat_amount, fee_included, fiat, include_reply_to, subject, body "
        "FROM send_templates WHERE id_send_template = ?1", [id]);
    for (var row in res) {
      final title = row['title'];
      final address = row['address'];
      final amount = row['amount'];
      final num fiat_amount = row['fiat_amount'];
      final fee_included = row['fee_included'] != 0;
      final fiat = row['fiat'];
      final include_reply_to = row['include_reply_to'] != 0;
      final subject = row['subject'];
      final body = row['body'];
      final memo = Memo(include_reply_to, subject, body);
      final template = SendTemplate(id, title, address, amount, fiat_amount.toDouble(), fee_included, fiat, memo);
      return template;
    }
  }

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    List<Map> res = await db.rawQuery(
        "SELECT id, name, address FROM contacts WHERE address <> '' ORDER BY name");
    for (var c in res) {
      final contact = Contact(c['id'], c['name'], c['address']);
      contacts.add(contact);
    }
    return contacts;
  }

  int _chartRangeDays() {
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
}

class ZMessage {
  final int id;
  final int txId;
  final bool incoming;
  final String? sender;
  final String recipient;
  final String subject;
  final String body;
  final DateTime timestamp;
  final int height;
  final bool read;

  ZMessage(this.id, this.txId, this.incoming, this.sender, this.recipient, this.subject, this.body, this.timestamp, this.height, this.read);

  ZMessage withRead(bool v) {
    return ZMessage(id, txId, incoming, sender, recipient, subject, body, timestamp, height, v);
  }

  String fromto() => incoming ? "\u{21e6} ${sender != null ? centerTrim(sender!) : ''}" : "\u{21e8} ${centerTrim(recipient)}";
}

class TAccount {
  final int aindex;
  final String address;
  final int balance;
  TAccount(this.aindex, this.address, this.balance);
}
