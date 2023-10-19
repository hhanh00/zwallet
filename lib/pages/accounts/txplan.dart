import 'package:YWallet/main.dart';
import 'package:YWallet/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';

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
    final c = coins[active.coin];
    final supportsUA = c.supportsUA;
    final rows = report.outputs!
        .map((e) => DataRow(cells: [
              DataCell(Text('...${trailing(e.address!, 12)}')),
              DataCell(Text('${poolToString(s, e.pool)}')),
              DataCell(Text('${amountToString(e.amount, 3)}')),
            ]))
        .toList();
    final invalidPrivacy = report.privacyLevel < settings.minPrivacyLevel;

    return Column(children: [
      Row(children: [Expanded(child: DataTable(
          headingRowHeight: 32,
          columnSpacing: 32,
          columns: [
            DataColumn(label: Text(s.address)),
            DataColumn(label: Text(s.pool)),
            DataColumn(label: Expanded(child: Text(s.amount))),
          ],
          rows: rows))]),
      Divider(
        height: 16,
        thickness: 2,
        color: t.primaryColor,
      ),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.transparentInput),
          trailing: Text(amountToString(report.transparent, MAX_PRECISION))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.saplingInput),
          trailing: Text(amountToString(report.sapling, MAX_PRECISION))),
      if (supportsUA)
        ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(s.orchardInput),
            trailing: Text(amountToString(report.orchard, MAX_PRECISION))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.netSapling),
          trailing: Text(amountToString(report.netSapling, MAX_PRECISION))),
      if (supportsUA)
        ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(s.netOrchard),
            trailing: Text(amountToString(report.netOrchard, MAX_PRECISION))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.fee),
          trailing: Text(amountToString(report.fee, MAX_PRECISION))),
      privacyToString(context, report.privacyLevel)!,
      if (invalidPrivacy)
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(s.privacyLevelTooLow, style: t.textTheme.bodyLarge)),
    ]);
  }

  _onSend() async {
    final context = navigatorKey.currentContext!;
    final s = S.of(context);
    if (active.canPay) {
      if (signOnly)
        await _sign();
      else {
        Future(() async {
          active.setBanner(s.paymentInProgress);
          final player = AudioPlayer();
          try {
            final String txid;
            if (active.external) {
              txid = await WarpApi.ledgerSend(active.coin, plan);
            } else {
              txid =
                  await WarpApi.signAndBroadcast(active.coin, active.id, plan);
            }
            showSnackBar(s.txId(txid));
            if (settings.sound) await player.play(AssetSource("success.mp3"));
            active.setDraftRecipient(null);
            active.update();
          } on String catch (message) {
            showSnackBar(message, error: true);
            if (settings.sound) await player.play(AssetSource("fail.mp3"));
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
        await saveFile(plan, "tx.json", s.unsignedTransactionFile);
        showSnackBar(s.fileSaved);
      }
    }
  }

  _sign() async {
    final context = navigatorKey.currentContext!;
    final s = S.of(context);
    try {
      showSnackBar(s.signingPleaseWait);
      final res =
          await WarpApi.signOnly(active.coin, active.id, plan, (progress) {});
      active.setBanner("");
      active.setDraftRecipient(null);
      if (settings.qrOffline) {
        navigatorKey.currentState
            ?.pushReplacementNamed('/showRawTx', arguments: res);
      } else {
        await saveFile(res, 'tx.raw', s.rawTransaction);
      }
    } on String catch (error) {
      showSnackBar(error, error: true);
    }
  }
}

String poolToString(S s, int pool) {
  switch (pool) {
    case 0:
      return s.transparent;
    case 1:
      return s.sapling;
  }
  return s.orchard;
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
