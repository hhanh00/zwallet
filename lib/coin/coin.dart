import 'dart:io';

import 'package:ZYWallet/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class LWInstance {
  String name;
  String url;

  LWInstance(this.name, this.url);
}

abstract class CoinBase {
  String get app;
  String get symbol;
  String get currency;
  String get ticker;
  int get coinIndex;
  String get explorerUrl;
  AssetImage get image;
  String get dbName;
  late String dbPath;
  late Database db;
  List<LWInstance> get lwd;
  bool get supportsUA;
  bool get supportsMultisig;
  List<double> get weights;

  void init(String dbDirPath) {
    dbPath = getPath(dbDirPath);
  }

  Future<void> open() async {
    // schema handled in backend
    db = await openDatabase(dbPath/*, onCreate: createSchema, version: 1*/);
  }

  Future<void> delete(String dbPath) async {
    await File(p.join(dbPath, dbName)).delete();
    await File(p.join(dbPath, "${dbName}-shm")).delete();
    await File(p.join(dbPath, "${dbName}-wal")).delete();
  }

  Future<bool> tryImport(PlatformFile file) async {
    if (file.name == dbName) {
      Directory tempDir = await getTemporaryDirectory();
      final dest = p.join(tempDir.path, dbName);
      await File(file.path!).copy(dest); // save to temporary directory
      return true;
    }
    return false;
  }

  Future<void> importFromTemp() async {
    Directory tempDir = await getTemporaryDirectory();
    final src = File(p.join(tempDir.path, dbName));
    print("Import from ${src.path}");
    if (await src.exists()) {
      print("copied to ${dbPath}");
      await src.copy(dbPath);
      await src.delete();
    }
  }

  String getPath(String dbPath) {
    final path = p.join(dbPath, dbName);
    return path;
  }

  Future<void> export(String dbPath) async {
    if (isMobile()) {
      final path = getPath(dbPath);
      db = await openDatabase(path);
      await db.close();
      await Share.shareFiles([path], subject: dbName);
    }
  }
}

Future<void> createSchema(Database db, int version) async {
  final script = await rootBundle.loadString("assets/create_db.sql");
  final statements = script.split(";");
  for (var s in statements) {
    if (s.isNotEmpty) {
      final sql = s.trim();
      print(sql);
      db.execute(sql);
    }
  }
}

