import 'package:flutter/material.dart';

import 'generated/l10n.dart';
import 'main.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon.png', width: 64),
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Text(s.welcomeToYwallet, style: t.textTheme.headlineSmall!),
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Text(s.thePrivateWalletMessenger, style: t.textTheme.titleMedium!),
            Padding(padding: EdgeInsets.symmetric(vertical: 16)),
            ElevatedButton(onPressed: () { _onNew(context); }, child: Text(s.newAccount)),
            Padding(padding: EdgeInsets.symmetric(vertical: 32)),
      ]))
    );
  }

  _onNew(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/add_first_account');
  }
}
