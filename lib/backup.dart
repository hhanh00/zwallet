import 'package:flutter/material.dart';

import 'main.dart';
import 'store.dart';
import 'generated/l10n.dart';

class BackupPage extends StatefulWidget {
  final int? accountId;

  BackupPage(this.accountId);

  @override
  State<StatefulWidget> createState() => BackupState();
}

class BackupState extends State<BackupPage> {
  late Backup backup;
  final _backupController = TextEditingController();
  final _skController = TextEditingController();
  final _ivkController = TextEditingController();
  final _shareController = TextEditingController();

  Future<bool> _init() async {
    backup = await accountManager.getBackup(widget.accountId ?? accountManager.active.id);
    _backupController.text = backup.value();
    _skController.text = backup.sk ?? "";
    _ivkController.text = backup.ivk;
    final share = backup.share;
    _shareController.text = share?.value ?? "";
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
    final name = backup.name;
    final share = backup.share;
    final type = backup.type;
    final theme = Theme.of(context);
    return SingleChildScrollView(child: Card(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                labelText: S.of(context).backupDataRequiredForRestore, prefixIcon: IconButton(icon: Icon(Icons.save),
                onPressed: () => _showQR(backup.value(), "$name - backup"))),
            controller: _backupController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
          if (type == 0) TextField(
            decoration: InputDecoration(labelText: S.of(context).secretKey, prefixIcon: IconButton(icon: Icon(Icons.vpn_key),
              onPressed: () => _showQR(backup.sk!, "$name - sk"))),
            controller: _skController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: theme.textTheme.caption
          ),
          if (type != 2) TextField(
            decoration: InputDecoration(labelText: S.of(context).viewingKey, prefixIcon: IconButton(icon: Icon(Icons.visibility),
              onPressed: () => _showQR(backup.ivk, "$name - vk"))),
            controller: _ivkController,
            minLines: 3,
            maxLines: 10,
            readOnly: true,
            style: theme.textTheme.caption
          ),
          if (share != null) TextField(
              decoration: InputDecoration(labelText: S.of(context).secretShare, prefixIcon: IconButton(icon: Icon(Icons.share),
                  onPressed: () => _showQR(share.value, "$name - ms ${share.index}/${share.participants}"))),
              controller: _shareController,
              minLines: 3,
              maxLines: 10,
              readOnly: true,
              style: theme.textTheme.caption
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Text(S.of(context).tapAnIconToShowTheQrCode),
          Container(margin: EdgeInsets.all(8), padding: EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(width: 2, color: theme.primaryColor), borderRadius: BorderRadius.circular(4)),child:
          Text(S.of(context).backupWarning,
          style: theme.textTheme.subtitle1!.copyWith(color: theme.primaryColor)))
        ]
      ),
    ));
  }

  _showQR(String text, String title) => showQR(context, text, title);
}
