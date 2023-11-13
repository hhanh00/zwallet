import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../generated/intl/messages.dart';
import 'utils.dart';

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
            ElevatedButton.icon(onPressed: () { _onNew(context); }, 
              icon: Icon(Icons.add),
              label: Text(s.newAccount)),
            Padding(padding: EdgeInsets.symmetric(vertical: 32)),
      ]))
    );
  }

  _onNew(BuildContext context) {
    GoRouter.of(context).push('/first_account');
  }
}
