import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:YWallet/accounts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_protocol/url_protocol.dart';
import 'package:warp_api/warp_api.dart';

import '../appsettings.dart';
import '../coin/coin.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../init.dart';
import '../main.dart';
import '../settings.pb.dart';
import '../store.dart';
import '../store2.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  final progressKey = GlobalKey<_LoadProgressState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future(() async {
        final prefs = await SharedPreferences.getInstance();
        final dbPath = await getDbPath();
        print("db path $dbPath");
        await _recoverDb(prefs, dbPath);
        await _decryptDb();
        await _restoreSettings(prefs);
        // await _setupMempool();
        await _registerURLHandler();
        await _registerQuickActions();
        _initWallets();
        await syncStatus2.update();
        await _restoreActive();
        initSyncListener();
        _initForegroundTask();
        GoRouter.of(context).go('/account');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadProgress(key: progressKey);
  }

  Future<void> _recoverDb(SharedPreferences prefs, String dbPath) async {
    final backupPath = prefs.getString('backup');
    if (backupPath == null) return;
    await prefs.remove('backup');
    for (var c in coins) {
      await c.delete();
    }
    final dbDir = await getDbPath();
    WarpApi.unzipBackup(backupPath, dbDir);
    _setProgress(0.05, "Database recovered");
  }

  _decryptDb() {
    final c = coins.first;
    if (isMobile()) return; // db encryption is only for desktop
    if (!File(c.dbFullPath).existsSync()) return; // fresh install
    if (WarpApi.decryptDb(c.dbFullPath, '')) return; // not encrypted
    GoRouter.of(context).push('/decrypt_db');
  }

  Future<void> _restoreSettings(SharedPreferences prefs) async {
    appSettings = AppSettingsExtension.load(prefs);
    _setProgress(0.1, "Settings loaded");
  }

  Future<void> _setupMempool() async {
    WarpApi.mempoolRun(unconfirmedBalancePort.sendPort.nativePort);
    _setProgress(0.2, 'Mempool initialized');
  }

  Future<void> _registerURLHandler() async {
    _setProgress(0.3, 'Register Payment URI handlers');
    await registerURLHandler(this.context);

    if (Platform.isWindows) {
      for (var c in coins) {
        registerProtocolHandler(c.currency, arguments: ['%s']);
      }
    }
  }

  Future<void> _registerQuickActions() async {
    _setProgress(0.4, 'Register App Launcher actions');
    if (!isMobile()) return;
    final quickActions = QuickActions();
    quickActions.initialize((type) {
      handleQuickAction(this.context, type);
    });
    Future.microtask(() {
      final s = S.of(this.context);
      List<ShortcutItem> shortcuts = [];
      for (var c in settings.coins) {
        final coin = c.coin;
        final ticker = c.def.ticker;
        shortcuts.add(ShortcutItem(
            type: '$coin.receive',
            localizedTitle: s.receive(ticker),
            icon: 'receive'));
        shortcuts.add(ShortcutItem(
            type: '$coin.send',
            localizedTitle: s.sendCointicker(ticker),
            icon: 'send'));
      }
      quickActions.setShortcutItems(shortcuts);
    });
  }

  void _initWallets() {
    for (var c in coins) {
      final coin = c.coin;
      _setProgress(0.5 + 0.1 * coin, 'Initializing ${c.ticker}');
      WarpApi.setDbPasswd(coin, appStore.dbPassword);
      WarpApi.initWallet(coin, c.dbFullPath);
      final p = WarpApi.getProperty(coin, 'settings');
      final settings = p.isNotEmpty ? CoinSettings.fromBuffer(base64Decode(p)) : CoinSettings();
      final url = _resolveURL(c, settings);
      WarpApi.updateLWD(coin, url);
      try {
        WarpApi.migrateData(c.coin);
      } catch (_) {} // do not fail on network exception
    }
  }

  String _resolveURL(CoinBase c, CoinSettings settings) {
    if (settings.lwd.index >= 0 && settings.lwd.index < c.lwd.length)
      return c.lwd[settings.lwd.index].url;
    else if (settings.lwd.index == -1) {
      var servers = c.lwd.map((c) => c.url).toList();
      servers.add(settings.lwd.customURL);
      try {
        return WarpApi.getBestServer(servers);
      } catch (e) {
        return c.lwd.first.url;
      }
    }
    else {
      return settings.lwd.customURL;
    }
  }

  Future<void> _restoreActive() async {
    _setProgress(0.8, 'Load Active Account');
    final prefs = await SharedPreferences.getInstance();
    final a = ActiveAccount2.fromPrefs(prefs);
    a?.let((a) {
      setActiveAccount(a.coin, a.id);
      print('_restoreActive $coinSettings');
      aa.update(syncStatus2.latestHeight);
    });
  }

  _initForegroundTask() {
    if (Platform.isAndroid)
      initForegroundTask();
    _setProgress(0.9, 'Initialize Foreground Service');
  }

  void _setProgress(double progress, String message) {
    print("$progress $message");
    progressKey.currentState!.setValue(progress, message);
  }
}

class LoadProgress extends StatefulWidget {
  LoadProgress({Key? key}) : super(key: key);

  @override
  State<LoadProgress> createState() => _LoadProgressState();
}

class _LoadProgressState extends State<LoadProgress> {
  var _value = 0.0;
  String _message = "";

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final s = S.of(context);
    final textTheme = t.textTheme;
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 240,
                width: 200,
                child: Column(children: [
                  Image.asset('assets/icon.png', height: 64),
                  Padding(padding: EdgeInsets.all(16)),
                  Text(s.loading, style: textTheme.headlineMedium),
                  Padding(padding: EdgeInsets.all(16)),
                  LinearProgressIndicator(value: _value),
                  Padding(padding: EdgeInsets.all(8)),
                  Text(_message, style: textTheme.labelMedium),
                ]))));
  }

  void setValue(double v, String message) {
    setState(() {
      _value = v;
      _message = message;
    });
  }
}

