import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'appsettings.dart';
import 'pages/utils.dart';
import 'accounts.dart';
import 'coin/coins.dart';
import 'generated/intl/messages.dart';

part 'store2.g.dart';
part 'store2.freezed.dart';

var appStore = AppStore();

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  bool initialized = false;
  String dbPassword = '';

  @observable
  bool flat = false;
}

final syncProgressPort2 = ReceivePort();
final syncProgressStream = syncProgressPort2.asBroadcastStream();

void initSyncListener() {
  syncProgressStream.listen((e) {
    if (e is List<int>) {
      final progress = Progress(e);
      syncStatus2.setProgress(progress);
      final b = progress.balances?.unpack();
      if (b != null)
        aa.poolBalances = b;
      logger.d(progress.balances);
    }
  });
}

Timer? syncTimer;

Future<void> startAutoSync() async {
  if (syncTimer == null) {
    await syncStatus2.update();
    await syncStatus2.sync(false, auto: true);
    syncTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      syncStatus2.sync(false, auto: true);
      aa.updateDivisified();
    });
  }
}

var syncStatus2 = SyncStatus2();

class SyncStatus2 = _SyncStatus2 with _$SyncStatus2;

abstract class _SyncStatus2 with Store {
  int startSyncedHeight = 0;
  bool isRescan = false;
  ETA eta = ETA();

  @observable
  bool connected = true;

  @observable
  int syncedHeight = 0;

  @observable
  int? latestHeight;

  @observable
  DateTime? timestamp;

  @observable
  bool syncing = false;

  @observable
  bool paused = false;

  @observable
  int downloadedSize = 0;

  @observable
  int trialDecryptionCount = 0;

  @computed
  int get changed {
    connected;
    syncedHeight;
    latestHeight;
    syncing;
    paused;
    return DateTime.now().microsecondsSinceEpoch;
  }

  bool get isSynced {
    final sh = syncedHeight;
    final lh = latestHeight;
    return lh != null && sh >= lh;
  }

  int? get confirmHeight {
    final lh = latestHeight;
    if (lh == null) return null;
    final ch = lh - appSettings.anchorOffset;
    return max(ch, 0);
  }

  @action
  void reset() {
    isRescan = false;
    syncedHeight = WarpApi.getDbHeight(aa.coin).height;
    syncing = false;
    paused = false;
  }

  @action
  Future<void> update() async {
    try {
      final lh = latestHeight;
      latestHeight = await WarpApi.getLatestHeight(aa.coin);
      if (lh == null && latestHeight != null)
        aa.update(latestHeight);
      connected = true;
    } on String catch (e) {
      logger.d(e);
      connected = false;
    }
    syncedHeight = WarpApi.getDbHeight(aa.coin).height;
  }

  @action
  Future<void> sync(bool rescan, {bool auto = false}) async {
    logger.d('R/A/P/S $rescan $auto $paused $syncing');
    if (paused) return;
    if (syncing) return;
    try {
      await update();
      final lh = latestHeight;
      if (lh == null) return;
      // don't auto sync more than 1 month of data
      if (!rescan && auto && lh - syncedHeight > 30 * 24 * 60 * 4 / 5) {
        paused = true;
        return;
      }
      if (isSynced) return;
      syncing = true;
      isRescan = rescan;
      _updateSyncedHeight();
      startSyncedHeight = syncedHeight;
      eta.begin(latestHeight!);
      eta.checkpoint(syncedHeight, DateTime.now());

      final preBalance = AccountBalanceSnapshot(
          coin: aa.coin, id: aa.id, balance: aa.poolBalances.total);
      // This may take a long time
      await WarpApi.warpSync(
          aa.coin,
          aa.id,
          !appSettings.nogetTx,
          appSettings.anchorOffset,
          coinSettings.spamFilter ? 50 : 1000000,
          syncProgressPort2.sendPort.nativePort);

      aa.update(latestHeight);
      contacts.fetchContacts();
      marketPrice.update();
      final postBalance = AccountBalanceSnapshot(
          coin: aa.coin, id: aa.id, balance: aa.poolBalances.total);
      if (preBalance.sameAccount(postBalance) &&
          preBalance.balance != postBalance.balance) {
        final s = GetIt.I.get<S>();
        final ticker = coins[aa.coin].ticker;
        if (preBalance.balance < postBalance.balance) {
          final amount =
              amountToString2(postBalance.balance - preBalance.balance);
          showLocalNotification(
            id: latestHeight!,
            title: s.incomingFunds,
            body: s.received(amount, ticker),
          );
        } else {
          final amount =
              amountToString2(preBalance.balance - postBalance.balance);
          showLocalNotification(
            id: latestHeight!,
            title: s.paymentMade,
            body: s.spent(amount, ticker),
          );
        }
      }
    } on String catch (e) {
      logger.d(e);
      showSnackBar(e);
    } finally {
      syncing = false;
      eta.end();
    }
  }

  @action
  Future<void> rescan(int height) async {
    WarpApi.rescanFrom(aa.coin, height);
    _updateSyncedHeight();
    paused = false;
    await sync(true);
  }

  @action
  void setPause(bool v) {
    paused = v;
  }

  @action
  void setProgress(Progress progress) {
    trialDecryptionCount = progress.trialDecryptions;
    syncedHeight = progress.height;
    downloadedSize = progress.downloaded;
    if (progress.timestamp > 0)
      timestamp = DateTime.fromMillisecondsSinceEpoch(progress.timestamp * 1000);
    eta.checkpoint(syncedHeight, DateTime.now());
  }

  void _updateSyncedHeight() {
    final h = WarpApi.getDbHeight(aa.coin);
    syncedHeight = h.height;
    timestamp = (h.timestamp != 0)
        ? DateTime.fromMillisecondsSinceEpoch(h.timestamp * 1000)
        : null;
  }
}

