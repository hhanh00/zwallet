import 'dart:io';

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
  List<LWInstance> get lwd;
  String? warpUrl;
  int get warpHeight;
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
}
