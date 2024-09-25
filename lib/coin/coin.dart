import 'dart:io';

import 'package:warp/warp.dart';

import '../pages/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

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
  String? get marketTicker;
  AssetImage get image;
  String get dbRoot;
  late String dbDir;
  List<LWInstance> get lwd;
  String? warpUrl;
  int get defaultAddrMode;
  int get defaultUAType;
  bool get supportsUA;
  bool get supportsMultisig;
  bool get supportsLedger;
  List<double> get weights;
  List<String> get blockExplorers;

  Future<bool> tryImport(PlatformFile file) async {
    if (file.name == dbRoot) {
      final tempDir = await getTempPath();
      final dest = p.join(tempDir, dbRoot);
      await File(file.path!).copy(dest); // save to temporary directory
      return true;
    }
    return false;
  }

  // Future<void> importFromTemp() async {
  //   final tempDir = await getTempPath();
  //   final src = File(p.join(tempDir, dbRoot));
  //   print("Import from ${src.path}");
  //   if (await src.exists()) {
  //     print("copied to $dbFullPath");
  //     await delete();
  //     await src.copy(dbFullPath);
  //     await src.delete();
  //   }
  // }

  Future<void> delete() async {
    try {
      await File(p.join(dbDir, dbRoot)).delete();
      await File(p.join(dbDir, "$dbRoot-shm")).delete();
      await File(p.join(dbDir, "$dbRoot-wal")).delete();
    } catch (e) {} // ignore failure
  }

  String _getFullPath(String dbPath, int n) {
    final version = n.toString().padLeft(2, '0');
    final path = p.join(dbPath, "$dbRoot$version.db");
    return path;
  }
}
