import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../generated/intl/messages.dart';
import 'utils.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/welcome.png', width: size.width, height: size.height - 310, fit: BoxFit.fill),
            Gap(8),
            Text(s.welcomeToYwallet, style: t.textTheme.headlineSmall!),
            Gap(8),
            Text(s.thePrivateWalletMessenger, style: t.textTheme.titleMedium!),
            Gap(16),
            OutlinedButton(onPressed: () { _onNew(context); }, 
              child: Text(s.newAccount)),
            Gap(32),
      ]))
    );
  }

  _onNew(BuildContext context) {
    GoRouter.of(context).push('/disclaimer');
  }
}
