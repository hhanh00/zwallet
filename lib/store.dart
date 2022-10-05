import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'coin/coins.dart';
import 'package:warp_api/warp_api.dart';
import 'package:warp_api/types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'coin/coin.dart';
import 'generated/l10n.dart';
import 'main.dart';

part 'store.g.dart';

enum ViewStyle {
  Auto, Table, List
}

class LWDServer = _LWDServer with _$LWDServer;

abstract class _LWDServer with Store {
  final int coin;
  final CoinBase coinDef;
  late String choice;
  late String customUrl;
  @observable
  String current = "";

  _LWDServer(this.coin, this.coinDef) {
    choice = "auto";
    customUrl = coinDef.lwd.first.url;
  }

  Future<String?> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final ticker = coinDef.ticker;
    final _choice = prefs.getString('$ticker.lwd_choice');
    final _customUrl = prefs.getString('$ticker.lwd_custom');
    if (_choice != null && _customUrl != null) {
      choice = _choice;
      customUrl = _customUrl;
    }
    else {
      await savePrefs(choice, customUrl);
    }
    return getLWDUrl();
  }

  Future<void> savePrefs(String _choice, String _customUrl) async {
    choice = _choice;
    customUrl = _customUrl;
    final ticker = coinDef.ticker;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('$ticker.lwd_choice', _choice);
    prefs.setString('$ticker.lwd_custom', _customUrl);
  }

  @action
  String? getLWDUrl() {
    String? url;
    if (choice == "auto") {
      var servers = coinDef.lwd.map((s) => s.url).toList();
      servers.add(customUrl);
      try {
        url = WarpApi.getBestServer(servers);
      }
      catch (e) {
        print(e);
        return null;
      }
    }
    else if (choice == "custom")
      url = customUrl;
    else {
      final lwd = coinDef.lwd.firstWhere((lwd) => lwd.name == choice,
          orElse: () => coinDef.lwd.first);
      url = lwd.url;
    }
    current = url;
    return url;
  }
}

class CoinData = _CoinData with _$CoinData;

abstract class _CoinData with Store {
  final int coin;
  int active = 0;
  int syncedHeight = 0;
  final CoinBase def;
  @observable bool contactsSaved = true;

  _CoinData(this.coin, this.def);
}

class Settings = _Settings with _$Settings;

abstract class _Settings with Store {
  @observable
  bool simpleMode = true;

  List<LWDServer> servers = [LWDServer(0, zcash), LWDServer(1, ycash)];
  List<CoinData> coins = [CoinData(0, zcash), CoinData(1, ycash)];

  @observable
  String version = "1.0.0";

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
  bool includeReplyTo = false;

  @observable
  ViewStyle messageView = ViewStyle.Auto;

  @observable
  ViewStyle noteView = ViewStyle.Auto;

  @observable
  ViewStyle txView = ViewStyle.Auto;

  @observable
  bool protectSend = false;

  @observable
  bool protectOpen = false;

  @observable
  bool qrOffline = true;

  @observable
  int gapLimit = 10;

  @observable
  int primaryColorValue = 0;
  @observable
  int primaryVariantColorValue = 0;

  @observable
  int secondaryColorValue = 0;
  @observable
  int secondaryVariantColorValue = 0;

  @observable
  String? memoSignature;

  @observable
  bool flat = false;

  @observable
  bool antispam = false;

  @observable
  bool useGPU = false;

  bool instantSync = false;

  @observable
  int developerMode = 10;

