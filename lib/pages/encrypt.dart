import 'dart:io';

import 'package:YWallet/init.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';

import '../accounts.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../store.dart';
import 'utils.dart';

class EncryptDbPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EncryptDbState();
}

class _EncryptDbState extends State<EncryptDbPage> with WithLoadingAnimation {
  late final s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final oldController = TextEditingController();
  final newController = TextEditingController();
  final repeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(s.encryptDatabase),
          actions: [IconButton(onPressed: encrypt, icon: Icon(Icons.check))],
        ),
        body: wrapWithLoading(
          SingleChildScrollView(
            child: FormBuilder(
              key: formKey,
              child: Column(children: [
                FormBuilderTextField(
                  name: 'old_passwd',
                  decoration: InputDecoration(label: Text(s.currentPassword)),
                  controller: oldController,
                  obscureText: true,
                  validator: (v) {
                    final version = appStore.dbVersion;
                    final dbFile =
                        getDbFile(aa.coin, appStore.dbDir, version)!.item2;
                    if (!warp.checkDbPassword(dbFile, v!))
                      return s.invalidPassword;
                    return null;
                  },
                ),
                FormBuilderTextField(
                  name: 'new_passwd',
                  decoration: InputDecoration(label: Text(s.newPassword)),
                  controller: newController,
                  obscureText: true,
                ),
                FormBuilderTextField(
                  name: 'repeat_passwd',
                  decoration: InputDecoration(label: Text(s.repeatNewPassword)),
                  controller: repeatController,
                  obscureText: true,
                  validator: (v) {
                    if (v != formKey.currentState?.fields['new_passwd']?.value)
                      return s.newPasswordsDoNotMatch;
                    return null;
                  },
                ),
              ]),
            ),
          ),
        ));
  }

  encrypt() async {
    final form = formKey.currentState!;
    if (form.saveAndValidate()) {
      await load(() async {
        final dbDir = Directory(appStore.dbDir);
        final tempDir = await dbDir.createTemp();
        final tempPath = tempDir.path;
        final passwd = newController.text;
        logger.d(tempPath);
        for (var c in coins) {
          final newDbFile =
              dbFileByVersion(tempPath, c.dbRoot, appStore.dbVersion);
          await warp.encryptDb(c.coin, passwd, newDbFile.path);
        }
        final prefs = GetIt.I.get<SharedPreferences>();
        await prefs.setString('backup', tempPath);
      });

      await AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: s.restart,
        desc: s.pleaseQuitAndRestartTheAppNow,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        onDismissCallback: (_) => GoRouter.of(context).pop(),
      )
        ..show();
    }
  }
}
