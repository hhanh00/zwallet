import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:YWallet/router.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';
import 'package:workmanager/workmanager.dart';

import '../../accounts.dart';
import 'accounts/send.dart';
import 'settings.dart';
import 'utils.dart';
import '../appsettings.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
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
        GetIt.I.registerSingleton<S>(S.of(context));
        if (!appSettings.hasMemo()) appSettings.memo = s.sendFrom(APP_NAME);
        _initProver();
        // await _setupMempool();
        final applinkUri = await _registerURLHandler();
        final quickAction = await _registerQuickActions();
        _initWallets();
        await _restoreActive();
        initSyncListener();
        // _initForegroundTask();
        _initBackgroundSync();
        _initAccel();
        final protectOpen = appSettings.protectOpen;
        if (protectOpen) {
          await authBarrier(context);
        }
        appStore.initialized = true;
        await _showDeprecationNoticeIfNeeded();
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
    WarpApi.initProver(spend.buffer.asUint8List(), output.buffer.asUint8List());
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

  _initAccel() {
    if (isMobile()) accelerometerEvents.listen(handleAccel);
  }

  void _setProgress(double progress, String message) {
    print("$progress $message");
    progressKey.currentState!.setValue(progress, message);
  }

  Future<void> _showDeprecationNoticeIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAcknowledged = prefs.getInt('deprecation_last_acknowledged');
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneMonth = Duration(days: 30).inMilliseconds;

    if (lastAcknowledged != null && now - lastAcknowledged < oneMonth) {
      return;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline_rounded,
                size: 48,
                color: colorScheme.error,
              ),
            ),
            const Gap(24),
            Text(
              'Important Notice',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const Gap(16),
            Text(
              'YWallet is no longer actively developed',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const Gap(8),
                  Text(
                    'Your coins remain safe',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Text(
              'Security fixes and protocol updates will continue.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            Divider(color: colorScheme.outlineVariant),
            const Gap(16),
            Text(
              'Try the new Zcash wallet:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
            InkWell(
              onTap: () async {
                final url = Uri.parse('https://github.com/hhanh00/zkool2');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const Gap(8),
                    Text(
                      'Zkool Wallet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(8),
            Text(
              'The successor to YWallet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Got it'),
              ),
            ),
          ),
        ],
      ),
    );

    await prefs.setInt('deprecation_last_acknowledged', now);
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

bool setActiveAccountOf(int coin) {
  final coinSettings = CoinSettingsExtension.load(coin);
  final id = coinSettings.account;
  if (id == 0) return false;
  setActiveAccount(coin, id);
  return true;
}

void handleUri(Uri uri) {
  final scheme = uri.scheme;
  final coinDef = coins.firstWhere((c) => c.currency == scheme);
  final coin = coinDef.coin;
  if (setActiveAccountOf(coin)) {
    SendContext? sc = SendContext.fromPaymentURI(uri.toString());
    final context = rootNavigatorKey.currentContext!;
    GoRouter.of(context).go('/account/quick_send', extra: sc);
  }
}

Future<Uri?> registerURLHandler() async {
  if (Platform.isLinux) return null;
  final _appLinks = AppLinks();

  subUniLinks = _appLinks.uriLinkStream.listen((uri) {
    logger.d(uri);
    handleUri(uri);
  });

  final uri = await _appLinks.getInitialAppLink();
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
    await syncStatus2.sync(false, auto: true);
    return true;
  });
}
