import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/warp_api.dart';

import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../store2.dart';

class DbLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DbLoginState();
}

class _DbLoginState extends State<DbLoginPage> {
  final formKey = GlobalKey<FormBuilderState>();
  final passwordController = TextEditingController();

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

  _ok() {
    final s = S.of(context);
    final password = passwordController.text;
    final c = coins.first;
    if (WarpApi.decryptDb(c.dbFullPath, password)) {
      appStore.dbPassword = password;
      GoRouter.of(context).go('/splash');
    } else {
      formKey.currentState!.fields['password']!.invalidate(s.invalidPassword);
    }
  }
}
