import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'main.dart';
import 'store.dart';
import 'generated/l10n.dart';

class BackupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackupState();
}

class BackupState extends State<BackupPage> {
  Backup backup;
  final _backupController = TextEditingController();
  final _skController = TextEditingController();
  final _ivkController = TextEditingController();

  Future<bool> _init() async {
    backup = await accountManager.getBackup();
    _backupController.text = backup.value();
    _skController.text = backup.sk ?? "";
    _ivkController.text = backup.ivk ?? "";
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(S.of(context).backup)), body:
        FutureBuilder(
          future: _init(),
          builder: _build,
        ));
  }

  Widget _build(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (!snapshot.hasData) return LinearProgressIndicator();
    final type = backup.type;
    return Card(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                labelText: S.of(context).backupDataRequiredForRestore, prefixIcon: IconButton(icon: Icon(Icons.save),
                onPressed: () => _showQR(backup.value()))),
            controller: _backupController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,

          ),
          if (type == 0) TextField(
            decoration: InputDecoration(labelText: S.of(context).secretKey, prefixIcon: IconButton(icon: Icon(Icons.vpn_key),
    onPressed: () => _showQR(backup.sk))),
            controller: _skController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: Theme.of(context).textTheme.caption
          ),
          if (type != 2) TextField(
            decoration: InputDecoration(labelText: S.of(context).viewingKey, prefixIcon: IconButton(icon: Icon(Icons.visibility),
    onPressed: () => _showQR(backup.ivk))),
            controller: _ivkController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: Theme.of(context).textTheme.caption
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Text(S.of(context).tapAnIconToShowTheQrCode),
        ]
      ),
    );
  }

  _showQR(String text) => showQR(context, text);
}