class ETA {
  int endHeight = 0;
  ETACheckpoint? start;
  ETACheckpoint? prev;
  ETACheckpoint? current;

  void begin(int height) {
    end();
    endHeight = height;
  }

  void end() {
    start = null;
    prev = null;
    current = null;
  }

  void checkpoint(int height, DateTime timestamp) {
    prev = current;
    current = ETACheckpoint(height, timestamp);
    if (start == null) start = current;
  }

  @computed
  int? get remaining {
    return current?.let((c) => endHeight - c.height);
  }

  @computed
  String get timeRemaining {
    final defaultMsg = "Calculating ETA";
    final p = prev;
    final c = current;
    if (p == null || c == null) return defaultMsg;
    if (c.timestamp.millisecondsSinceEpoch ==
        p.timestamp.millisecondsSinceEpoch) return defaultMsg;
    final speed = (c.height - p.height) /
        (c.timestamp.millisecondsSinceEpoch -
            p.timestamp.millisecondsSinceEpoch);
    if (speed == 0) return defaultMsg;
    final eta = (endHeight - c.height) / speed;
    if (eta <= 0) return defaultMsg;
    final duration =
        Duration(milliseconds: eta.floor()).toString().split('.')[0];
    return "ETA: $duration";
  }

  @computed
  bool get running => start != null;

  @computed
  int? get progress {
    if (!running) return null;
    final sh = start!.height;
    final ch = current!.height;
    final total = endHeight - sh;
    final percent = total > 0 ? 100 * (ch - sh) ~/ total : 0;
    return percent;
  }
}

class ETACheckpoint {
  int height;
  DateTime timestamp;

  ETACheckpoint(this.height, this.timestamp);
}

var marketPrice = MarketPrice();

class MarketPrice = _MarketPrice with _$MarketPrice;

abstract class _MarketPrice with Store {
  @observable
  double? price;

  @action
  Future<void> update() async {
    final c = coins[aa.coin];
    price = await getFxRate(c.currency, appSettings.currency);
  }

  int? lastChartUpdateTime;
}

var contacts = ContactStore();

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {
  @observable
  ObservableList<Contact> contacts = ObservableList<Contact>.of([]);

  @action
  void fetchContacts() {
    contacts.clear();
    contacts.addAll(WarpApi.getContacts(aa.coin));
  }

  @action
  void add(Contact c) {
    WarpApi.storeContact(c.id, c.name!, c.address!, true);
    markContactsSaved(aa.coin, false);
    fetchContacts();
  }

  @action
  void remove(Contact c) {
    contacts.removeWhere((contact) => contact.id == c.id);
    WarpApi.storeContact(c.id, c.name!, "", true);
    markContactsSaved(aa.coin, false);
    fetchContacts();
  }

  @action
  markContactsSaved(int coin, bool v) {
    coinSettings.contactsSaved = true;
    coinSettings.save(coin);
  }
}

class AccountBalanceSnapshot {
  final int coin;
  final int id;
  final int balance;
  AccountBalanceSnapshot({
    required this.coin,
    required this.id,
    required this.balance,
  });

  bool sameAccount(AccountBalanceSnapshot other) =>
      coin == other.coin && id == other.id;

  @override
  String toString() => '($coin, $id, $balance)';
}

@freezed
class SeedInfo with _$SeedInfo {
  const factory SeedInfo({
    required String seed,
    required int index,
  }) = _SeedInfo;
}

@freezed
class TxMemo with _$TxMemo {
  const factory TxMemo({
    required String address,
    required String memo,
  }) = _TxMemo;
}

@freezed
class SwapAmount with _$SwapAmount {
  const factory SwapAmount({
    required String amount,
    required String currency,
  }) = _SwapAmount;
}

@freezed
class SwapQuote with _$SwapQuote {
  const factory SwapQuote({
    required String estimated_amount,
    required String rate_id,
    required String valid_until,
  }) = _SwapQuote;

  factory SwapQuote.fromJson(Map<String, dynamic> json) => _$SwapQuoteFromJson(json);
}

@freezed
class SwapRequest with _$SwapRequest {
  const factory SwapRequest({
    required bool fixed,
    required String rate_id,
    required String currency_from,
    required String currency_to,
    required double amount_from,
    required String address_to,
  }) = _SwapRequest;

  factory SwapRequest.fromJson(Map<String, dynamic> json) => _$SwapRequestFromJson(json);
}

@freezed
class SwapLeg with _$SwapLeg {
  const factory SwapLeg({
    required String symbol,
    required String name,
    required String image,
    required String validation_address,
    required String address_explorer,
    required String tx_explorer,
  }) = _SwapLeg;

  factory SwapLeg.fromJson(Map<String, dynamic> json) => _$SwapLegFromJson(json);
}

@freezed
class SwapResponse with _$SwapResponse {
  const factory SwapResponse({
    required String id,
    required String timestamp,
    required String currency_from,
    required String currency_to,
    required String amount_from,
    required String amount_to,
    required String address_from,
    required String address_to,
  }) = _SwapResponse;

  factory SwapResponse.fromJson(Map<String, dynamic> json) => _$SwapResponseFromJson(json);
}

@freezed
class Election with _$Election {
  const factory Election({
    required String name,
    required int start_height,
    required int end_height,
    required int close_height,
    required String submit_url,
    required String question,
    required List<String> candidates,
    required String status,
  }) = _Election;

  factory Election.fromJson(Map<String, dynamic> json) => _$ElectionFromJson(json);
}

@freezed
class Vote with _$Vote {
  const factory Vote({
    required Election election,
    required List<VoteNoteT> notes,
    int? candidate,
  }) = _Vote;
}