  @action
  Future<bool> restore() async {
    final prefs = await SharedPreferences.getInstance();
    version = prefs.getString('version') ?? "1.0.0";
    simpleMode = prefs.getBool('simple_mode') ?? true;
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
    protectOpen = prefs.getBool('protect_open') ?? false;
    includeReplyTo = prefs.getBool('include_reply_to') ?? false;
    messageView = ViewStyle.values[(prefs.getInt('message_view') ?? 0)];
    noteView = ViewStyle.values[(prefs.getInt('note_view') ?? 0)];
    txView = ViewStyle.values[(prefs.getInt('tx_view') ?? 0)];
    gapLimit = prefs.getInt('gap_limit') ?? 10;
    qrOffline = prefs.getBool('qr_offline') ?? true;

    primaryColorValue = prefs.getInt('primary') ?? Colors.blue.value;
    primaryVariantColorValue =
        prefs.getInt('primary.variant') ?? Colors.blueAccent.value;
    secondaryColorValue = prefs.getInt('secondary') ?? Colors.green.value;
    secondaryVariantColorValue =
        prefs.getInt('secondary.variant') ?? Colors.greenAccent.value;

    memoSignature = prefs.getString('memo_signature');
    antispam = prefs.getBool('antispam') ?? true;
    useGPU = prefs.getBool('gpu') ?? false;
    WarpApi.useGPU(useGPU);

    final _developerMode = prefs.getBool('developer_mode') ?? false;
    developerMode = _developerMode ? 0 : 10;

    for (var s in servers) {
      await s.loadPrefs();
    }

    for (var c in coins) {
      final ticker = c.def.ticker;
      c.active = prefs.getInt("$ticker.active") ?? 0;
      c.contactsSaved = prefs.getBool("$ticker.contacts_saved") ?? true;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    prefs.setString('version', version);

    _updateThemeData();
    Future.microtask(_loadCurrencies); // lazily
    if (isMobile())
      accelerometerEvents.listen(_handleAccel);
    return true;
  }

  @action
  void _handleAccel(event) {
    final n = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    final inclination = acos(event.z / n) / pi * 180 * event.y.sign;
    final _flat = inclination < 20 ? true : inclination > 40 ? false : null;
    if (_flat != null && flat != _flat)
      flat = _flat;
  }

  @action
  Future<void> setVersion(String v) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('version', v);
    version = v;
  }

