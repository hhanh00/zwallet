import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';
import 'package:workmanager/workmanager.dart';

import '../../accounts.dart';
import '../init.dart';
import 'settings.dart';
import 'utils.dart';
import '../appsettings.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../store.dart';

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
        GetIt.I.registerSingleton<S>(S.of(context));
        if (!appSettings.hasMemo()) appSettings.memo = s.sendFrom(APP_NAME);
        _initProver();
        // await _setupMempool();
        final applinkUri = await _registerURLHandler();
        final quickAction = await _registerQuickActions();
        await _initWallets();
        await _restoreActive();
        // _initForegroundTask();
        _initBackgroundSync();
        _initAccel();
        final protectOpen = appSettings.protectOpen;
        if (protectOpen) {
          await authBarrier(context);
        }
        appStore.initialized = true;
        if (applinkUri != null)
          handleUri(applinkUri);
        else if (quickAction != null)
          handleQuickAction(context, quickAction);
        else
          GoRouter.of(context).go('/account');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadProgress(key: progressKey);
  }

  Future<Uri?> _registerURLHandler() async {
    _setProgress(0.3, 'Register Payment URI handlers');
    return await registerURLHandler();

    // TODO
    // if (Platform.isWindows) {
    //   for (var c in coins) {
    //     registerProtocolHandler(c.currency, arguments: ['%s']);
    //   }
    // }
  }

  Future<String?> _registerQuickActions() async {
    _setProgress(0.4, 'Register App Launcher actions');
    String? launchPage;
    if (isMobile()) {
      final quickActions = QuickActions();
      await quickActions.initialize((quick_action) {
        launchPage = quick_action;
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
    return launchPage;
  }

  void _initProver() async {
    _setProgress(0.1, 'Initialize ZK Prover');
    final spend = await rootBundle.load('assets/sapling-spend.params');
    final output = await rootBundle.load('assets/sapling-output.params');
    warp.initProver(spend.buffer.asUint8List(), output.buffer.asUint8List());
  }

  Future<void> _initWallets() async {
    for (var c in coins) {
      final coin = c.coin;
      _setProgress(0.5 + 0.1 * coin, 'Initializing ${c.ticker}');
      final path = await upgradeDb(coin, appStore.dbPassword);
      logger.i("Db path: $path");
      warp.setDbPathPassword(coin, path, appStore.dbPassword);
      final cs = await CoinSettingsExtension.load(c.coin);
      final url = resolveURL(c, cs);
      warp.configure(coin,
          url: url, warp: c.warpUrl, warpEndHeight: c.warpHeight);
    }
  }

  Future<void> _restoreActive() async {
    _setProgress(0.8, 'Load Active Account');
    final prefs = GetIt.I.get<SharedPreferences>();
    final a = await ActiveAccount.fromPrefs(prefs);
    print('_restoreActive ${a?.id}');
    if (a != null) {
      await setActiveAccount(a.coin, a.id);
      await aa.update(MAXHEIGHT);
    }
  }

  _initAccel() {
    if (isMobile()) accelerometerEvents.listen(handleAccel);
  }

  void _setProgress(double progress, String message) {
    print("$progress $message");
    progressKey.currentState!.setValue(progress, message);
  }

  _initBackgroundSync() {
    if (!isMobile()) return;
    logger.d('${appSettings.backgroundSync}');

    Workmanager().initialize(
      backgroundSyncDispatcher,
    );
    if (appSettings.backgroundSync != 0)
      Workmanager().registerPeriodicTask(
        'sync',
        'background-sync',
        constraints: Constraints(
          networkType: appSettings.backgroundSync == 1
              ? NetworkType.unmetered
              : NetworkType.connected,
        ),
      );
    else
      Workmanager().cancelAll();
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

Future<bool> setActiveAccountOf(int coin) async {
  final coinSettings = await CoinSettingsExtension.load(coin);
  final id = coinSettings.account;
  if (id == 0) return false;
  await setActiveAccount(coin, id);
  return true;
}

Future<void> handleUri(Uri uri) async {
  final scheme = uri.scheme;
  final coinDef = coins.firstWhere((c) => c.currency == scheme);
  final coin = coinDef.coin;
  // TODO
  // if (await setActiveAccountOf(coin)) {
  //   SendContext? sc = SendContext.fromPaymentURI(uri.toString());
  //   final context = rootNavigatorKey.currentContext!;
  //   GoRouter.of(context).go('/account/quick_send', extra: sc);
  // }
}

Future<Uri?> registerURLHandler() async {
  if (Platform.isLinux) return null;
  final _appLinks = AppLinks();

  subUniLinks = _appLinks.uriLinkStream.listen((uri) {
    logger.d(uri);
    handleUri(uri);
  });

  final uri = await _appLinks.getInitialLink();
  return uri;
}

void handleQuickAction(BuildContext context, String quickAction) {
  final t = quickAction.split(".");
  final coin = int.parse(t[0]);
  final shortcut = t[1];
  setActiveAccountOf(coin);
  switch (shortcut) {
    case 'receive':
      GoRouter.of(context).go('/account/pay_uri');
    case 'send':
      GoRouter.of(context).go('/account/quick_send');
  }
}

@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  if (!appStore.initialized) return;
  Workmanager().executeTask((task, inputData) async {
    logger.i("Native called background task: $task");
    await syncStatus.sync(false, auto: true);
    return true;
  });
}
