import 'dart:io';

import 'package:YWallet/src/rust/api/simple.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as p;

import '../utils.dart';

part 'vote_data.g.dart';

var electionStore = ElectionInfo();

class ElectionInfo = _ElectionInfo with _$ElectionInfo;

abstract class _ElectionInfo with Store {
  @observable String? filepath;
  @observable Election? election;
  @observable bool downloaded = false;
  @observable List<String> files = [];
  String votePath = "";

  Future<void> init() async {
    final dirPath = await getDataPath();
    votePath = "$dirPath/votes";
  }

  @action
  void reloadFileList() {
    final dir = Directory(votePath);
    final files2 = <String>[];
    if (!dir.existsSync()) dir.createSync();
    for (var entry in dir.listSync()) {
      final name = p.basename(entry.path);
      files2.add(name);
    }
    files = files2;
  }
}
