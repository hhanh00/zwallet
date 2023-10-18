import 'package:flutter/material.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/intl/messages.dart';

class BackupPage extends StatefulWidget {
  final int coin;
  final int id;

  BackupPage(this.coin, this.id);

  @override
  State<StatefulWidget> createState() => BackupState();
}

class BackupState extends State<BackupPage> {
  late Backup backup;
  final _backupController = TextEditingController();
  final _skController = TextEditingController();
  final _fvkController = TextEditingController();
  final _uvkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    backup = WarpApi.getBackup(widget.coin, widget.id);
    _backupController.text = backupData;
    _skController.text = backup.sk ?? "";
    _fvkController.text = backup.fvk ?? "";
    _uvkController.text = backup.uvk ?? "";
  }

  String get backupData => (value ?? "") + (backup.index != 0 ? " [${backup.index}]" : "");
  String? get value {
    if (backup.seed != null) return backup.seed;
    if (backup.sk != null) return backup.sk;
    if (backup.uvk != null) return backup.uvk;
    if (backup.fvk != null) return backup.fvk;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final name = backup.name!;
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: Text(s.backup)),
    body: SingleChildScrollView(child: Card(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                labelText: s.backupDataRequiredForRestore(name), prefixIcon: IconButton(icon: Icon(Icons.save),
                onPressed: () => _showQR(backupData, "$name - backup"))),
            controller: _backupController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
          if (backup.sk != null) TextField(
            decoration: InputDecoration(labelText: s.secretKey, prefixIcon: IconButton(icon: Icon(Icons.vpn_key),
              onPressed: () => _showQR(backup.sk!, "$name - sk"))),
            controller: _skController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: theme.textTheme.bodySmall
          ),
          if (backup.fvk != null) TextField(
            decoration: InputDecoration(labelText: s.viewingKey, prefixIcon: IconButton(icon: Icon(Icons.visibility),
              onPressed: () => _showQR(backup.fvk!, "$name - vk"))),
            controller: _fvkController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: theme.textTheme.bodySmall
          ),
          if (backup.uvk != null) TextField(
              decoration: InputDecoration(labelText: s.unifiedViewingKey, prefixIcon: IconButton(icon: Icon(Icons.visibility),
                  onPressed: () => _showQR(backup.uvk!, "$name - uvk"))),
              controller: _uvkController,
              minLines: 3,
              maxLines: 10,
              readOnly: true,
              style: theme.textTheme.bodySmall
          ),
        Padding(padding: EdgeInsets.symmetric(vertical: 4)),
        Text(s.tapAnIconToShowTheQrCode),
        Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: theme.primaryColor),
                borderRadius: BorderRadius.circular(4)),
            child: Text(s.backupWarning,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: theme.primaryColor))),
          ElevatedButton.icon(
            icon: Icon(Icons.check),
            label: Text(S.of(context).iHaveMadeABackup),
            onPressed: () {
              final nav = Navigator.of(context);
              if (nav.canPop())
                nav.pop();
              else
                nav.pushReplacementNamed('/account');
            },
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
      ]),
    )));
  }

  _showQR(String text, String title) => showQR(context, text, title);
}
