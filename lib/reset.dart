import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';
import 'package:share_plus/share_plus.dart';
import 'generated/l10n.dart';
import 'main.dart';

class ResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResetState();
}

class _ResetState extends State<ResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Emergency Menu')),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: _onReset,
                          child: Text("TRUNCATE DB (Keeps accounts)")),
                      ElevatedButton(
                          onPressed: _onBackup,
                          child: Text("BACKUP ALL ACCOUNTS")),
                      ElevatedButton(
                          onPressed: _onRestore,
                          child: Text("RESTORE ALL ACCOUNTS")),
                    ]))));
  }

  _onReset() async {
    final s = S.of(context);
    final confirmation = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
              title: Text(S.of(context).applicationReset),
              content: Text(S.of(context).confirmResetApp),
              actions: confirmButtons(context, () {
                Navigator.of(context).pop(true);
              }, okLabel: S.of(context).reset, cancelValue: false)),
        ) ??
        false;
    if (confirmation) {
      WarpApi.resetApp();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await showMessageBox(
          context, s.restart, s.pleaseQuitAndRestartTheAppNow, s.ok);
    }
  }

  _onBackup() {
    Navigator.of(context).pushNamed('/fullBackup');
  }

  _onRestore() {
    Navigator.of(context).pushNamed('/fullRestore');
  }
}

class FullBackupPage extends StatelessWidget {
  final String encKey;
  final TextEditingController controller;
  final String backup;

  FullBackupPage.init(String encKey)
      : this.encKey = encKey,
        this.controller = TextEditingController(text: encKey),
        this.backup = WarpApi.getFullBackup(encKey);

  FullBackupPage() : this.init(WarpApi.generateEncKey());

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.fullBackup)),
        body: Card(
            child: Column(children: [
          TextField(
            decoration: InputDecoration(labelText: s.backupEncryptionKey),
            controller: controller,
            readOnly: true,
          ),
          ElevatedButton.icon(
              onPressed: () => _onSave(context),
              icon: Icon(Icons.save),
              label: Text(s.saveBackup))
        ])));
  }

  _onSave(BuildContext context) async {
    Directory tempDir = await getTemporaryDirectory();
    String filename = "${tempDir.path}/$APP_NAME.bak";
    final file = File(filename);
    await file.writeAsString(backup);
    Share.shareFiles([filename], subject: S.of(context).encryptedBackup(APP_NAME));
  }
}

class FullRestorePage extends StatefulWidget {
  @override
  State<FullRestorePage> createState() => _FullRestoreState();
}

class _FullRestoreState extends State<FullRestorePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.fullRestore)),
        body: Card(child: Column(children: [
          TextField(
            decoration: InputDecoration(labelText: s.backupEncryptionKey),
            controller: controller,
          ),
          ElevatedButton.icon(
              onPressed: _onLoad,
              icon: Icon(Icons.open_in_new),
              label: Text(s.loadBackup))
        ])));
  }

  _onLoad() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final filename = result.files.single.path!;
      final file = File(filename);
      final backup = await file.readAsString();
      final key = controller.text;
      final res = WarpApi.restoreFullBackup(key, backup);

      if (res.isNotEmpty) {
        final snackBar = SnackBar(content: Text(res));
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
      else {
        await accounts.refresh();
        syncStatus.setAccountRestored(true);
        Navigator.of(context).pop();
      }
    }
  }
}
