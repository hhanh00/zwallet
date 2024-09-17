import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:YWallet/pages/settings.dart';
import 'package:YWallet/store.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';

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
  print('setup');
  warp.setup();
  final prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton(prefs);
  print('initializeReflectable');
  initializeReflectable();
  print('restoreSettings');
  await restoreSettings();
  print('initCoins');
  await initCoins();
  print('restoreWindow');
  await restoreWindow();
  print('initNotifications');
  initNotifications();
  final dbPath = await getDbPath();
  print("db path $dbPath");
  print('recoverDb');
  await recoverDb(dbPath);
  print('runApp');
  runApp(App());
}

Future<void> restoreSettings() async {
  final prefs = GetIt.I.get<SharedPreferences>();
  appSettings = AppSettingsExtension.load(prefs);
}

Future<void> recoverDb(String dbPath) async {
  final prefs = GetIt.I.get<SharedPreferences>();
  final backupPath = prefs.getString('backup');
  if (backupPath == null) return;
  print('Recovering $backupPath');
  final backupDir = Directory(backupPath);
  await prefs.remove('backup');
  for (var c in coins) {
    await c.delete();
  }
  final dbDir = await getDbPath();
  for (var file in await backupDir.list().whereType<File>().toList()) {
    await file.copy(dbDir);
  }
  await backupDir.delete();
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
