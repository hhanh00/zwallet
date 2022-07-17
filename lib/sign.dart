import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';

import 'generated/l10n.dart';
import 'main.dart';
import 'store.dart';

class Sign extends StatelessWidget {
  final String txStr;
  final UnsignedTxSummary txSummary;

  Sign.init(String txStr): this(txStr, parse(txStr));
  Sign(this.txStr, this.txSummary);

  static UnsignedTxSummary parse(String txStr) {
    final txSummaryStr = WarpApi.getTxSummary(txStr);
    final txSummaryJson = jsonDecode(txSummaryStr);
    final txSummary = UnsignedTxSummary.fromJson(txSummaryJson);
    return txSummary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(S.of(context).checkTransaction)),
        body: Padding(padding: EdgeInsets.all(16), child:
        Column(children: [
          Expanded(child: ListView.builder(
          itemCount: txSummary.recipients.length,
          itemBuilder: (context, index) {
            final r = txSummary.recipients[index];
            return ListTile(title: Text(r.address),
              subtitle: Text(amountToString(r.amount)));
          })),
          ButtonBar(children: confirmButtons(context, () { _sign(context); },
            okLabel: S.of(context).sign))
        ])));
  }

  _sign(BuildContext context) async {
    final s = S.of(context);
    final rawTransactionLabel = s.rawTransaction;
    final paymentInProgressLabel = s.paymentInProgress;
    Navigator.of(context).pop();

    if (txStr != null) {
      active.setBanner(paymentInProgressLabel);
      final res = await WarpApi.signOnly(
          active.coin, active.id, txStr, (progress) {
        progressPort.sendPort.send(progress);
      });
      progressPort.sendPort.send(0);
      active.setBanner("");
      final isError = WarpApi.getError();
      if (isError) {
        showSnackBar(res);
      }
      else {
        if (settings.qrOffline) {
          navigatorKey.currentState?.pushReplacementNamed(
              '/showRawTx', arguments: res);
        } else {
          await saveFile(res, 'tx.raw', rawTransactionLabel);
        }
      }
    }
  }
}
