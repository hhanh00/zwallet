import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:warp_api/data_fb_generated.dart' hide Quote;
import 'appsettings.dart';
import 'coin/coins.dart';
import 'package:mobx/mobx.dart';
import 'package:warp_api/warp_api.dart';

import 'pages/utils.dart';

part 'accounts.g.dart';

final ActiveAccount2 nullAccount =
    ActiveAccount2(0, 0, "", null, false, false, false);

ActiveAccount2 aa = nullAccount;

AASequence aaSequence = AASequence();
class AASequence = _AASequence with _$AASequence;

abstract class _AASequence with Store {
  @observable
  int seqno = 0;

  @observable
  int settingsSeqno = 0;
}

void setActiveAccount(int coin, int id) {
  coinSettings = CoinSettingsExtension.load(coin);
  aa = ActiveAccount2.fromId(coin, id);
  coinSettings.account = id;
  coinSettings.save(coin);
  aa.updateDivisified();
  aa.update(null);
  aaSequence.seqno = DateTime.now().microsecondsSinceEpoch;
}

class ActiveAccount2 extends _ActiveAccount2 with _$ActiveAccount2 {
  ActiveAccount2(super.coin, super.id, super.name, super.seed, super.canPay,
      super.external, super.saved);

  static ActiveAccount2? fromPrefs(SharedPreferences prefs) {
    final coin = prefs.getInt('coin') ?? 0;
    var id = prefs.getInt('account') ?? 0;
    if (WarpApi.checkAccount(coin, id)) return ActiveAccount2.fromId(coin, id);
    for (var c in coins) {
      final id = WarpApi.getFirstAccount(c.coin);
      if (id > 0) return ActiveAccount2.fromId(c.coin, id);
    }
    return null;
  }

  Future<void> save(SharedPreferences prefs) async {
    await prefs.setInt('coin', coin);
    await prefs.setInt('account', id);
  }

  factory ActiveAccount2.fromId(int coin, int id) {
    if (id == 0) return nullAccount;
    final c = coins[coin];
    final backup = WarpApi.getBackup(coin, id);
    final external =
        c.supportsLedger && !isMobile() && WarpApi.ledgerHasAccount(coin, id);
    final canPay = backup.sk != null || external;
    return ActiveAccount2(
        coin, id, backup.name!, backup.seed, canPay, external, backup.saved);
  }

  bool get hasUA => coins[coin].supportsUA;
}

abstract class _ActiveAccount2 with Store {
  final int coin;
  final int id;
  final String name;
  final String? seed;
  final bool canPay;
  final bool external;
  final bool saved;

  _ActiveAccount2(this.coin, this.id, this.name, this.seed, this.canPay,
      this.external, this.saved)
      : notes = Notes(coin, id),
        txs = Txs(coin, id),
        messages = Messages(coin, id);

  @observable
  String diversifiedAddress = '';

  @observable
  int height = 0;

  @observable
  String currency = '';

  @observable
  PoolBalanceT poolBalances = PoolBalanceT();
  Notes notes;
  Txs txs;
  Messages messages;

  List<Spending> spendings = [];
  List<TimeSeriesPoint<double>> accountBalances = [];

  @action
  void reset(int resetHeight) {
    poolBalances = PoolBalanceT();
    notes.clear();
    txs.clear();
    messages.clear();
    spendings = [];
    accountBalances = [];
    height = resetHeight;
  }

  @action
  void updatePoolBalances() {
    poolBalances = WarpApi.getPoolBalances(coin, id, 0, true).unpack();
  }

  @action
  void updateDivisified() {
    if (id == 0) return;
    try {
      diversifiedAddress = WarpApi.getDiversifiedAddress(coin, id,
          coinSettings.uaType, DateTime.now().millisecondsSinceEpoch ~/ 1000);
    } catch (e) {}
  }

  @action
  void update(int? newHeight) {
    if (id == 0) return;
    updateDivisified();
    updatePoolBalances();

    notes.read(newHeight);
    txs.read(newHeight);
    messages.read(newHeight);

    currency = appSettings.currency;

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final start =
        today.add(Duration(days: -365)).millisecondsSinceEpoch ~/ 1000;
    final end = today.millisecondsSinceEpoch ~/ 1000;
    spendings = WarpApi.getSpendings(coin, id, start);

    final trades = WarpApi.getPnLTxs(coin, id, start);
    List<AccountBalance> abs = [];
    var b = poolBalances.orchard + poolBalances.sapling;
    abs.add(AccountBalance(DateTime.now(), b / ZECUNIT));
    for (var trade in trades) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(trade.timestamp * 1000);
      final value = trade.value;
      final ab = AccountBalance(timestamp, b / ZECUNIT);
      abs.add(ab);
      b -= value;
    }
    abs.add(AccountBalance(
        DateTime.fromMillisecondsSinceEpoch(start * 1000), b / ZECUNIT));
    accountBalances = sampleDaily<AccountBalance, double, double>(
        abs.reversed,
        start,
        end,
        (AccountBalance ab) => ab.time.millisecondsSinceEpoch ~/ DAY_MS,
        (AccountBalance ab) => ab.balance,
        (acc, v) => v,
        0.0);

    if (newHeight != null) height = newHeight;
  }
}

class Notes extends _Notes with _$Notes {
  Notes(super.coin, super.id);
}

