import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_palette/flutter_palette.dart';

import 'store.dart';
import 'main.dart';
import 'generated/l10n.dart';

class BudgetChart extends StatefulWidget {
  @override
  BudgetState createState() => BudgetState();
}

class BudgetState extends State<BudgetChart> {
  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              BudgetBar(accountManager.spendings),
              BudgetTable(accountManager.spendings)
            ])));
  }
}

class BudgetBar extends StatelessWidget {
  final List<Spending> spendings;

  BudgetBar(this.spendings);

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette.adjacent(Theme.of(context).primaryColor,
        numberOfColors: max(spendings.length, 1));

    final sum = spendings.fold<double>(0, ((acc, s) => acc + s.amount));
    final stacks = spendings.asMap().entries.map((e) {
      final i = e.key;
      final color = palette[i];
      final weight = (spendings[i].amount / sum * 100.0).ceil();
      return Expanded(child: Container(color: color, height: 10), flex: weight);
    }).toList();

    return IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: stacks));
  }
}

class BudgetTable extends StatelessWidget {
  final List<Spending> spendings;

  BudgetTable(this.spendings);

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette.adjacent(Theme.of(context).primaryColor,
        numberOfColors: max(spendings.length, 1));
    final amountStyle = TextStyle(fontFeatures: [FontFeature.tabularFigures()]);
    final rows = spendings.asMap().entries.map((e) {
      final style = TextStyle(color: palette[e.key]);
      final address = e.value.address;
      final shortAddress = addressLeftTrim(address);
      final addressOrContact = e.value.contact ?? shortAddress;
      return DataRow(cells: [
        DataCell(
          GestureDetector(onTap: () async {
        await Clipboard.setData(ClipboardData(text: address));
        showSnackBar(S.of(context).addressCopiedToClipboard);
      }, child:
            Text(addressOrContact, style: style))),
        DataCell(Text(e.value.amount.toStringAsFixed(8), style: style)),
      ]);
    }).toList();
    return DataTable(
        columnSpacing: 8,
        dataRowHeight: 32,
        headingRowHeight: 40,
        columns: [
          DataColumn(label: Text('Address')),
          DataColumn(label: Text('Amount', style: amountStyle), numeric: true),
        ],
        rows: rows);
  }
}
