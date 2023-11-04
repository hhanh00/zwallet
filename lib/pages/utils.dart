import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:YWallet/main.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:key_guardmanager/key_guardmanager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';
import 'package:path/path.dart' as p;

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

String? addressValidator(String? v) {
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

Future<bool> authBarrier(BuildContext context,
    {bool dismissable = false}) async {
  final s = S.of(context);
  while (true) {
    final authed = await authenticate(context, s.pleaseAuthenticate);
    if (authed) return true;
    if (dismissable) return false;
  }
}

Future<bool> authenticate(BuildContext context, String reason) async {
  final s = S.of(context);
  if (!isMobile()) {
    if (appStore.dbPassword.isEmpty) return true;
    final formKey = GlobalKey<FormBuilderState>();
    final passwdController = TextEditingController();
    final authed = await showAdaptiveDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: Text(s.pleaseAuthenticate),
                content: Card(
                    child: FormBuilder(
                        key: formKey,
                        child: FormBuilderTextField(
                          name: 'passwd',
                          decoration:
                              InputDecoration(label: Text(s.databasePassword)),
                          controller: passwdController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            (v) => v != appStore.dbPassword
                                ? s.invalidPassword
                                : null,
                          ]),
                        ))),
                actions: [
                  IconButton(
                      onPressed: () => GoRouter.of(context).pop(false),
                      icon: Icon(Icons.cancel)),
                  IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate())
                          GoRouter.of(context).pop(true);
                      },
                      icon: Icon(Icons.check)),
                ],
              );
            }) ??
        false;
    return authed;
  }

  final localAuth = LocalAuthentication();
  try {
    final bool didAuthenticate;
    if (Platform.isAndroid && !await localAuth.canCheckBiometrics) {
      didAuthenticate = await KeyGuardmanager.authStatus == "true";
    } else {
      didAuthenticate = await localAuth.authenticate(
          localizedReason: reason, options: AuthenticationOptions());
    }
    if (didAuthenticate) {
      return true;
    }
  } on PlatformException catch (e) {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).noAuthenticationMethod),
            content: Text(e.message ?? '')));
  }
  return false;
}

void handleAccel(AccelerometerEvent event) {
  final n = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  final inclination = acos(event.z / n) / pi * 180 * event.y.sign;
  final flat = inclination < 20
      ? true
      : inclination > 40
          ? false
          : null;
  flat?.let((f) {
    if (f != appStore.flat) appStore.flat = f;
  });
}

double getScreenSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return min(size.height, size.width);
}

Future<void> saveFileBinary(
    List<int> data, String filename, String title) async {
  if (isMobile()) {
    final context = navigatorKey.currentContext!;
    Size size = MediaQuery.of(context).size;
    final tempDir = settings.tempDir;
    final path = p.join(tempDir, filename);
    final xfile = XFile(path);
    final file = File(path);
    await file.writeAsBytes(data);
    await Share.shareXFiles([xfile],
        subject: title,
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  } else {
    final fn = await FilePicker.platform
        .saveFile(dialogTitle: title, fileName: filename);
    if (fn != null) {
      final file = File(fn);
      await file.writeAsBytes(data);
    }
  }
}

int getSpendable(int pools, PoolBalanceT balances) {
  return (pools & 1 != 0 ? balances.transparent : 0) +
      (pools & 2 != 0 ? balances.sapling : 0) +
      (pools & 4 != 0 ? balances.orchard : 0);
}

class MemoData {
  bool reply;
  String subject;
  String memo;
  MemoData(this.reply, this.subject, this.memo);

  MemoData clone() => MemoData(reply, subject, memo);
}

extension ScopeFunctions<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