abstract class _Notes with Store {
  final int coin;
  final int id;
  _Notes(this.coin, this.id);

  @observable
  List<Note> items = [];
  SortConfig2? order;

  @action
  void read(int? height) {
    final shieledNotes = WarpApi.getNotesSync(coin, id);
    items = shieledNotes.map((n) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(n.timestamp * 1000);
      return Note.from(height, n.id, n.height, timestamp, n.value / ZECUNIT,
          n.orchard, n.excluded, false);
    }).toList();
  }

  @action
  void clear() {
    items.clear();
  }

  @action
  void invert() {
    WarpApi.invertExcluded(coin, id);
    items = items.map((n) => n.invertExcluded).toList();
  }

  @action
  void exclude(Note note) {
    WarpApi.updateExcluded(coin, note.id, note.excluded);
    items = List.of(items);
  }

  @action
  void setSortOrder(String field) {
    final r = _sort(field, order, items);
    order = r.item1;
    items = r.item2;
  }
}

class Txs extends _Txs with _$Txs {
  Txs(super.coin, super.id);
}

abstract class _Txs with Store {
  final int coin;
  final int id;
  _Txs(this.coin, this.id);

  @observable
  List<Tx> items = [];
  SortConfig2? order;

  @action
  void read(int? height) {
    final shieldedTxs = WarpApi.getTxsSync(coin, id);
    items = shieldedTxs.map((tx) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000);
      return Tx.from(
          height,
          tx.id,
          tx.height,
          timestamp,
          tx.shortTxId!,
          tx.txId!,
          tx.value / ZECUNIT,
          tx.address,
          tx.name,
          tx.memo,
          tx.messages?.memos ?? []);
    }).toList();
  }

  @action
  void clear() {
    items.clear();
  }

  @action
  void setSortOrder(String field) {
    final r = _sort(field, order, items);
    order = r.item1;
    items = r.item2;
  }
}

class Messages extends _Messages with _$Messages {
  Messages(super.coin, super.id);
}

abstract class _Messages with Store {
  final int coin;
  final int id;
  _Messages(this.coin, this.id);

  @observable
  List<ZMessage> items = [];
  SortConfig2? order;

  @action
  void read(int? height) {
    final ms = WarpApi.getMessagesSync(coin, id);
    items = ms
        .map((m) => ZMessage(
            m.idMsg,
            m.idTx,
            m.incoming,
            m.sender,
            m.from,
            m.to!,
            m.subject!,
            m.body!,
            DateTime.fromMillisecondsSinceEpoch(m.timestamp * 1000),
            m.height,
            m.read))
        .toList();
  }

  @action
  void clear() {
    items.clear();
  }

  @action
  void setSortOrder(String field) {
    final r = _sort(field, order, items);
    order = r.item1;
    items = r.item2;
  }
}

Tuple2<SortConfig2?, List<T>> _sort<T extends HasHeight>(
    String field, SortConfig2? order, List<T> items) {
  if (order == null)
    order = SortConfig2(field, 1);
  else
    order = order.next(field);

  final o = order;
  if (o == null)
    items.sort((a, b) => b.height.compareTo(a.height));
  else {
    items.sort((a, b) {
      final ra = reflector.reflect(a);
      final va = ra.invokeGetter(field)! as dynamic;
      final rb = reflector.reflect(b);
      final vb = rb.invokeGetter(field)! as dynamic;
      return va.compareTo(vb) * o.orderBy;
    });
  }
  return Tuple2(o, items);
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

List<PnL> getPNL(
    int start, int end, Iterable<TxTimeValue> tvs, Iterable<Quote> quotes) {
  final trades = tvs.map((tv) {
    final dt = DateTime.fromMillisecondsSinceEpoch(tv.timestamp * 1000);
    final qty = tv.value / ZECUNIT;
    return Trade(dt, qty);
  });

  final portfolioTimeSeries = sampleDaily<Trade, Trade, double>(
      trades,
      start,
      end,
      (t) => t.dt.millisecondsSinceEpoch ~/ DAY_MS,
      (t) => t,
      (acc, t) => acc + t.qty,
      0.0);

  var prevBalance = 0.0;
  var cash = 0.0;
  var realized = 0.0;
  final len = min(quotes.length, portfolioTimeSeries.length);

  final z = ZipStream.zip2<Quote, TimeSeriesPoint<double>,
      Tuple2<Quote, TimeSeriesPoint<double>>>(
    Stream.fromIterable(quotes),
    Stream.fromIterable(portfolioTimeSeries),
    (a, b) => Tuple2(a, b),
  ).take(len);

  List<PnL> pnls = [];
  z.listen((qv) {
    final dt = qv.item1.dt;
    final price = qv.item1.price;
    final balance = qv.item2.value;
    final qty = balance - prevBalance;

    final closeQty =
        qty * balance < 0 ? min(qty.abs(), prevBalance.abs()) * qty.sign : 0.0;
    final openQty = qty - closeQty;
    final avgPrice = prevBalance != 0 ? cash / prevBalance : 0.0;

    cash += openQty * price + closeQty * avgPrice;
    realized += closeQty * (avgPrice - price);
    final unrealized = price * balance - cash;

    final pnl = PnL(dt, price, balance, realized, unrealized);
    pnls.add(pnl);

    prevBalance = balance;
  });
  return pnls;
}
