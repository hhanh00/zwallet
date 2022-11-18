import 'dart:convert';

import 'package:YWallet/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';

import 'generated/l10n.dart';

class TxPlanPage extends StatelessWidget {
  final String plan;
  final TxReport report;
  final bool signOnly;

  TxPlanPage(this.plan, this.report, this.signOnly);

  factory TxPlanPage.fromPlan(String plan, bool signOnly) {
    final reportStr = WarpApi.transactionReport(active.coin, plan);
    print(reportStr);
    final json = jsonDecode(reportStr);
    final report = TxReport.fromJson(json);
    return TxPlanPage(plan, report, signOnly);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = report.outputs
        .map((e) => DataRow(cells: [
              DataCell(Text('...${trailing(e.address, 12)}')),
              DataCell(Text('${poolToString(e.pool)}')),
              DataCell(Text('${amountToString(e.amount, 3)}')),
            ]))
        .toList();

    return Scaffold(
        appBar: AppBar(title: Text('Transaction Plan')),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(child: Column(
                children: [
                  Card(
                    child: DataTable(columnSpacing: 32, columns: [
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Pool')),
                      DataColumn(label: Expanded(child: Text('Amount'))),
                    ], rows: rows)),
                  Divider(height: 16, thickness: 2, color: theme.primaryColor,),
                  ListTile(title: Text('Transparent Input'), trailing: Text(amountToString(report.transparent, MAX_PRECISION))),
                  ListTile(title: Text('Sapling Input'), trailing: Text(
                      amountToString(report.sapling, MAX_PRECISION))),
                  ListTile(title: Text('Orchard Input'), trailing: Text(
                      amountToString(report.orchard, MAX_PRECISION))),
                  ListTile(title: Text('Net Sapling Change'), trailing: Text(
                      amountToString(report.net_sapling, MAX_PRECISION))),
                  ListTile(title: Text('Net Orchard Change'), trailing: Text(
                      amountToString(report.net_orchard, MAX_PRECISION))),
                  ListTile(title: Text('Fee'), trailing: Text(amountToString(report.fee, MAX_PRECISION))),
                  privacyToString(report.privacy_level, theme.textTheme.titleMedium!)!,
                  ButtonBar(children: confirmButtons(context, _onSend, okLabel: 'Send')),
                ]))));
  }

  _onSend() async {
    if (active.canPay) {
      if (signOnly)
        await _sign();
      else {
        Future(() async {
          active.setBanner(S.current.paymentInProgress);
          final player = AudioPlayer();
          try {
            final txid = await compute(_signAndBroadcast, SignBroadcastParams(active.coin, active.id, plan));
            showSnackBar(S.current.txId(txid));
            await player.play(AssetSource("success.mp3"));
            active.setDraftRecipient(null);
            await active.update();
          }
          on String catch (message) {
            showSnackBar(message);
            await player.play(AssetSource("fail.mp3"));
          }
          finally {
            active.setBanner("");
          }
        });
        navigatorKey.currentState?.pop();
      }
    }
    else {
      if (settings.qrOffline) {
        navigatorKey.currentState?.pushReplacementNamed('/qroffline', arguments: plan);
      }
      else {
        await saveFile(plan, "tx.json", S.current.unsignedTransactionFile);
        showSnackBar(S.current.fileSaved);
      }
    }
  }

  _sign() async {
    try {
      final res = await WarpApi.signOnly(
          active.coin, active.id, plan, (progress) {
        // TODO progressPort.sendPort.send(progress);
      });
      // TODO progressPort.sendPort.send(0);
      active.setBanner("");
      if (settings.qrOffline) {
        navigatorKey.currentState?.pushReplacementNamed(
            '/showRawTx', arguments: res);
      } else {
        await saveFile(res, 'tx.raw', S.current.rawTransaction);
      }
    }
    on String catch (error) {
      showSnackBar(error);
    }
  }
}

String _signAndBroadcast(SignBroadcastParams params) {
  final txid = WarpApi.signAndBroadcast(
      params.coin, params.id, params.plan);
  return txid;
}

class SignBroadcastParams {
  final int coin;
  final int id;
  final String plan;
  SignBroadcastParams(this.coin, this.id, this.plan);
}

String poolToString(int pool) {
  switch (pool) {
    case 0:
      return "Transp.";
    case 1:
      return "Sapling";
  }
  return "Orchard";
}

Widget? privacyToString(int privacyLevel, TextStyle baseStyle) {
  switch (privacyLevel) {
    case 0: return Text("PRIVACY: VERY LOW", style: baseStyle.copyWith(color: Colors.red));
    case 1: return Text("PRIVACY: LOW", style: baseStyle.copyWith(color: Colors.orange));
    case 2: return Text("PRIVACY: MEDIUM", style: baseStyle.copyWith(color: Colors.yellow));
    case 3: return Text("PRIVACY: HIGH", style: baseStyle.copyWith(color: Colors.green));
  }
}