import 'package:YWallet/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../appsettings.dart';
import '../../generated/intl/messages.dart';

class SwapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SwapState();
}

class SwapState extends State<SwapPage> {
  @override
  void initState() {
    super.initState();
    if (!appSettings.swapDisclaimerAccepted) {
      Future(showSwapDisclaimer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.swapProviders),
        actions: [
          IconButton(onPressed: () => GoRouter.of(context).push('/account/swap/history'), icon: Icon(Icons.list)),
        ]
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/account/swap/stealthex'),
              child: Image.asset('assets/stealthex.png'),
            ),
          ],
        ),
      ),
    );
  }
}

void showSwapDisclaimer() async {
  final context = rootNavigatorKey.currentContext!;
  final s = S.of(context);
  final t = Theme.of(context);
  await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      content: Text(s.swapDisclaimer, style: t.textTheme.headlineSmall),
      actions: [
        FormBuilderCheckbox(
          name: 'disclaimer',
          title: Text(s.dontShowAnymore),
          initialValue: appSettings.swapDisclaimerAccepted,
          onChanged: (v) async {
            appSettings.swapDisclaimerAccepted = v!;
            appSettings.save(await SharedPreferences.getInstance());
          },
        )
      ],
    ),
  );
}
