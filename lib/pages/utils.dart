import 'package:YWallet/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../generated/intl/messages.dart';

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
