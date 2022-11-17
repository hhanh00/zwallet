import 'package:flutter/material.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';

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
  final _ivkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    backup = WarpApi.getBackup(widget.coin, widget.id);
    _backupController.text = backupData;
    _skController.text = backup.sk ?? "";
    _ivkController.text = backup.ivk;
  }

  String get backupData => backup.value() + (backup.index != 0 ? " [${backup.index}]" : "");

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final name = backup.name;
    final type = backup.type;
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
          if (type == 0) TextField(
            decoration: InputDecoration(labelText: s.secretKey, prefixIcon: IconButton(icon: Icon(Icons.vpn_key),
              onPressed: () => _showQR(backup.sk!, "$name - sk"))),
            controller: _skController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: theme.textTheme.caption
          ),
          if (type != 2) TextField(
            decoration: InputDecoration(labelText: s.viewingKey, prefixIcon: IconButton(icon: Icon(Icons.visibility),
              onPressed: () => _showQR(backup.ivk, "$name - vk"))),
            controller: _ivkController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: theme.textTheme.caption
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
                style: theme.textTheme.subtitle1!
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
