import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';

import '../main.dart';

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
  late String dbDir;
  late String dbFullPath;
  late Database db;
  List<LWInstance> get lwd;
  bool get supportsUA;
  bool get supportsMultisig;
  List<double> get weights;

  void init(String dbDirPath) {
    dbDir = dbDirPath;
    dbFullPath = _getFullPath(dbDir);
  }

  Future<void> open() async {
    // schema handled in backend
    db = await openDatabase(dbFullPath/*, onCreate: createSchema, version: 1*/);
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
      print("copied to ${dbFullPath}");
      await delete();
      await src.copy(dbFullPath);
      await src.delete();
    }
  }

  Future<void> export(String dbPath) async {
    final path = _getFullPath(dbPath);
    WarpApi.disableWAL(path);
    db = await openDatabase(path);
    await db.close();
    await exportFile(path, dbName);
  }

  Future<void> delete() async {
    try {
      await File(p.join(dbDir, dbName)).delete();
      await File(p.join(dbDir, "${dbName}-shm")).delete();
      await File(p.join(dbDir, "${dbName}-wal")).delete();
    }
    catch (e) {} // ignore failure
  }

  String _getFullPath(String dbPath) {
    final path = p.join(dbPath, dbName);
    return path;
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

