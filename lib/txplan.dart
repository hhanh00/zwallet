import 'dart:convert';

import 'package:YWallet/main.dart';
import 'package:YWallet/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'generated/l10n.dart';

class TxPlanPage extends StatelessWidget {
  final String plan;
  final TxReport report;
  final bool signOnly;

  TxPlanPage(this.plan, this.report, this.signOnly);

  factory TxPlanPage.fromPlan(String plan, bool signOnly) {
    final report = WarpApi.transactionReport(active.coin, plan);
    return TxPlanPage(plan, report, signOnly);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final supportsUA = active.coinDef.supportsUA;
    final theme = Theme.of(context);
    final rows = report.outputs!
        .map((e) => DataRow(cells: [
              DataCell(Text('...${trailing(e.address!, 12)}')),
              DataCell(Text('${poolToString(e.pool)}')),
              DataCell(Text('${amountToString(e.amount, 3)}')),
            ]))
        .toList();
    final invalidPrivacy = report.privacyLevel < settings.minPrivacyLevel;

    return Scaffold(
        appBar: AppBar(title: Text('Transaction Plan')),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
                child: Column(children: [
              Card(
                  child: DataTable(
                      columnSpacing: 32,
                      columns: [
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Pool')),
                        DataColumn(label: Expanded(child: Text('Amount'))),
                      ],
                      rows: rows)),
              Divider(
                height: 16,
                thickness: 2,
                color: theme.primaryColor,
              ),
              ListTile(
                  title: Text('Transparent Input'),
                  trailing:
                      Text(amountToString(report.transparent, MAX_PRECISION))),
              ListTile(
                  title: Text('Sapling Input'),
                  trailing:
                      Text(amountToString(report.sapling, MAX_PRECISION))),
              if (supportsUA)
                ListTile(
                    title: Text('Orchard Input'),
                    trailing:
                        Text(amountToString(report.orchard, MAX_PRECISION))),
              ListTile(
                  title: Text('Net Sapling Change'),
                  trailing:
                      Text(amountToString(report.netSapling, MAX_PRECISION))),
              if (supportsUA)
                ListTile(
                    title: Text('Net Orchard Change'),
                    trailing:
                        Text(amountToString(report.netOrchard, MAX_PRECISION))),
              ListTile(
                  title: Text('Fee'),
                  trailing: Text(amountToString(report.fee, MAX_PRECISION))),
              privacyToString(context, report.privacyLevel)!,
              if (invalidPrivacy)
                Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(s.privacyLevelTooLow,
                        style: t.textTheme.bodyLarge)),
              ButtonBar(
                children: <ElevatedButton>[
                  ElevatedButton.icon(
                      icon: Icon(Icons.cancel),
                      label: Text(s.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  ElevatedButton.icon(
                    icon: Icon(Icons.done),
                    label: Text(s.send),
                    onPressed: invalidPrivacy ? null : _onSend,
                    onLongPress: _onSend,
                  )
                ],
              )
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
            final String txid;
            if (active.external) {
              txid = await WarpApi.ledgerSend(active.coin, plan);
            } else {
              txid =
                  await WarpApi.signAndBroadcast(active.coin, active.id, plan);
            }
            showSnackBar(S.current.txId(txid));
            if (settings.sound)
              await player.play(AssetSource("success.mp3"));
            active.setDraftRecipient(null);
            active.update();
          } on String catch (message) {
            showSnackBar(message, error: true);
            if (settings.sound)
              await player.play(AssetSource("fail.mp3"));
          } finally {
            active.setBanner("");
          }
        });
        navigatorKey.currentState?.pop();
      }
    } else {
      if (settings.qrOffline) {
        navigatorKey.currentState
            ?.pushReplacementNamed('/qroffline', arguments: plan);
      } else {
        await saveFile(plan, "tx.json", S.current.unsignedTransactionFile);
        showSnackBar(S.current.fileSaved);
      }
    }
  }

  _sign() async {
    try {
      showSnackBar(S.current.signingPleaseWait);
      final res =
          await WarpApi.signOnly(active.coin, active.id, plan, (progress) {
        // TODO progressPort.sendPort.send(progress);
        // Orchard builder does not support progress reporting yet
      });
      // TODO progressPort.sendPort.send(0);
      active.setBanner("");
      active.setDraftRecipient(null);
      if (settings.qrOffline) {
        navigatorKey.currentState
            ?.pushReplacementNamed('/showRawTx', arguments: res);
      } else {
        await saveFile(res, 'tx.raw', S.current.rawTransaction);
      }
    } on String catch (error) {
      showSnackBar(error, error: true);
    }
  }
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

Widget? privacyToString(BuildContext context, int privacyLevel) {
  final m = S
      .of(context)
      .privacy(getPrivacyLevel(context, privacyLevel).toUpperCase());
  switch (privacyLevel) {
    case 0:
      return getColoredButton(m, Colors.red);
    case 1:
      return getColoredButton(m, Colors.orange);
    case 2:
      return getColoredButton(m, Colors.yellow);
    case 3:
      return getColoredButton(m, Colors.green);
  }
  return null;
}

ElevatedButton getColoredButton(String text, Color color) {
  var foregroundColor =
      color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  return ElevatedButton(
      onPressed: null,
      child: Text(text),
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: color,
          disabledForegroundColor: foregroundColor));
}
