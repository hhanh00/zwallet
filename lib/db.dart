import 'dart:math';

import 'package:intl/intl.dart';
import 'package:warp_api/data_fb_generated.dart' hide Quote;
import 'store.dart';
import 'package:warp_api/warp_api.dart';
import 'main.dart';

final DateFormat noteDateFormat = DateFormat("yy-MM-dd HH:mm");
final DateFormat txDateFormat = DateFormat("MM-dd HH:mm");
final DateFormat msgDateFormat = DateFormat("MM-dd HH:mm");
final DateFormat msgDateFormatFull = DateFormat("yy-MM-dd HH:mm:ss");

class DbReader {
  int coin;
  int id;

  DbReader(int coin, int id) : this.init(coin, id);
  DbReader.init(this.coin, this.id);

  Future<List<Note>> getNotes(int? latestHeight) async {
    final ns = await WarpApi.getNotes(coin, id);
    final notes = ns.map((n) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(n.timestamp * 1000);
      return Note.from(latestHeight, n.id, n.height, timestamp,
          n.value / ZECUNIT, n.orchard, n.excluded);
    }).toList();
    print("NOTES ${notes.length}");
    return notes;
  }

  Future<List<Tx>> getTxs(int? latestHeight) async {
    final txs = await WarpApi.getTxs(coin, id);
    final transactions = txs.map((tx) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000);
      return Tx.from(latestHeight, tx.id, tx.height, timestamp, tx.shortTxId!,
          tx.txId!, tx.value / ZECUNIT, tx.address, tx.name, tx.memo);
    }).toList();
    print("TXS ${transactions.length}");
    return transactions;
  }

  List<PnL> getPNL(int accountId) {
    final range = _getChartRange();

    final List<Trade> trades = [];
    for (var row in WarpApi.getPnLTxs(coin, id, range.start ~/ 1000)) {
      final dt = DateTime.fromMillisecondsSinceEpoch(row.timestamp * 1000);
      final qty = row.value / ZECUNIT;
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

    final List<Quote> quotes = [];
    for (var row
        in WarpApi.getQuotes(coin, range.start ~/ 1000, settings.currency)) {
      final dt = DateTime.fromMillisecondsSinceEpoch(row.timestamp * 1000);
      final price = row.price;
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

  List<Spending> getSpending(int accountId) {
    final range = _getChartRange();
    return WarpApi.getSpendings(coin, id, range.start ~/ 1000);
  }

  List<TimeSeriesPoint<double>> getAccountBalanceTimeSeries(
      int accountId, int balance) {
    final range = _getChartRange();
    final trades = WarpApi.getPnLTxs(coin, id, range.start ~/ 1000);
    List<AccountBalance> _accountBalances = [];
    var b = balance;
    _accountBalances.add(AccountBalance(DateTime.now(), b / ZECUNIT));
    for (var trade in trades) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(trade.timestamp * 1000);
      final value = trade.value;
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
    final messages = await WarpApi.getMessages(coin, id);
    return messages
        .map((m) => ZMessage(
            m.idMsg,
            m.idTx,
            m.incoming,
            m.from,
            m.to!,
            m.subject!,
            m.body!,
            DateTime.fromMillisecondsSinceEpoch(m.timestamp * 1000),
            m.height,
            m.read))
        .toList();
  }

  // Future<List<TAccount>> getTAccounts() async {
  //   final List<Map> res = await db.rawQuery(
  //       "SELECT aindex, address, value FROM taddr_scan", []);
  //   List<TAccount> accounts = [];
  //   for (var row in res) {
  //     final aindex = row['aindex'];
  //     final address = row['address'];
  //     final balance = row['value'];
  //     final account = TAccount(aindex, address, balance);
  //     accounts.add(account);
  //   }
  //   db.execute("DELETE FROM taddr_scan");
  //   return accounts;
  // }

  TimeRange _getChartRange() {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final start = today.add(Duration(days: -_chartRangeDays()));
    final cutoff = start.millisecondsSinceEpoch;
    return TimeRange(cutoff, today.millisecondsSinceEpoch);
  }

  List<SendTemplateT> loadTemplates() {
    final templates = WarpApi.getSendTemplates(coin);
    return templates;
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

class ZMessage extends HasHeight {
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

  ZMessage(this.id, this.txId, this.incoming, this.sender, this.recipient,
      this.subject, this.body, this.timestamp, this.height, this.read);

  ZMessage withRead(bool v) {
    return ZMessage(id, txId, incoming, sender, recipient, subject, body,
        timestamp, height, v);
  }

  String fromto() => incoming
      ? "\u{21e6} ${sender != null ? centerTrim(sender!) : ''}"
      : "\u{21e8} ${centerTrim(recipient)}";
}
