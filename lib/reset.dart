import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';
import 'package:share_plus/share_plus.dart';
import 'generated/l10n.dart';
import 'main.dart';
import 'package:path/path.dart' as p;

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

class FullBackupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FullBackupState();
}

class FullBackupState extends State<FullBackupPage> {
  final key = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.fullBackup)),
        body: Card(
            child: Column(children: [
            TextField(
              decoration: InputDecoration(labelText: s.backupEncryptionKey),
              minLines: 1,
              maxLines: 5,
              controller: key,
            ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          ButtonBar(children: [
          ElevatedButton.icon(onPressed: _onGenerate, icon: Icon(Icons.key), label: Text('Generate')),
          ElevatedButton.icon(
              onPressed: () => _onSave(context),
              icon: Icon(Icons.save),
              label: Text(s.saveBackup))
          ])
        ])));
  }

  _onSave(BuildContext context) async {
    WarpApi.zipBackup(key.text, settings.tempDir);
    final backupPath = p.join(settings.tempDir, BACKUP_NAME);
    await exportFile(context, backupPath, BACKUP_NAME);
  }

  _onGenerate() {
    key.text = WarpApi.generateKey();
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
            minLines: 1,
            maxLines: 5,
            controller: controller,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
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
      final key = controller.text;
      try {
        if (key.isNotEmpty) {
          WarpApi.unzipBackup(key, filename, settings.tempDir);
          await showMessageBox(context, 'Db Import Successful',
              'Database updated. Please restart the app.', S.current.ok);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('recover', true);
        }
        else {
          final file = File(filename);
          final backup = await file.readAsString();
          WarpApi.importFromZWL(active.coin, "ZWL Imported Account", backup);
        }
        await accounts.refresh();
        syncStatus.setAccountRestored(true);
        Navigator.of(context).pop();
      }
      on String catch (message) {
        showSnackBar(message);
      }
    }
  }
}
