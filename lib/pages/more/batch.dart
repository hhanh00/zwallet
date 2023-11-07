import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

import '../../generated/intl/messages.dart';
import '../utils.dart';

class BatchBackupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BatchBackupState();
}

class _BatchBackupState extends State<BatchBackupPage> {
  final backupFormKey = GlobalKey<FormBuilderFieldState>();
  final restoreFormKey = GlobalKey<FormBuilderFieldState>();
  final backupKeyController = TextEditingController();
  final restoreKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(s.backupAllAccounts),
          actions: [IconButton(onPressed: key, icon: Icon(Icons.key))]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                  label: Text(s.fullBackup), border: OutlineInputBorder()),
              child: Card(
                child: FormBuilder(
                  key: backupFormKey,
                  child: Column(children: [
                    FormBuilderTextField(
                      name: 'backup',
                      decoration: InputDecoration(label: Text(s.publicKey)),
                      controller: backupKeyController,
                    ),
                    SizedBox(height: 8),
                    ButtonBar(
                      children: [
                        ElevatedButton.icon(
                          onPressed: save,
                          icon: Icon(Icons.save),
                          label: Text(s.fullBackup),
                        )
                      ],
                    )
                  ]),
                ),
              ),
            ),
            SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                  label: Text(s.fullRestore), border: OutlineInputBorder()),
              child: Card(
                child: FormBuilder(
                  key: restoreFormKey,
                  child: Column(children: [
                    FormBuilderTextField(
                      name: 'restore',
                      decoration: InputDecoration(label: Text(s.secretKey)),
                      controller: restoreKeyController,
                    ),
                    SizedBox(height: 8),
                    ButtonBar(
                      children: [
                        ElevatedButton.icon(
                          onPressed: restore,
                          icon: Icon(Icons.open_in_new),
                          label: Text(s.fullRestore),
                        )
                      ],
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  key() {
    final keys = WarpApi.generateKey();
    backupKeyController.text = keys.pk!;
    restoreKeyController.text = keys.sk!;
  }

  save() async {
    final s = S.of(context);
    final tempDir = await getTemporaryDirectory();
    final path = isMobile()
        ? await getTemporaryPath('YWallet.age')
        : await FilePicker.platform.saveFile(dialogTitle: s.fullBackup);
    if (path != null) {
      WarpApi.zipBackup(backupKeyController.text, path, tempDir.path);
      if (isMobile()) {
        await shareFile(context, path, title: s.fullBackup);
      }
    }
  }

  restore() async {
    final s = S.of(context);
    final r = await FilePicker.platform.pickFiles(dialogTitle: s.fullRestore);
    if (r != null) {
      final file = r.files.first;
      final dbDir = await getDbPath();
      final zipFile =
          WarpApi.decryptBackup(restoreKeyController.text, file.path!, dbDir);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backup', zipFile);
      await showMessageBox2(context, s.databaseRestored, s.pleaseQuitAndRestartTheAppNow, dismissable: false);
      GoRouter.of(context).pop();
    }
  }
}

Future<String> getTemporaryPath(String filename) async {
  final dir = await getTemporaryDirectory();
  return path.join(dir.path, filename);
}

Future<void> shareFile(BuildContext context, String path,
    {String? title}) async {
  Size size = MediaQuery.of(context).size;
  final xfile = XFile(path);
  await Share.shareXFiles([xfile],
      subject: title,
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
}

