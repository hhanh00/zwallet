import 'dart:async';
import 'dart:math';

import 'package:YWallet/main.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warp_api/warp_api.dart';

import '../accounts.dart';
import '../appsettings.dart';
import '../generated/intl/messages.dart';
import '../router.dart';
import 'widgets.dart';

int decimalDigits(bool fullPrec) => fullPrec ? MAX_PRECISION : 3;

Future<bool> showMessageBox2(BuildContext context, String title, String content,
    {String? label, bool dismissable = true}) async {
  final s = S.of(context);
  final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(content), actions: [
            if (dismissable)
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
    } finally {
      setLoading(false);
    }
  }

  setLoading(bool v) {
    if (mounted) setState(() => loading = v);
  }
}

Future<void> showSnackBar(String msg) async {
  final bar = FlushbarHelper.createInformation(
      message: msg, duration: Duration(seconds: 4));
  await bar.show(rootNavigatorKey.currentContext!);
}

void openTxInExplorer(String txId) {
  final settings = CoinSettingsExtension.load(aa.coin);
  final url = settings.resolveBlockExplorer(aa.coin);
  launchUrl(Uri.parse("$url/$txId"), mode: LaunchMode.inAppWebView);
}

String? addressCheck(String? v) {
  final s = S.of(rootNavigatorKey.currentContext!);
  if (v == null || v.isEmpty) return s.addressIsEmpty;
  final valid = WarpApi.validAddress(aa.coin, v);
  if (!valid) return s.invalidAddress;
  return null;
}

ColorPalette getPalette(Color color, int n) => ColorPalette.polyad(
      color,
      numberOfColors: max(n, 1),
      hueVariability: 15,
      saturationVariability: 10,
      brightnessVariability: 10,
    );

int poolOf(v) {
  switch (v) {
    case 1:
      return 0;
    case 2:
      return 1;
    case 4:
      return 2;
    default:
      return 0;
  }
}

Future<void> authBarrier(BuildContext context) async {
  final s = S.of(context);
  while (true) {
    final authed = await authenticate(context, s.pleaseAuthenticate);
    if (authed) break;
  }
}
