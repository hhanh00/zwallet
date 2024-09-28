import 'dart:async';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';
import 'package:path/path.dart' as path;

import 'appsettings.dart';
import 'main.reflectable.dart';
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
  print('restoreWindow');
  await restoreWindow();
  print('initNotifications');
  initNotifications();
  await initDbPath();
  print('recoverDb');
  await recoverDb();
  print('runApp');
  runApp(App());
}

Future<void> restoreSettings() async {
  final prefs = GetIt.I.get<SharedPreferences>();
  appSettings = AppSettingsExtension.load(prefs);
}

Future<void> recoverDb() async {
  final prefs = GetIt.I.get<SharedPreferences>();
  final backupPath = prefs.getString('backup');
  if (backupPath == null) return;
  logger.i('Recovering $backupPath');
  final backupDir = Directory(backupPath);
  final dbDir = await getDbPath();
  for (var file in await backupDir.list().whereType<File>().toList()) {
    final name = path.relative(file.path, from: backupPath);
    await file.copySync(path.join(dbDir, name));
  }
  await prefs.remove('backup');
  await backupDir.delete(recursive: true);
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
