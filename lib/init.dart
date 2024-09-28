import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:tuple/tuple.dart';

import 'accounts.dart';
import 'appsettings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:path/path.dart' as path;

import 'coin/coins.dart';
import 'generated/intl/messages.dart';
import 'main.dart';
import 'pages/utils.dart';
import 'router.dart';
import 'store.dart';

Future<void> initDbPath() async {
  final dbPath = await getDbPath();
  await Directory(dbPath).create(recursive: true);
  appStore.dbDir = dbPath;
}

Future<void> restoreWindow() async {
  if (isMobile()) return;
  await windowManager.ensureInitialized();

  final prefs = GetIt.I.get<SharedPreferences>();
  final width = prefs.getDouble('width');
  final height = prefs.getDouble('height');
  final size = width != null && height != null ? Size(width, height) : null;
  WindowOptions windowOptions = WindowOptions(
    center: true,
    size: size,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle:
        Platform.isMacOS ? TitleBarStyle.hidden : TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  windowManager.addListener(_OnWindow());
}

class _OnWindow extends WindowListener {
  @override
  void onWindowResized() async {
    final s = await windowManager.getSize();
    final prefs = GetIt.I.get<SharedPreferences>();
    prefs.setDouble('width', s.width);
    prefs.setDouble('height', s.height);
  }

  @override
  void onWindowClose() async {
    logger.d('Shutdown');
  }
}

void initNotifications() {
  AwesomeNotifications().initialize(
      'resource://drawable/res_notification',
      [
        NotificationChannel(
          channelKey: APP_NAME,
          channelName: APP_NAME,
          channelDescription: 'Notification channel for $APP_NAME',
          defaultColor: Color(0xFFB3F0FF),
          ledColor: Colors.white,
        )
      ],
      debug: false);
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      aaSequence.settingsSeqno;
      final scheme = FlexScheme.values.byName(appSettings.palette.name);
      final baseTheme = appSettings.palette.dark
          ? FlexThemeData.dark(scheme: scheme)
          : FlexThemeData.light(scheme: scheme);
      final theme = baseTheme.copyWith(
        useMaterial3: true,
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateColor.resolveWith(
            (_) => baseTheme.highlightColor,
          ),
        ),
      );
      return MaterialApp.router(
        locale: Locale(appSettings.language),
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: theme,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('es'),
          Locale('pt'),
          Locale('fr'),
        ],
        routerConfig: router,
      );
    });
  }
}

Future<String> upgradeDb(int coin, String password) async {
  final c = coins[coin];
  final dbRoot = c.dbRoot; // for ex, zec
  final dbDir = appStore.dbDir;

  // copy zec.db to zec01.db
  final src = File(path.join(dbDir, "$dbRoot.db"));
  if (src.existsSync())
    src.copySync(File(path.join(dbDir, "${dbRoot}01.db")).path);

  final version = appStore.dbVersion;
  final dbLatestVersionFile = dbFileByVersion(dbDir, dbRoot, version);
  if (!dbLatestVersionFile.existsSync()) {
    final latestDb = getDbFile(coin, dbDir, version);
    if (latestDb == null) {
      logger.d("No db file - create a new installation");
      await warp.createDb(coin, dbLatestVersionFile.path, password);
    } else {
      for (var nn = latestDb.item1; nn < version; nn++) {
        logger.d("Migrating from version $nn");
        await warp.migrateDb(coin, nn, dbFileByVersion(dbDir, dbRoot, nn).path,
            dbFileByVersion(dbDir, dbRoot, nn + 1).path, password);
      }
    }
  }
  return dbLatestVersionFile.path;
}

File dbFileByVersion(String dbDir, String dbRoot, int n) {
  final version = n.toString().padLeft(2, '0');
  return File(path.join(dbDir, "$dbRoot$version.db"));
}

Tuple2<int, String>? getDbFile(int coin, String dbDir, int start) {
  final dbRoot = coins[coin].dbRoot;
  // find the highest NN such as zecNN.db exists
  int i = start;
  while (i > 0) {
    final nextDb = dbFileByVersion(dbDir, dbRoot, i);
    if (!nextDb.existsSync()) {
      i -= 1;
      continue;
    }
    break;
  }
  if (i == 0) return null;
  final current = dbFileByVersion(dbDir, dbRoot, i);
  return Tuple2(i, current.path);
}
