import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/warp.dart';

import '../generated/intl/messages.dart';
import '../init.dart';
import '../store.dart';
import 'utils.dart';

class DbLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DbLoginState();
}

class _DbLoginState extends State<DbLoginPage> {
  final formKey = GlobalKey<FormBuilderState>();
  final passwordController = TextEditingController();
  String? currentDb;

  void initState() {
    super.initState();
    if (!isMobile()) {
      // db encryption is only for desktop
      currentDb = getDbFile(0, appStore.dbDir, appStore.dbVersion)?.item2;
      if (currentDb != null) {
        // fresh install are not encrypted
        if (!warp.checkDbPassword(currentDb!, '')) 
          return; // encrypted
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).go('/splash');
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.databasePassword)),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'password',
                  decoration: InputDecoration(label: Text(s.currentPassword)),
                  controller: passwordController,
                  obscureText: true,
                ),
                Gap(16),
                ElevatedButton.icon(
                  onPressed: _ok,
                  icon: Icon(Icons.password),
                  label: Text(s.ok),
                ),
              ],
            ),
          ),
        ));
  }

  _ok() async {
    final s = S.of(context);
    final password = passwordController.text;
    if (await warp.checkDbPassword(currentDb!, password)) {
      appStore.dbPassword = password;
      GoRouter.of(context).go('/splash');
    } else {
      formKey.currentState!.fields['password']!.invalidate(s.invalidPassword);
    }
  }
}
