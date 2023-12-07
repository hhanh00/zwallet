import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:mobx/mobx.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'appsettings.dart';
import 'pages/utils.dart';
import 'accounts.dart';
import 'coin/coins.dart';
import 'generated/intl/messages.dart';
import 'router.dart';

part 'store2.g.dart';

var appStore = AppStore();

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
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
      latestHeight = await WarpApi.getLatestHeight(aa.coin);
      connected = true;
    } on String catch (e) {
      logger.d(e);
      connected = false;
    }
    syncedHeight = WarpApi.getDbHeight(aa.coin).height;
  }

  @action
  Future<void> sync(bool rescan, {bool auto = false}) async {
    final context = rootNavigatorKey.currentContext!;
    final s = S.of(context);
    if (paused) return;
    if (syncing) return;
    await update();
    final lh = latestHeight;
    if (lh == null) return;
    // don't auto sync more than 1 month of data
    if (!rescan && auto && lh - syncedHeight > 30*24*60*4/5) {
      paused = true;
      return;
    }
    if (isSynced) return;
    try {
      syncing = true;
      isRescan = rescan;
      _updateSyncedHeight();
      startSyncedHeight = syncedHeight;
      if (Platform.isAndroid) {
        await FlutterForegroundTask.startService(
          notificationTitle: s.synchronizationInProgress,
          notificationText: '',
        );
      }
      eta.begin(latestHeight!);
      eta.checkpoint(syncedHeight, DateTime.now());

      // This may take a long time
      await WarpApi.warpSync2(
          aa.coin,
          !appSettings.nogetTx,
          appSettings.anchorOffset,
          coinSettings.spamFilter ? 50 : 1000000,
          syncProgressPort2.sendPort.nativePort);

      aa.update(latestHeight);
      contacts.fetchContacts();
      marketPrice.update();
    } on String catch (e) {
      showSnackBar(e);
    } finally {
      syncing = false;
      eta.end();
      if (Platform.isAndroid) await FlutterForegroundTask.stopService();
    }
  }

  @action
  Future<void> rescan(int height) async {
    WarpApi.rescanFrom(height);
    _updateSyncedHeight();
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
    eta.checkpoint(syncedHeight, DateTime.now());
  }

  void _updateSyncedHeight() {
    final h = WarpApi.getDbHeight(aa.coin);
    syncedHeight = h.height;
    timestamp = (h.timestamp != 0) ?
      DateTime.fromMillisecondsSinceEpoch(h.timestamp * 1000) : null;
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
    if (start == null)
      start = current;
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
    final percent =
        total > 0 ? 100 * (ch - sh) ~/ total : 0;
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