  @action
  Future<void> setMode(bool simple) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('simple_mode', simple);
    simpleMode = simple;
  }

  void updateLWD() async {
    for (var s in servers) {
      final url = await s.loadPrefs();
      if (url != null)
        WarpApi.updateLWD(s.coin, url);
    }
  }

  @action
  Future<void> setAnchorOffset(int offset) async {
    final prefs = await SharedPreferences.getInstance();
    anchorOffset = offset;
    prefs.setInt('anchor_offset', offset);
  }

  @action
  Future<void> setAntiSpam(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    antispam = v;
    prefs.setBool('antispam', antispam);
  }

  @action
  Future<void> setUseGPU(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    useGPU = v;
    prefs.setBool('gpu', useGPU);
    WarpApi.useGPU(useGPU);
  }

  @action
  Future<void> setGapLimit(int _gapLimit) async {
    final prefs = await SharedPreferences.getInstance();
    gapLimit = _gapLimit;
    prefs.setInt('gap_limit', gapLimit);
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
    if (theme == 'custom') {
      final colors = FlexSchemeColor(
          primary: Color(primaryColorValue),
          primaryVariant: Color(primaryVariantColorValue),
          secondary: Color(secondaryColorValue),
          secondaryVariant: Color(secondaryVariantColorValue));
      final scheme = FlexSchemeData(
          name: 'custom',
          description: 'Custom Theme',
          light: colors,
          dark: colors);
      switch (themeBrightness) {
        case 'light':
          themeData = FlexColorScheme.light(colors: scheme.light).toTheme;
          break;
        case 'dark':
          themeData = FlexColorScheme.dark(colors: scheme.dark).toTheme;
          break;
      }
    } else {
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
  }

  @action
  Future<void> updateCustomThemeColors(Color primary, Color primaryVariant,
      Color secondary, Color secondaryVariant) async {
    final prefs = await SharedPreferences.getInstance();
    primaryColorValue = primary.value;
    primaryVariantColorValue = primaryVariant.value;
    secondaryColorValue = secondary.value;
    secondaryVariantColorValue = secondaryVariant.value;

    prefs.setInt('primary', primaryColorValue);
    prefs.setInt('primary.variant', primaryVariantColorValue);
    prefs.setInt('secondary', secondaryColorValue);
    prefs.setInt('secondary.variant', secondaryVariantColorValue);

    _updateThemeData();
  }

  @action
  Future<void> setChartRange(String v) async {
    final prefs = await SharedPreferences.getInstance();
    chartRange = v;
    prefs.setString('chart_range', chartRange);
    active.fetchChartData();
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
    await priceStore.fetchCoinPrice(active.coin);
    await active.fetchChartData();
  }

  @action
  Future<void> _loadCurrencies() async {
    try {
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
    catch (_) {}
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

  @action
  Future<void> setProtectOpen(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    protectOpen = v;
    prefs.setBool('protect_open', protectOpen);
  }

  @action
  Future<void> setIncludeReplyTo(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    includeReplyTo = v;
    prefs.setBool('include_reply_to', includeReplyTo);
  }

  @action
  Future<void> setMessageView(ViewStyle v) async {
    final prefs = await SharedPreferences.getInstance();
    messageView = v;
    prefs.setInt('message_view', v.index);
  }

  @action
  Future<void> setNoteView(ViewStyle v) async {
    final prefs = await SharedPreferences.getInstance();
    noteView = v;
    prefs.setInt('note_view', v.index);
  }

  @action
  Future<void> setTxView(ViewStyle v) async {
    final prefs = await SharedPreferences.getInstance();
    txView = v;
    prefs.setInt('tx_view', v.index);
  }

  @action
  Future<void> setQrOffline(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('qr_offline', v);
    qrOffline = v;
  }

  @action
  Future<void> setMemoSignature(String v) async {
    final prefs = await SharedPreferences.getInstance();
    memoSignature = v;
    prefs.setString('memo_signature', v);
  }

  @action
  Future<void> tapDeveloperMode(BuildContext context) async {
    developerMode -= 1;
    if (developerMode > 5) return;
    if (developerMode > 0) {
      showSnackBar("You are ${developerMode} steps away from being a developer",
          autoClose: true, quick: true);
      return;
    }
    else if (developerMode == 0) {
      final authenticated = await authenticate(context, 'Developer Mode');
      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('developer_mode', true);
        showSnackBar("You are now a developer");
        return;
      }
    }
    developerMode += 1;
  }

  @action
  Future<void> resetDevMode() async {
    developerMode = 10;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('developer_mode', false);
  }

  bool get isDeveloper => developerMode == 0;
}

class PriceStore = _PriceStore with _$PriceStore;

abstract class _PriceStore with Store {
  @observable
  double coinPrice = 0.0;

  int? lastChartUpdateTime;

  @action
  Future<void> fetchCoinPrice(int coin) async {
    final c = settings.coins[coin].def;
    final base = "api.coingecko.com";
    final uri = Uri.https(base, '/api/v3/simple/price',
        {'ids': c.currency, 'vs_currencies': settings.currency});
    try {
      final rep = await http.get(uri);
      if (rep.statusCode == 200) {
        final json = convert.jsonDecode(rep.body) as Map<String, dynamic>;
        final p = json[c.currency][settings.currency.toLowerCase()];
        coinPrice = (p is double) ? p : (p as int).toDouble();
      } else
        coinPrice = 0.0;
    }
    catch (_) {}
  }

  Future<void> updateChart() async {
    try {
      final _lastChartUpdateTime = lastChartUpdateTime;
      final now = DateTime
          .now()
          .millisecondsSinceEpoch ~/ 1000;
      if (_lastChartUpdateTime == null || now > _lastChartUpdateTime + 5 * 60) {
        await fetchCoinPrice(active.coin);
        await WarpApi.syncHistoricalPrices(settings.currency);
        await active.fetchChartData();
        lastChartUpdateTime = _lastChartUpdateTime;
      }
    }
    on String {}
  }
}

class SyncStatus = _SyncStatus with _$SyncStatus;

abstract class _SyncStatus with Store {
  @observable
  int? startSyncedHeight = null;

  @observable
  bool isRescan = false;

  @observable
  int? syncedHeight;

  @observable
  int latestHeight = 0;

  @observable
  DateTime? timestamp = null;

  bool accountRestored = false;

  @observable
  bool syncing = false;

  @observable
  bool paused = false;

  @observable
  int downloadedSize = 0;

  @observable
  int trialDecryptionCount = 0;

  bool isSynced() {
    final sh = syncedHeight;
    return sh != null && sh >= latestHeight;
  }

  int get confirmHeight {
    final ch = latestHeight - settings.anchorOffset;
    return max(ch, 0);
  }

  int? get progress {
    final _startHeight = startSyncedHeight;
    final _syncedHeight = syncedHeight;
    if (_startHeight != null && _syncedHeight != null) {
      final total = latestHeight - _startHeight;
      final percent = total > 0
          ? 100 * (_syncedHeight - _startHeight) ~/ total
          : 0;
      return percent;
    }
    return null;
  }

  @action
  setSyncHeight(int? height, DateTime? _timestamp) {
    if (height == null || syncedHeight != height)
      syncedHeight = height;
    timestamp = _timestamp;
  }

  @action
  void reset() {
    isRescan = false;
    syncedHeight = null;
    syncing = false;
    paused = false;
  }

  @action
  void markAsSynced(int coin) {
    WarpApi.skipToLastHeight(coin);
  }

  Future<BlockInfo?> getDbSyncedHeight() async {
    final db = active.coinDef.db;
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

  @action
  Future<bool> update() async {
    final server = WarpApi.getLWD(active.coin);
    if (server.isEmpty) {
      final server = settings.servers[active.coin].getLWDUrl();
      if (server != null && server.isNotEmpty)
        WarpApi.updateLWD(active.coin, server);
    }
    try {
      latestHeight = await WarpApi.getLatestHeight();
    }
    on String {}
    final _syncedInfo = await getDbSyncedHeight();
    // if syncedHeight = 0, we just started sync therefore don't set it back to null
    if (syncedHeight != 0 && _syncedInfo != null) setSyncHeight(_syncedInfo.height, _syncedInfo.timestamp);
    return latestHeight > 0 && syncedHeight == latestHeight;
  }

  @action
  Future<void> sync(bool _isRescan) async {
    if (paused) return;
    if (syncing) return;
    await syncStatus.update();
    if (syncedHeight == null) return;
    try {
      syncing = true;
      startSyncedHeight = syncedHeight!;
      isRescan = _isRescan;
      final currentSyncedHeight = syncedHeight;
      if (!isSynced()) {
        await FlutterForegroundTask.startService(
          notificationTitle: S.current.synchronizationInProgress,
          notificationText: '',
        );
        final params = SyncParams(
            active.coin, settings.getTx, settings.anchorOffset,
            settings.antispam ? 50 : 1000000,
            syncPort.sendPort);
        final res = await compute(WarpApi.warpSync, params);
        if (res == 0) {
          if (currentSyncedHeight != syncedHeight) {
            await active.update();
            await priceStore.updateChart();
            await contacts.fetchContacts();
          }
        }
        else if (res == 1) {
          await reorg();
        }
      }
    }
    on String catch (e) {
      showSnackBar(e);
      paused = true;
    }
    finally {
      syncing = false;
      eta.reset();
      await FlutterForegroundTask.stopService();
    }
  }

  @action
  Future<void> reorg() async {
    final _syncedHeight = await getDbSyncedHeight();
    if (_syncedHeight != null) {
      final rewindHeight = max(_syncedHeight.height - settings.anchorOffset, 0);
      final height = WarpApi.rewindTo(rewindHeight);
      showSnackBar(S.current.blockReorgDetectedRewind(height));
      syncStatus.reset();
      await syncStatus.update();
    }
  }

  @action
  Future<void> rescan(int height) async {
    if (syncing) return;
    eta.reset();
    showSnackBar(S.current.rescanRequested(height));
    syncedHeight = height;
    timestamp = null;
    WarpApi.rescanFrom(height);
    await sync(true);
  }

  @action
  void setAccountRestored(bool v) {
    accountRestored = v;
  }

  @action
  void setSyncedToLatestHeight() {
    setSyncHeight(latestHeight, null);
    WarpApi.skipToLastHeight(0xFF);
  }

  @action
  void setPause(bool v) {
    paused = v;
  }

  @action
  void setProgress(Progress progress) {
    trialDecryptionCount = progress.trial_decryptions;
    syncedHeight = progress.height;
    downloadedSize = progress.downloaded;
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
    final eta = (syncStatus.latestHeight - c.height) / speed;
    if (eta <= 0) return defaultMsg;
    final duration =
        Duration(milliseconds: eta.floor()).toString().split('.')[0];
    return "ETA: $duration";
  }
}

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {
  @observable
  ObservableList<Contact> contacts = ObservableList<Contact>.of([]);

  @action
  Future<void> fetchContacts() async {
    final db = active.coinDef.db;
    List<Map> res = await db.rawQuery(
        "SELECT id, name, address FROM contacts WHERE address <> '' ORDER BY name");
    contacts.clear();
    for (var c in res) {
      final contact = Contact(c['id'], c['name'], c['address']);
      contacts.add(contact);
    }
  }

  @action
  Future<void> add(Contact c) async {
    WarpApi.storeContact(c.id, c.name, c.address, true);
    markContactsSaved(active.coin, false);
    await fetchContacts();
  }

  @action
  Future<void> remove(Contact c) async {
    contacts.removeWhere((contact) => contact.id == c.id);
    WarpApi.storeContact(c.id, c.name, "", true);
    markContactsSaved(active.coin, false);
    await fetchContacts();
  }

  markContactsSaved(int coin, bool v) {
    settings.coins[coin].contactsSaved = v;
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final c = settings.coins[coin].def;
      prefs.setBool("${c.ticker}.contacts_saved", v);
    });
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
  DateTime timestamp;
  double value;
  bool excluded;
  bool spent;

  Note(this.id, this.height, this.timestamp, this.value, this.excluded,
      this.spent);

  Note get invertExcluded =>
      Note(id, height, timestamp, value, !excluded, spent);
}

class Tx extends HasHeight {
  int id;
  int height;
  DateTime timestamp;
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
  final int type;
  final String name;
  final String? seed;
  final int index;
  final String? sk;
  final String ivk;
  final ShareInfo? share;

  Backup(this.type, this.name, this.seed, this.index, this.sk, this.ivk, this.share);

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
  String field;

  SortOrder order;

  SortConfig(this.field, this.order);

  SortConfig sortOn(String field) {
    final order = field != this.field ? SortOrder.Ascending : nextSortOrder(this.order);
    return SortConfig(field, order);
  }

  String getIndicator(String field) {
    if (this.field != field) return '';
    if (order == SortOrder.Ascending) return ' \u2191';
    if (order == SortOrder.Descending) return ' \u2193';
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
  final bool isMulti;
  final Contact? contact;
  final String? address;
  final String? subject;
  final String? uri;
  final List<Recipient> recipients;

  SendPageArgs({this.isMulti = false, this.contact, this.address, this.subject, this.uri, this.recipients = const[]});
}

class ShareInfo {
  final int index;
  final int threshold;
  final int participants;
  final String value;

  ShareInfo(this.index, this.threshold, this.participants, this.value);
}

class TxSummary {
  final String address;
  final int amount;
  final String txJson;

  TxSummary(this.address, this.amount, this.txJson);
}

class BlockInfo {
  final int height;
  final DateTime timestamp;
  BlockInfo(this.height, this.timestamp);
}