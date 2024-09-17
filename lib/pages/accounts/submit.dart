import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../utils.dart';
import '../widgets.dart';

class SubmitTxPage extends StatefulWidget {
  final TransactionSummaryT txSummary;
  SubmitTxPage(this.txSummary);
  @override
  State<StatefulWidget> createState() => _SubmitTxState();
}

class _SubmitTxState extends State<SubmitTxPage> {
  String? txId;
  String? error;

  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        final txBytes = await warp.sign(aa.coin, widget.txSummary, syncStatus.expirationHeight);
        String json = jsonDecode(await warp.broadcast(aa.coin, txBytes));
        txId = json;
      } on String catch (e) {
        error = e;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(txId != null
              ? s.sent
              : error != null
                  ? s.sent_failed
                  : s.sending),
          actions: [
            IconButton(onPressed: ok, icon: Icon(Icons.check)),
          ]),
      body: Center(
          child: txId != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Jumbotron(txId!, title: s.txID),
                    Gap(16),
                    OutlinedButton(
                        onPressed: _openTx, child: Text(s.openInExplorer))
                  ],
                )
              : error != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Jumbotron(error!,
                            title: s.error, severity: Severity.Error)
                      ],
                    )
                  : LoadingAnimationWidget.beat(
                      color: t.colorScheme.primary, size: 200)),
    );
  }

  _openTx() {
    openTxInExplorer(txId!);
  }

  ok() {
    GoRouter.of(context).pop();
  }
}

// class ExportUnsignedTxPage extends StatefulWidget {
//   final Uint8List data;
//   ExportUnsignedTxPage(this.data);
  
//   @override
//   State<StatefulWidget> createState() => ExportUnsignedTxState();
// }

// class ExportUnsignedTxState extends State<ExportUnsignedTxPage> {
//   List<PacketT> packets = [];

//   @override
//   void initState() {
//     super.initState();
//     Future(() async {
//       final p = await warp.splitData(aa.coin, widget.data, 1);
//       setState(() {
//         packets = p;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = S.of(context);
//     return Scaffold(
//       appBar: AppBar(title: Text(s.unsignedTx), actions: [
//         IconButton(onPressed: () => export(context), icon: Icon(Icons.save))
//       ]),
//       body: packets.isNotEmpty ?
//         AnimatedQR(s.rawTransaction, s.scanQrCode, packets) :
//         SizedBox.shrink(),
//     );
//   }

//   export(BuildContext context) async {
//     final s = S.of(context);
//     await saveFile(data, 'tx.raw', s.rawTransaction);
//   }
// }
