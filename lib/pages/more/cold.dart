import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:flat_buffers/flat_buffers.dart';

import '../../generated/intl/messages.dart';
import '../../router.dart';
import '../scan.dart';
import '../utils.dart';

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
                child: MultiQRReader(onChanged: 
                  (v) => onData(context, Uint8List.fromList(v)))),
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
      final data = await xfile.readAsBytes();
      onData(context, data);
    }
  }

  Future<void> onData(BuildContext context, Uint8List rawTx);
}

class ColdSignPage extends AnimatedQRScanPage {
  @override
  String get title => S.of(rootNavigatorKey.currentContext!).rawTransaction;

  @override
  String get caption => S.of(rootNavigatorKey.currentContext!).scanRawTx;

  @override
  Future<void> onData(BuildContext context, List<int> data) async {
    final bb = Uint8List.fromList(data);
    final bd = ByteData.sublistView(bb, 0);
    final bc = BufferContext(bd);
    final tx = TransactionSummary.reader.read(bc, 0).unpack();
    GoRouter.of(context).go('/account/txplan?tab=more&sign=1', extra: tx);
  }
}

class BroadcastTxPage extends AnimatedQRScanPage {
  @override
  String get title => S.of(rootNavigatorKey.currentContext!).signedTx;

  @override
  String get caption => S.of(rootNavigatorKey.currentContext!).scanSignedTx;

  @override
  Future<void> onData(BuildContext context, Uint8List data) async {
    final tx = TransactionBytes(data);
    GoRouter.of(context).go('/account/broadcast_tx', extra: tx.unpack());
  }
}
