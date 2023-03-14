import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../main.dart';

class LWInstance {
  String name;
  String url;

  LWInstance(this.name, this.url);
}

abstract class CoinBase {
  String get name;
  int get coin;
  String get app;
  String get symbol;
  String get currency;
  String get ticker;
  int get coinIndex;
  AssetImage get image;
  String get dbName;
  late String dbDir;
  late String dbFullPath;
  List<LWInstance> get lwd;
  bool get supportsUA;
  bool get supportsMultisig;
  List<double> get weights;
  List<String> get blockExplorers;

  void init(String dbDirPath) {
    dbDir = dbDirPath;
    dbFullPath = _getFullPath(dbDir);
  }

  Future<bool> tryImport(PlatformFile file) async {
    if (file.name == dbName) {
      final dest = p.join(settings.tempDir, dbName);
      await File(file.path!).copy(dest); // save to temporary directory
      return true;
    }
    return false;
  }

  Future<void> importFromTemp() async {
    final src = File(p.join(settings.tempDir, dbName));
    print("Import from ${src.path}");
    if (await src.exists()) {
      print("copied to $dbFullPath");
      await delete();
      await src.copy(dbFullPath);
      await src.delete();
    }
  }

  Future<void> export(BuildContext context, String dbPath) async {
    final path = _getFullPath(dbPath);
    // db = await openDatabase(path, onConfigure: (db) async {
    //   await db.rawQuery("PRAGMA journal_mode=off");
    // });
    // await db.close();
    await exportFile(context, path, dbName);
  }

  Future<void> delete() async {
    try {
      await File(p.join(dbDir, dbName)).delete();
      await File(p.join(dbDir, "$dbName-shm")).delete();
      await File(p.join(dbDir, "$dbName-wal")).delete();
    } catch (e) {} // ignore failure
  }

  String _getFullPath(String dbPath) {
    final path = p.join(dbPath, dbName);
    return path;
  }
}
