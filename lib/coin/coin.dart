import 'dart:io';

import 'package:ZYWallet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
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
  late Database db;
  List<LWInstance> get lwd;
  bool get supportsUA;
  bool get supportsMultisig;
  List<double> get weights;

  Future<void> open(String dbPath) async {
    final path = join(dbPath, dbName);
    // schema handled in backend
    db = await openDatabase(path/*, onCreate: createSchema, version: 1*/);
  }

  Future<void> delete(String dbPath) async {
    final path = join(dbPath, dbName);
    await deleteDatabase(path);
  }

  Future<void> export(String dbPath) async {
    if (isMobile()) {
      final path = join(dbPath, dbName);
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

