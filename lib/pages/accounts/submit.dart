import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';
import '../widgets.dart';

class SubmitTxPage extends StatefulWidget {
  final String? txPlan;
  final String? txBin;
  SubmitTxPage({this.txPlan, this.txBin});
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
        String? txIdJs;
        if (widget.txPlan != null)
          txIdJs =
              await WarpApi.signAndBroadcast(aa.coin, aa.id, widget.txPlan!);
        if (widget.txBin != null)
          txIdJs = WarpApi.broadcast(aa.coin, widget.txBin!);
        txId = jsonDecode(txIdJs!);
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

class ExportUnsignedTxPage extends StatelessWidget {
  final String data;
  ExportUnsignedTxPage(this.data);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.unsignedTx), actions: [
        IconButton(onPressed: () => export(context), icon: Icon(Icons.save))
      ]),
      body: AnimatedQR.init(s.rawTransaction, s.scanQrCode, data),
    );
  }

  export(BuildContext context) async {
    final s = S.of(context);
    await saveFile(data, 'tx.raw', s.rawTransaction);
  }
}
