import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';
import 'appsettings.dart';
import 'coin/coins.dart';
import 'package:mobx/mobx.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import 'pages/utils.dart';
import 'store.dart';

part 'accounts.g.dart';

final ActiveAccount nullAccount =
    ActiveAccount(0, 0, "", null, false, false);

ActiveAccount aa = nullAccount;

AASequence aaSequence = AASequence();
class AASequence = _AASequence with _$AASequence;

abstract class _AASequence with Store {
  @observable
  int seqno = 0;

  @observable
  int settingsSeqno = 0;
}

Future<void> setActiveAccount(int coin, int id) async {
  coinSettings = await CoinSettingsExtension.load(coin);
  runInAction(() {
    aa = ActiveAccount.fromId(coin, id);
    coinSettings.account = id;
    coinSettings.save(coin);
    aa.updateDivisified();
    aa.update(MAXHEIGHT);
    aaSequence.seqno = DateTime.now().microsecondsSinceEpoch;
  });
}

class ActiveAccount extends _ActiveAccount with _$ActiveAccount {
  ActiveAccount(super.coin, super.id, super.name, super.seed,
      super.external, super.saved);

  static Future<ActiveAccount?> fromPrefs(SharedPreferences prefs) async {
    final coin = prefs.getInt('coin') ?? 0;
    var id = prefs.getInt('account') ?? 0;
    final accounts = await warp.listAccounts(coin);
    final a =
        accounts.singleWhere((a) => a.id == id, orElse: () => AccountNameT());
    if (a.id != 0) return ActiveAccount.fromId(coin, id);
    for (var c in coins) {
      final accounts = await warp.listAccounts(coin);
      if (accounts.isNotEmpty)
        return ActiveAccount.fromId(c.coin, accounts[0].id);
    }
    return null;
  }

  Future<void> reload() async {
    await setActiveAccount(aa.coin, aa.id);
  }

  Future<void> save() async {
    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setInt('coin', coin);
    await prefs.setInt('account', id);
  }

  factory ActiveAccount.fromId(int coin, int id) {
    if (id == 0) return nullAccount;
    final backup = warp.getBackup(coin, id);
    final external = false;
    // TODO: Ledger -> c.supportsLedger && !isMobile() && WarpApi.ledgerHasAccount(coin, id);`
    return ActiveAccount(
        coin, id, backup.name!, backup.seed, external, backup.saved);
  }

  bool get hasUA => coins[coin].supportsUA;
}

abstract class _ActiveAccount with Store {
  final int coin;
  final int id;
  final String name;
  final String? seed;
  final bool external;
  final bool saved;

  _ActiveAccount(this.coin, this.id, this.name, this.seed,
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

  Notes notes;
  Txs txs;
  Messages messages;

  List<SpendingT> spendings = [];
  List<TimeSeriesPoint<double>> accountBalances = [];

  @action
  void reset(int resetHeight) {
    notes.clear();
    txs.clear();
    messages.clear();
    spendings = [];
    accountBalances = [];
    height = resetHeight;
  }

  @action
  void updateDivisified() {
    if (id == 0) return;
    try {
      diversifiedAddress =
          warp.getAccountAddress(coin, id, now(), coinSettings.uaType | 8);
    } catch (e) {}
  }

  Future<void> update(int newHeight) async {
    if (id == 0) return;
    updateDivisified();

    notes.read(newHeight);
    txs.read(newHeight);
    messages.read(newHeight);

    currency = appSettings.currency;

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final start =
        today.add(Duration(days: -365)).millisecondsSinceEpoch ~/ 1000;
    final end = today.millisecondsSinceEpoch ~/ 1000;
    spendings = await warp.getSpendings(coin, id, start);

    List<AccountBalance> abs = [];
    final balance = warp.getBalance(aa.coin, aa.id, syncStatus.confirmHeight);
    var b = balance.orchard + balance.sapling;
    abs.add(AccountBalance(DateTime.now(), b / ZECUNIT));
    for (var trade
        in txs.items.sortedBy((a, b) => b.height.compareTo(a.height))) {
      final timestamp = trade.timestamp;
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

    runInAction(() {
      if (newHeight != MAXHEIGHT) height = newHeight;
    });
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

  void read(int height) async {
    final shieledNotes = await warp.listNotes(coin, id, height);
    items = shieledNotes.map((n) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(n.timestamp * 1000);
      return Note.from(height, n.idNote, n.height, timestamp, n.value / ZECUNIT,
          n.orchard, n.excluded, false);
    }).toList();
  }

  @action
  void clear() {
    items.clear();
  }

  void invert() async {
    await warp.reverseNoteExclusion(coin, id);
    runInAction(() {
      items = items.map((n) => n.invertExcluded).toList();
    });
  }

  void exclude(Note note) async {
    await warp.excludeNote(coin, note.id, note.excluded);
    runInAction(() {
      items = List.of(items);
    });
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

  void read(int height) async {
    final shieldedTxs = await warp.listTransactions(coin, id, height);
    runInAction(() {
      items = shieldedTxs.map((tx) {
        final timestamp =
            DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000);
        final fullTxId = Uint8List.fromList(tx.txid!);
        return Tx.from(
            height,
            tx.id,
            tx.height,
            timestamp,
            centerTrim(reversedHex(fullTxId)),
            fullTxId,
            tx.amount,
            tx.address,
            tx.contact,
            tx.memo ?? '');
      }).toList();
    });
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

  void read(int height) async {
    final ms = await warp.listMessages(coin, id);
    runInAction(() {
      items = ms.map((m) {
        final memo = m.memo ??
            UserMemoT(
              sender: '',
              recipient: '',
              subject: '',
              body: '',
            );
        return ZMessage(
            m.idMsg,
            m.idTx,
            m.incoming,
            memo.sender,
            memo.sender,
            memo.recipient!,
            m.contact ?? '',
            memo.subject!,
            memo.body!,
            DateTime.fromMillisecondsSinceEpoch(m.timestamp * 1000),
            m.height,
            m.read);
      }).toList();
    });
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
