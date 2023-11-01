import 'package:YWallet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:k_chart/extension/map_ext.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';

import '../accounts.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
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
                    final c = coins[aa.coin];
                    if (!WarpApi.decryptDb(c.dbFullPath, v!))
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
    if (form.validate()) {
      form.save();
      await load(() async {
        final tempDir = await getTemporaryDirectory();
        final passwd = newController.text;
        final path = await WarpApi.zipDbs(passwd, tempDir.path);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('backup', path);
      });
      await showMessageBox2(
          context, s.restart, s.pleaseQuitAndRestartTheAppNow, dismissable: false);
      GoRouter.of(context).pop();
    }
  }
}
