import 'dart:convert';

import 'package:YWallet/main.dart';
import 'package:flutter/material.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';

class TxPlanPage extends StatelessWidget {
  final String plan;
  final TxReport report;

  TxPlanPage(this.plan, this.report);

  factory TxPlanPage.fromPlan(String plan) {
    // final reportStr =
    //     r'{"outputs":[{"id":0,"address":"zregtestsapling1qzy9wafd2axnenul6t6wav76dys6s8uatsq778mpmdvmx4k9myqxsd9m73aqdgc7gwnv53wga4j","amount":500000000,"pool":1}],"transparent":0,"sapling":500010000,"orchard":0,"net_sapling":-10000,"net_orchard":0,"fee":10000,"privacy_level":3}';
    final reportStr = WarpApi.transactionReport(active.coin, plan);
    print(reportStr);
    final json = jsonDecode(reportStr);
    final report = TxReport.fromJson(json);
    return TxPlanPage(plan, report);
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
            child: SingleChildScrollView(child: Wrap(
                direction: Axis.vertical,
                spacing: 20,
                runSpacing: 20,
                children: [
                  DataTable(columns: [
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Pool')),
                    DataColumn(label: Expanded(child: Text('Amount'))),
                  ], rows: rows),
                  Text(
                      'Transparent Input: ${amountToString(report.transparent, MAX_PRECISION)}'),
                  Text(
                      'Sapling Input: ${amountToString(report.sapling, MAX_PRECISION)}'),
                  Text(
                      'Orchard Input: ${amountToString(report.orchard, MAX_PRECISION)}'),
                  Text(
                      'Net Sapling Change: ${amountToString(report.net_sapling, MAX_PRECISION)}'),
                  Text(
                      'Net Orchard Change: ${amountToString(report.net_orchard, MAX_PRECISION)}'),
                  Text('Fee: ${amountToString(report.fee, MAX_PRECISION)}'),
                  privacyToString(report.privacy_level, theme.textTheme.titleSmall!)!,
                  ButtonBar(children: confirmButtons(context, _onSend, okLabel: 'Send')),
                ]))));
  }

  _onSend() {
    final txid = WarpApi.signAndBroadcast(active.coin, active.id, this.plan);
    showSnackBar("TxID: $txid");
    navigatorKey.currentState?.pop();
  }
}

String poolToString(int pool) {
  switch (pool) {
    case 0:
      return "Transparent";
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