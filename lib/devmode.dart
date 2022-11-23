import 'dart:io';

import 'package:mobx/mobx.dart' as mobx;
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
          ListTile(title: Text('Sync Stats'), trailing: Icon(Icons.chevron_right), onTap: _syncStats),
          ListTile(title: Text('Reset Scan State'), trailing: Icon(Icons.chevron_right), onTap: _resetScan),
          ListTile(title: Text('Reset App'), trailing: Icon(Icons.chevron_right), onTap: resetApp),
          ListTile(title: Text('Trigger Reorg'), trailing: Icon(Icons.chevron_right), onTap: _reorg),
          ListTile(title: Text('Rewind Height'), trailing: Icon(Icons.chevron_right), onTap: _rewindHeight),
          ListTile(title: Text('Mark as Synced'), trailing: Icon(Icons.chevron_right), onTap: _markAsSynced),
          ListTile(title: Text('Revoke Dev mode'), trailing: Icon(Icons.chevron_right), onTap: _resetDevMode),
        ]
      )
    );
  }

  Future<void> _exportDb() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('export_db', true);
    showSnackBar('Backup scheduled', autoClose: true);
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

  void _syncStats() {
    Navigator.of(context).pushNamed('/syncstats');
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
        final newHeight = WarpApi.rewindTo(height);
        showSnackBar('Rewinding to ${height}, got ${newHeight}');
        syncStatus.reset();
        await syncStatus.update();
      }
    }
  }

  _reorg() async {
    await syncStatus.reorg();
  }

  _markAsSynced() {
    WarpApi.skipToLastHeight(active.coin);
  }

  _resetDevMode() {
    showSnackBar('App reset');
    settings.resetDevMode();
  }
}
