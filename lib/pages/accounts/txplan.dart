import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../appsettings.dart';
import '../../store.dart';
import '../utils.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';

class TxPlanPage extends StatefulWidget {
  final bool signOnly;
  final TransactionSummaryT plan;
  final String tab;
  TxPlanPage(this.plan, {required this.tab, this.signOnly = false});

  @override
  State<StatefulWidget> createState() => TxPlanState();
}

class TxPlanState extends State<TxPlanPage> with WithLoadingAnimation {
  late final s = S.of(context);

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final txplan =
        TxPlanWidget(plan, signOnly: widget.signOnly, onSend: sendOrSign);
    final canSign = warp.canSign(aa.coin, aa.id, plan);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.txPlan),
          actions: [
            IconButton(
              onPressed: () => exportRaw(context),
              icon: Icon(MdiIcons.snowflake),
            ),
            if (canSign && !txplan.invalidPrivacy)
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

  send(BuildContext context) async {
    await load(() async {
      final txBytes = await warp.sign(aa.coin, widget.plan, syncStatus.expirationHeight);
      GoRouter.of(context).go('/${widget.tab}/broadcast_tx',
          extra: txBytes);
    });
  }

  exportRaw(BuildContext context) {
    GoRouter.of(context).go('/account/export_raw_tx',
        extra: widget.plan);
  }

  Future<void> sendOrSign(BuildContext context) async =>
      widget.signOnly ? sign(context) : await send(context);

  sign(BuildContext context) async {
    try {
      await load(() async {
        final txBytes = await warp.sign(
            aa.coin, widget.plan, syncStatus.expirationHeight);
        final builder = fb.Builder();
        final root = txBytes.pack(builder);
        builder.finish(root);
        GoRouter.of(context).go('/more/signed', extra: builder.buffer);
      });
    } on String catch (error) {
      await showMessageBox(context, s.error, error, type: DialogType.error);
    }
  }
}

class TxPlanWidget extends StatelessWidget {
  final TransactionSummaryT report;
  final bool signOnly;
  final Future<void> Function(BuildContext context)? onSend;

  TxPlanWidget(this.report, {required this.signOnly, this.onSend});

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
    final rows = report.recipients!.where((e) => !e.change).map((e) {
      final receivers = warp.decodeAddress(aa.coin, e.address!);
      final style = styleOfAddress(receivers, t);
      final pool = poolOfAddress(receivers, s);
      return DataRow(cells: [
        DataCell(Text('${centerTrim(e.address!)}', style: style)),
        DataCell(Text('$pool', style: style)),
        DataCell(Text('${amountToString(e.amount, digits: MAX_PRECISION)}',
            style: style)),
      ]);
    }).toList();
    final feeStructure =
        """${report.numInputs![0]}:${report.numOutputs![0]} + ${report.numInputs![1]}:${report.numOutputs![1]} + ${report.numInputs![2]}:${report.numOutputs![2]}""";

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
              amountToString(report.transparentIns, digits: MAX_PRECISION),
              style: TextStyle(color: t.primaryColor))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.netSapling),
          trailing: Text(
              amountToString(report.saplingNet, digits: MAX_PRECISION),
              style: TextStyle(color: t.primaryColor))),
      if (supportsUA)
        ListTile(
            visualDensity: VisualDensity.compact,
            title: Text(s.netOrchard),
            trailing: Text(
                amountToString(report.orchardNet, digits: MAX_PRECISION),
                style: TextStyle(color: t.primaryColor))),
      ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(s.fee),
          subtitle: Text(feeStructure),
          trailing: Text(amountToString(report.fee, digits: MAX_PRECISION),
              style: TextStyle(color: t.primaryColor))),
      privacyToString(context, report.privacyLevel,
          canSend: !invalidPrivacy, onSend: onSend)!,
      Gap(16),
      if (invalidPrivacy)
        Text(s.privacyLevelTooLow, style: t.textTheme.bodyLarge),
    ]);
  }

  TextStyle styleOfAddress(UareceiversT ua, ThemeData t) {
    if (ua.orchard != null) return TextStyle(color: t.primaryColor);
    if (ua.sapling != null) return TextStyle();
    if (ua.transparent != null) return TextStyle(color: t.colorScheme.error);
    return TextStyle();
  }

  String poolOfAddress(UareceiversT ua, S s) {
    if (ua.orchard != null) return s.orchard;
    if (ua.sapling != null) return s.sapling;
    if (ua.transparent != null) return s.transparent;
    return s.na;
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
    {required bool canSend,
    Future<void> Function(BuildContext context)? onSend}) {
  final m = S
      .of(context)
      .privacy(getPrivacyLevel(context, privacyLevel).toUpperCase());
  final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green];
  return getColoredButton(context, m, colors[privacyLevel],
      canSend: canSend, onSend: onSend);
}

ElevatedButton getColoredButton(BuildContext context, String text, Color color,
    {required bool canSend,
    Future<void> Function(BuildContext context)? onSend}) {
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
