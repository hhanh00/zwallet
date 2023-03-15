import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';

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
        body: ListView(padding: EdgeInsets.all(8), children: [
          ListTile(
              title: Text('Sync Stats'),
              trailing: Icon(Icons.chevron_right),
              onTap: _syncStats),
          ListTile(
              title: Text('Reset Scan State'),
              trailing: Icon(Icons.chevron_right),
              onTap: _resetScan),
          ListTile(
              title: Text('Reset App'),
              trailing: Icon(Icons.chevron_right),
              onTap: resetApp),
          ListTile(
              title: Text('Trigger Reorg'),
              trailing: Icon(Icons.chevron_right),
              onTap: _reorg),
          ListTile(
              title: Text('Mark as Synced'),
              trailing: Icon(Icons.chevron_right),
              onTap: _markAsSynced),
          ListTile(
              title: Text('Clear Tx Details'),
              trailing: Icon(Icons.chevron_right),
              onTap: _clearTxDetails),
          ListTile(
              title: Text('Revoke Dev mode'),
              trailing: Icon(Icons.chevron_right),
              onTap: _resetDevMode),
        ]));
  }

  void _syncStats() {
    Navigator.of(context).pushNamed('/syncstats');
  }

  _resetScan() {
    WarpApi.truncateSyncData();
    syncStatus.reset();
  }

  _reorg() async {
    await syncStatus.reorg();
  }

  _markAsSynced() {
    WarpApi.skipToLastHeight(active.coin);
  }

  _clearTxDetails() {
    WarpApi.clearTxDetails(active.coin, active.id);
  }

  _resetDevMode() {
    showSnackBar('Dev mode disabled');
    settings.resetDevMode();
  }
}
