import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';

import 'appsettings.dart';
import 'main.reflectable.dart';
import 'coin/coins.dart';
import './pages/utils.dart';

import 'init.dart';

const ZECUNIT = 100000000.0;
// ignore: non_constant_identifier_names
var ZECUNIT_DECIMAL = Decimal.parse('100000000');
const mZECUNIT = 100000;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  await restoreSettings();
  await initCoins();
  await restoreWindow();
  initNotifications();
  final prefs = await SharedPreferences.getInstance();
  final dbPath = await getDbPath();
  print("db path $dbPath");
  await recoverDb(prefs, dbPath);
  runApp(App());
}

Future<void> restoreSettings() async {
  final prefs = await SharedPreferences.getInstance();
  appSettings = AppSettingsExtension.load(prefs);
}

Future<void> recoverDb(SharedPreferences prefs, String dbPath) async {
  final backupPath = prefs.getString('backup');
  if (backupPath == null) return;
  await prefs.remove('backup');
  for (var c in coins) {
    await c.delete();
  }
  final dbDir = await getDbPath();
  WarpApi.unzipBackup(backupPath, dbDir);
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
