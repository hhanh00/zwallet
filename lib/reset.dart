import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';
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
              title: Text(s.applicationReset),
              content: Text(s.confirmResetApp),
              actions: confirmButtons(context, () {
                Navigator.of(context).pop(true);
              }, okLabel: s.reset, cancelValue: false)),
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
    return Observer(builder: (context) {
      key.text = settings.backupEncKey;
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
    });
  }

  _onSave(BuildContext context) async {
    if (key.text.isNotEmpty) {
      settings.setBackupEncKey(key.text);
      WarpApi.zipBackup(key.text, settings.tempDir);
      final backupPath = p.join(settings.tempDir, BACKUP_NAME);
      await exportFile(context, backupPath, BACKUP_NAME);
      Navigator.of(context).pop();
    }
  }

  _onGenerate() async {
    final keys = WarpApi.generateKey();
    final navigator = Navigator.of(context);
    final state = GlobalKey<AGEKeysState>();
    final assign = await showDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(16),
          title: Text('Backup Keys'),
          content: AGEKeysForm(keys, key: state),
          actions: [
            ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text(S.current.cancel),
              onPressed: () { navigator.pop(null); }
              ),
            ElevatedButton.icon(
              icon: Icon(Icons.check),
              label: Text(S.current.set),
              onPressed: () { navigator.pop(true); }
              )]
        )) ?? false;
    if (assign)
      settings.setBackupEncKey(state.currentState!.pk.text);
  }
}

class AGEKeysForm extends StatefulWidget {
  final AGEKeys keys;
  AGEKeysForm(this.keys, {Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => AGEKeysState();
}

class AGEKeysState extends State<AGEKeysForm> {
  final pk = TextEditingController();
  final sk = TextEditingController();

  @override
  void initState() {
    super.initState();
    pk.text = widget.keys.pk;
    sk.text = widget.keys.sk;
  }

  @override
  Widget build(BuildContext context) {
    return Form(child: SingleChildScrollView(child: Column(children: [
      TextFormField(decoration: InputDecoration(labelText: S.current.encryptionKey), controller: pk, readOnly: true),
      TextFormField(decoration: InputDecoration(labelText: S.current.secretKey), controller: sk, readOnly: true),
    ])));
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
            decoration: InputDecoration(labelText: s.privateKey, hintText: 'AGE-SECRET-KEY-'),
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
    final s = S.current;
    final result = await pickFile();

    if (result != null) {
      final filename = result.files.single.path!;
      final key = controller.text;
      try {
        if (key.isNotEmpty) {
          WarpApi.unzipBackup(key, filename, settings.tempDir);
          await showMessageBox(context, s.dbImportSuccessful,
              s.databaseUpdatedPleaseRestartTheApp, s.ok);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('recover', true);
        }
        else {
          final file = File(filename);
          final backup = await file.readAsString();
          WarpApi.importFromZWL(active.coin, "ZWL Imported Account", backup);
        }
        syncStatus.setAccountRestored(true);
        Navigator.of(context).pop();
      }
      on String catch (message) {
        showSnackBar(message);
      }
    }
  }
}
