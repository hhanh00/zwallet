import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../appsettings.dart';
import '../utils.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';

class TxPlanPage extends StatefulWidget {
  final bool signOnly;
  final String plan;
  final String tab;
  TxPlanPage(this.plan, {required this.tab, this.signOnly = false});

  @override
  State<StatefulWidget> createState() => _TxPlanState();
}

class _TxPlanState extends State<TxPlanPage> with WithLoadingAnimation {
  late final s = S.of(context);

  @override
  Widget build(BuildContext context) {
    final report = WarpApi.transactionReport(aa.coin, widget.plan);
    final txplan = TxPlanWidget(widget.plan, report,
        signOnly: widget.signOnly, onSend: sendOrSign);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.txPlan),
          actions: [
            IconButton(
              onPressed: () => exportRaw(context),
              icon: Icon(MdiIcons.snowflake),
            ),
            if (aa.canPay && !txplan.invalidPrivacy)
              IconButton(
                onPressed: () => sendOrSign(context),
                icon: widget.signOnly
                    ? FaIcon(FontAwesomeIcons.signature)
                    : Icon(Icons.send),
              )
          ],
        ),
        body: wrapWithLoading(SingleChildScrollView(child: txplan)));
  }

  send(BuildContext context) {
    GoRouter.of(context).go('/${widget.tab}/submit_tx', extra: widget.plan);
  }

  exportRaw(BuildContext context) {
    GoRouter.of(context).go('/account/export_raw_tx', extra: widget.plan);
  }

  Future<void> sendOrSign(BuildContext context) async =>
      widget.signOnly ? sign(context) : await send(context);

  sign(BuildContext context) async {
    try {
      await load(() async {
        final txBin = await WarpApi.signOnly(aa.coin, aa.id, widget.plan);
        GoRouter.of(context).go('/more/cold/signed', extra: txBin);
      });
    } on String catch (error) {
      await showMessageBox2(context, s.error, error);
    }
  }
}

class TxPlanWidget extends StatelessWidget {
  final String plan;
  final TxReport report;
  final bool signOnly;
  final Future<void> Function(BuildContext context)? onSend;

  TxPlanWidget(this.plan, this.report, {required this.signOnly, this.onSend});

  // factory TxPlanWidget.fromPlan(String plan, {bool signOnly = false}) {
  //   final report = WarpApi.transactionReport(aa.coin, plan);
  //   return TxPlanWidget(plan, report, signOnly: signOnly);
  // }

  get invalidPrivacy => report.privacyLevel < appSettings.minPrivacyLevel;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final c = coins[aa.coin];
    final supportsUA = c.supportsUA;
    final rows = report.outputs!.map((e) {
      final style = _styleOfAddress(e.address!, t);
      return DataRow(cells: [
        DataCell(Text('...${trailing(e.address!, 12)}', style: style)),
        DataCell(Text('${poolToString(s, e.pool)}', style: style)),
        DataCell(Text('${amountToString2(e.amount, digits: MAX_PRECISION)}',
            style: style)),
      ]);
    }).toList();

    return Column(children: [
      Row(children: [
        Expanded(
            child: DataTable(
                headingRowHeight: 32,
                columnSpacing: 32,
                columns: [
                  DataColumn(label: Text(s.address)),
                  DataColumn(label: Text(s.pool)),
                  DataColumn(label: Expanded(child: Text(s.amount))),
                ],
                rows: rows))
      ]),
      Divider(
        height: 16,
        thickness: 2,
        color: t.primaryColor,
      ),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.transparentInput),
          trailing: Text(
              amountToString2(report.transparent, digits: MAX_PRECISION),
              style: TextStyle(color: t.primaryColor))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.saplingInput),
          trailing:
              Text(amountToString2(report.sapling, digits: MAX_PRECISION))),
      if (supportsUA)
        ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(s.orchardInput),
            trailing:
                Text(amountToString2(report.orchard, digits: MAX_PRECISION))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.netSapling),
          trailing: Text(
              amountToString2(report.netSapling, digits: MAX_PRECISION),
              style: TextStyle(color: t.primaryColor))),
      if (supportsUA)
        ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(s.netOrchard),
            trailing: Text(
                amountToString2(report.netOrchard, digits: MAX_PRECISION),
                style: TextStyle(color: t.primaryColor))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.fee),
          trailing: Text(amountToString2(report.fee, digits: MAX_PRECISION),
              style: TextStyle(color: t.primaryColor))),
      privacyToString(context, report.privacyLevel,
        canSend: !invalidPrivacy,
        onSend: onSend)!,
      Gap(16),
      if (invalidPrivacy)
        Text(s.privacyLevelTooLow, style: t.textTheme.bodyLarge),
    ]);
  }

  TextStyle? _styleOfAddress(String address, ThemeData t) {
    final a = WarpApi.receiversOfAddress(aa.coin, address);
    return a == 1 ? TextStyle(color: t.primaryColor) : null;
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

Widget? privacyToString(BuildContext context, int privacyLevel,
    {required bool canSend, Future<void> Function(BuildContext context)? onSend}) {
  final m = S
      .of(context)
      .privacy(getPrivacyLevel(context, privacyLevel).toUpperCase());
  final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green];
  return getColoredButton(context, m, colors[privacyLevel],
    canSend: canSend, onSend: onSend);
}

ElevatedButton getColoredButton(BuildContext context, String text, Color color,
    {required bool canSend, Future<void> Function(BuildContext context)? onSend}) {
  var foregroundColor =
      color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  final doSend = () => onSend?.call(context);
  return ElevatedButton(
      onLongPress: doSend,
      onPressed: canSend ? doSend : null,
      child: Text(text),
      style: ElevatedButton.styleFrom(
          backgroundColor: color, foregroundColor: foregroundColor));
}
