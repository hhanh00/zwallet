import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../generated/intl/messages.dart';
import '../../router.dart';
import '../scan.dart';
import '../utils.dart';
import '../widgets.dart';

abstract class AnimatedQRScanPage extends StatelessWidget {
  String get title;
  String get caption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                onPressed: () => open(context), icon: Icon(Icons.open_in_new))
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 400,
                width: 400,
                child: MultiQRReader(onChanged: (v) => onData(context, v!))),
            Gap(16),
            Text(caption),
          ],
        )));
  }

  open(BuildContext context) async {
    final txFileResult = await pickFile();
    if (txFileResult?.isSinglePick == true) {
      final path = txFileResult!.files[0].path;
      final xfile = XFile(path!);
      final data = await xfile.readAsString();
      onData(context, data);
    }
  }

  Future<void> onData(BuildContext context, String rawTx);
}

class ColdSignPage extends AnimatedQRScanPage {
  @override
  String get title => S.of(rootNavigatorKey.currentContext!).rawTransaction;

  @override
  String get caption => S.of(rootNavigatorKey.currentContext!).scanRawTx;

  @override
  Future<void> onData(BuildContext context, String data) async {
    GoRouter.of(context).go('/account/txplan?tab=more&sign=1', extra: data);
  }
}

class SignedTxPage extends StatelessWidget {
  final String txBin;
  SignedTxPage(this.txBin);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.signedTx), actions: [
          IconButton(onPressed: () => export(context), icon: Icon(Icons.save))
        ]),
        body: AnimatedQR.init(s.signedTx, s.scanSignedTx, txBin));
  }

  export(BuildContext context) async {
    final s = S.of(context);
    await saveFile(txBin, 'tx.bin', s.signedTx);
  }
}

class BroadcastTxPage extends AnimatedQRScanPage {
  @override
  String get title => S.of(rootNavigatorKey.currentContext!).signedTx;

  @override
  String get caption => S.of(rootNavigatorKey.currentContext!).scanSignedTx;

  @override
  Future<void> onData(BuildContext context, String data) async {
    GoRouter.of(context).go('/account/broadcast_tx', extra: data);
  }
}
