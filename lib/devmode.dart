import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';
import 'package:http/http.dart' as http;

import 'accounts.dart';
import 'coin/coins.dart';
import 'generated/l10n.dart';
import 'main.dart';

final String instantSyncHost = "zec.hanh00.fun"; // temporary & under debugmode

class DevPage extends StatefulWidget {
  DevPageState createState() => DevPageState();
}

class DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Developer Menu')),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          ListTile(title: Text('Import Database'), trailing: Icon(Icons.chevron_right), onTap: _importDb),
          ListTile(title: Text('Export Database'), trailing: Icon(Icons.chevron_right), onTap: _exportDb),
          ListTile(title: Text('Import Sync Data'), trailing: Icon(Icons.chevron_right), onTap: _importSyncData),
          ListTile(title: Text('Reset Scan State'), trailing: Icon(Icons.chevron_right), onTap: _resetScan),
          ListTile(title: Text('Reset App'), trailing: Icon(Icons.chevron_right), onTap: _resetApp),
          ListTile(title: Text('Trigger Reorg'), trailing: Icon(Icons.chevron_right), onTap: _reorg),
          ListTile(title: Text('Rewind Height'), trailing: Icon(Icons.chevron_right), onTap: _rewindHeight),
          ListTile(title: Text('Mark as Synced'), trailing: Icon(Icons.chevron_right), onTap: _markAsSynced),
        ]
      )
    );
  }

  Future<void> _exportDb() async {
    final authenticated = await authenticate(context, 'Export DB');
    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('export_db', true);
      showSnackBar('Backup scheduled', autoClose: true);
    }
  }

  Future<void> _importDb() async {
    final confirmation = await showConfirmDialog(context, 'DB', S.of(context).doYouWantToRestore);
    if (!confirmation) return;
    final s = S.of(context);
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.single;
      bool imported = false;
      for (var coin in [ycash, zcash]) {
        if (await coin.tryImport(file)) {
          imported = true;
          break;
        }
      }
      if (imported) {
        await showMessageBox(context, 'Db Import Successful',
            'Database updated. Please restart the app.', s.ok);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('recover', true);
      }
      else
        await showMessageBox(
            context, 'Db Import Failed', 'Please check the database file', s.ok);
    }
  }

  Future<void> _importSyncData() async {
    final s = S.of(context);

    final String path;
    if (settings.instantSync) {
      final confirm = await showConfirmDialog(context, "Do you want to use Instant-Sync?", "Your viewing key will be sent to a remote server for processing.");
      if (!confirm) return;
      final backup = await getBackup(active.toId());
      final response = await http.post(Uri(scheme: "https", host: instantSyncHost, path: "/api/scan_fvk", queryParameters: {
        "fvk": backup.ivk,
      }));
      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/syncdata.json");
      await file.writeAsString(response.body);
      path = file.path;
    }
    else {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      path = result.files.single.path!;
    }

    WarpApi.importSyncFile(active.coin, path);
    if (WarpApi.getError()) {
      final message = WarpApi.getErrorMessage();
      await showMessageBox(context, 'Import failed', message, s.ok);
    }
    else {
      await active.refreshAccount();
      await showMessageBox(context, "Synchronized", "Your account is synchronized", s.ok);
    }
  }

  _resetScan() {
    WarpApi.truncateSyncData();
    syncStatus.reset();
  }

  _rewindHeight() async {
    var heightNameController = TextEditingController();
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Rewind to Height'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                decoration: InputDecoration(label: Text('Height')),
                controller: heightNameController,
                keyboardType: TextInputType.number,
              ),
            ]),
            actions: confirmButtons(context, () {
              Navigator.of(context).pop(true);
            }))) ?? false;
    if (confirmed) {
      final height = int.tryParse(heightNameController.text);
      if (height != null) {
        final newHeight = WarpApi.rewindToHeight(height);
        showSnackBar('Rewinding to ${height}, got ${newHeight}');
        syncStatus.reset();
        await syncStatus.update();
      }
    }
  }

  _resetApp() {
    resetApp(context);
  }

  _reorg() async {
    await syncStatus.reorg();
  }

  _markAsSynced() {
    WarpApi.skipToLastHeight(active.coin);
  }
}
