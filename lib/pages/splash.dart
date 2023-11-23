import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import 'settings.dart';
import 'utils.dart';
import '../appsettings.dart';
import '../coin/coin.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../init.dart';
import '../settings.pb.dart';
import '../store2.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  late final s = S.of(context);
  final progressKey = GlobalKey<_LoadProgressState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future(() async {
        // await _setupMempool();
        await _registerURLHandler();
        await _registerQuickActions();
        _initWallets();
        await syncStatus2.update();
        await _restoreActive();
        initSyncListener();
        _initForegroundTask();
        _initAccel();
        final protectOpen = appSettings.protectOpen;
        if (protectOpen) {
          await authBarrier(context);
        }
        GoRouter.of(context).go('/account');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadProgress(key: progressKey);
  }

  Future<void> _registerURLHandler() async {
    _setProgress(0.3, 'Register Payment URI handlers');
    await registerURLHandler(this.context);

    // TODO
    // if (Platform.isWindows) {
    //   for (var c in coins) {
    //     registerProtocolHandler(c.currency, arguments: ['%s']);
    //   }
    // }
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
      for (var c in coins) {
        final ticker = c.ticker;
        shortcuts.add(ShortcutItem(
            type: '${c.coin}.receive',
            localizedTitle: s.receive(ticker),
            icon: 'receive'));
        shortcuts.add(ShortcutItem(
            type: '${c.coin}.send',
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
      final settings = p.isNotEmpty
          ? CoinSettings.fromBuffer(base64Decode(p))
          : CoinSettings();
      final url = resolveURL(c, settings);
      WarpApi.updateLWD(coin, url);
      try {
        WarpApi.migrateData(c.coin);
      } catch (_) {} // do not fail on network exception
    }
  }

  Future<void> _restoreActive() async {
    _setProgress(0.8, 'Load Active Account');
    final prefs = await SharedPreferences.getInstance();
    final a = ActiveAccount2.fromPrefs(prefs);
    a?.let((a) {
      setActiveAccount(a.coin, a.id);
      aa.update(syncStatus2.latestHeight);
    });
  }

  _initForegroundTask() {
    if (Platform.isAndroid) initForegroundTask();
    _setProgress(0.9, 'Initialize Foreground Service');
  }

  _initAccel() {
    if (isMobile()) accelerometerEvents.listen(handleAccel);
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

StreamSubscription? subUniLinks;

bool setActiveAccountOf(int coin) {
  final coinSettings = CoinSettingsExtension.load(coin);
  final id = coinSettings.account;
  if (id == 0) return false;
  setActiveAccount(coin, id);
  return true;
}

void handleUri(BuildContext context, Uri uri) {
  final scheme = uri.scheme;
  final coinDef = coins.firstWhere((c) => c.currency == scheme);
  final coin = coinDef.coin;
  if (setActiveAccountOf(coin))
    GoRouter.of(context).pushNamed('/send_to_pay_uri', extra: uri.toString());
}

Future<void> registerURLHandler(BuildContext context) async {
  if (Platform.isLinux) return;
  final _appLinks = AppLinks();

  final uri = await _appLinks.getInitialAppLink();
  if (uri != null) {
    handleUri(context, uri);
  }

  subUniLinks = _appLinks.uriLinkStream.listen((uri) {
    handleUri(context, uri);
  });
}

void handleQuickAction(BuildContext context, String type) {
  final t = type.split(".");
  final coin = int.parse(t[0]);
  final shortcut = t[1];
  setActiveAccountOf(coin);
  switch (shortcut) {
    case 'receive':
      Navigator.of(context).pushNamed('/receive');
      break;
    case 'send':
      Navigator.of(context).pushNamed('/send');
      break;
  }
}
