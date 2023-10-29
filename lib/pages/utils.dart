import 'dart:async';

import 'package:YWallet/main.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../accounts.dart';
import '../appsettings.dart';
import '../generated/intl/messages.dart';
import '../router.dart';
import 'widgets.dart';

int decimalDigits(bool fullPrec) => fullPrec ? MAX_PRECISION : 3;

Future<bool> showMessageBox2(BuildContext context, String title, String content,
    {String? label}) async {
  final s = S.of(context);
  final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(content), actions: [
            ElevatedButton.icon(
                onPressed: () => GoRouter.of(context).pop(),
                icon: Icon(Icons.check),
                label: Text(label ?? s.ok))
          ]));
  return confirm ?? false;
}

mixin WithLoadingAnimation<T extends StatefulWidget> on State<T> {
  bool loading = false;

  Widget wrapWithLoading(Widget child) {
    return LoadingWrapper(loading, child: child);
  }

  Future<U> load<U>(Future<U> Function() calc) async {
    try {
      setLoading(true);
      return await calc();
    }
    finally {
      setLoading(false);
    }
  }

  setLoading(bool v) {
    if (mounted) setState(() => loading = v);
  }
}

Future<void> showSnackBar(String msg) async {
  final bar = FlushbarHelper.createInformation(message: msg, duration: Duration(seconds: 4));
  await bar.show(rootNavigatorKey.currentContext!);
}

void openTxInExplorer(String txId) {
    final settings = CoinSettingsExtension.load(aa.coin);
    final url = settings.resolveBlockExplorer(aa.coin);
    launchUrl(Uri.parse("$url/$txId"), mode: LaunchMode.inAppWebView);
}
