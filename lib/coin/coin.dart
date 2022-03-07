import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
    db = await openDatabase(path);
  }
}
