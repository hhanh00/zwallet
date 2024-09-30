import 'package:YWallet/init.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../utils.dart';
import '../widgets.dart';

class BatchBackupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BatchBackupState();
}

class _BatchBackupState extends State<BatchBackupPage> {
  final backupFormKey = GlobalKey<FormBuilderState>();
  final restoreFormKey = GlobalKey<FormBuilderState>();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Gap(16),
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
                      Gap(8),
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
              Gap(16),
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
                      Gap(8),
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
      ),
    );
  }

  key() async {
    final keys =
        await GoRouter.of(context).push<AgekeysT>('/more/backup/keygen');
    keys?.let((keys) => backupKeyController.text = keys.publicKey!);
  }

  save() async {
    final s = S.of(context);
    final outFilePath = isMobile()
        ? await getTemporaryPath('YWallet.age')
        : await FilePicker.platform.saveFile(dialogTitle: s.fullBackup);
    if (outFilePath != null) {
      final dbDir = appStore.dbDir;
      final version = appStore.dbVersion;
      try {
        List<String> files = [];
        for (var c in coins) {
          final fn = dbFileByVersion(dbDir, c.dbRoot, version).path;
          files.add(path.relative(fn, from: dbDir));
        }
        await warp.encryptZIPDbFiles(
            dbDir, files, outFilePath, backupKeyController.text);
        if (isMobile()) {
          await shareFile(context, outFilePath, title: s.fullBackup);
        }
      } on String catch (e) {
        await showMessageBox(context, s.error, e);
      }
    }
  }

  restore() async {
    final s = S.of(context);
    final r = await FilePicker.platform.pickFiles(dialogTitle: s.fullRestore);
    if (r != null) {
      final file = r.files.first;
      final docDir = (await getApplicationDocumentsDirectory());
      final tempDir = docDir.createTempSync().path;
      try {
        await warp.decryptZIPDbFiles(
            file.path!, tempDir, restoreKeyController.text);
        final prefs = GetIt.I.get<SharedPreferences>();
        await prefs.setString('backup', tempDir);
        await AwesomeDialog(
          context: context,
          title: s.databaseRestored,
          desc: s.pleaseQuitAndRestartTheAppNow,
          dialogType: DialogType.warning,
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        )
          ..show();
      } on String catch (e) {
        restoreFormKey.currentState!.fields['restore']!.invalidate(e);
      }
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

class KeygenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KeygenState();
}

class _KeygenState extends State<KeygenPage> with WithLoadingAnimation {
  late final s = S.of(context);
  AgekeysT? _keys;

  @override
  void initState() {
    super.initState();
    Future(_keygen);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.keygen),
          actions: [
            IconButton(onPressed: _keygen, icon: Icon(Icons.refresh)),
            IconButton(onPressed: _ok, icon: Icon(Icons.check)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Gap(16),
                Panel(s.help,
                    child: Text(s.keygenHelp, style: t.textTheme.titleSmall)),
                Gap(16),
                Panel(s.encryptionKey, text: _keys?.publicKey, save: true),
                Gap(16),
                Panel(s.secretKey, text: _keys?.secretKey, save: true),
              ],
            ),
          ),
        ));
  }

  _keygen() async {
    final keys = await load(() => warp.generateZIPDbKeys());
    setState(() => _keys = keys);
  }

  _ok() async {
    final confirm =
        await showConfirmDialog(context, s.keygen, s.confirmSaveKeys);
    if (confirm) GoRouter.of(context).pop(_keys);
  }
}
