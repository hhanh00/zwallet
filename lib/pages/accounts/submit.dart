import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';
import '../widgets.dart';

class SubmitTxPage extends StatefulWidget {
  final TransactionBytesT data;
  SubmitTxPage(this.data);
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
        String json = jsonDecode(await warp.broadcast(aa.coin, widget.data));
        txId = json;
        final redirect = widget.data.redirect;
        redirect?.let((r) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).pushReplacement(redirect);
          });
        });
      } on FormatException catch (e) {
        final s = GetIt.I.get<S>();
        await AwesomeDialog(
          context: context,
          title: s.error,
          desc: e.source,
          dialogType: DialogType.error,
          onDismissCallback: (_) => GoRouter.of(context).pop()
        )..show();
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

class AnimatedQRExportPage extends StatefulWidget {
  final Uint8List data;
  final String title;
  final String filename;

  AnimatedQRExportPage(this.data,
      {super.key, required this.title, required this.filename});

  @override
  State<StatefulWidget> createState() => AnimatedQRExportState();
}

class AnimatedQRExportState extends State<AnimatedQRExportPage> {
  late final List<PacketT> packets;

  @override
  void initState() {
    super.initState();
    packets = warp.splitData(aa.coin, widget.data, 1);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          actions: [IconButton(onPressed: export, icon: Icon(Icons.save))]),
      body: packets.isNotEmpty
          ? AnimatedQR(widget.title, s.scanQrCode, packets)
          : SizedBox.shrink(),
    );
  }

  export() async {
    await saveFileBinary(widget.data, widget.filename, widget.title);
  }
}
