import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';

class SubmitTxPage extends StatefulWidget {
  final String txPlan;
  SubmitTxPage(this.txPlan);
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
        print('61 ${aa.coin}');
        final txIdJs =
            await WarpApi.signAndBroadcast(aa.coin, aa.id, widget.txPlan);
        txId = jsonDecode(txIdJs);
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
                    SizedBox(height: 16),
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

class Jumbotron extends StatelessWidget {
  final Severity severity;
  final String? title;
  final String message;
  Jumbotron(this.message, {this.title, this.severity = Severity.Info});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final Color color;
    switch (severity) {
      case Severity.Error:
        color = Colors.red;
        break;
      case Severity.Warning:
        color = Colors.orange;
        break;
      default:
        color = t.colorScheme.primary;
        break;
    }
    return Stack(
      children: [
        Align(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsetsDirectional.all(15),
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 4),
                borderRadius: BorderRadius.all(Radius.circular(32))),
            child: SelectableText(message,
                style: t.textTheme.headlineMedium
                    ?.apply(color: t.appBarTheme.foregroundColor)),
          ),
        ),
        if (title != null)
          Align(
            alignment: Alignment.topCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: color, width: 4), color: color),
              child: Padding(padding: EdgeInsets.all(8), child: Text(title!)),
            ),
          )
      ],
    );
  }
}

enum Severity {
  Info,
  Warning,
  Error,
}
