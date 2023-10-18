import 'dart:math';

import 'package:YWallet/accounts.dart';
import 'package:YWallet/generated/intl/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../appsettings.dart';
import '../../db.dart';
import '../../history.dart';
import '../../main.dart';
import '../../store.dart';
import '../../tablelist.dart';

class TxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SortSetting(
      child: Observer(
        builder: (context) {
          active.txs;
          return TableListPage(
            view: appSettings.txView,
            items: active.txs,
            metadata: TableListTxMetadata(),
          );
        },
      ),
    );
  }
}

class TableListTxMetadata extends TableListItemMetadata<Tx> {
  @override
  List<Widget>? actions(BuildContext context) => null;

  @override
  Text? header(BuildContext context) => null;

  @override
  void inverseSelection() {}

  @override
  Widget toListTile(BuildContext context, int index, Tx tx) {
    ZMessage? message;
    try {
      message = active.messages.firstWhere((m) => m.txId == tx.id);
    } on StateError {
      message = null;
    }
    return TxItem(tx, message, index);
  }

  @override
  List<ColumnDefinition> columns(BuildContext context) {
    final s = S.of(context);
    return [
      ColumnDefinition(field: 'height', label: s.height, numeric: true),
      ColumnDefinition(field: 'timestamp', label: s.datetime),
      ColumnDefinition(field: 'value', label: s.amount),
      ColumnDefinition(field: 'txid', label: s.txID),
      ColumnDefinition(label: s.address),
      ColumnDefinition(field: 'memo', label: s.memo),
    ];
  }

  @override
  DataRow toRow(BuildContext context, int index, Tx tx) {
    final t = Theme.of(context);
    final color = amountColor(context, tx.value);
    var style = t.textTheme.bodyMedium!.copyWith(color: color);
    style = weightFromAmount(style, tx.value);
    final a = tx.contact ?? centerTrim(tx.address ?? '');
    final m = tx.memo?.let((m) => m.substring(0, min(m.length, 32))) ?? '';

    return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text("${tx.height}")),
          DataCell(Text("${txDateFormat.format(tx.timestamp)}")),
          DataCell(Text(decimalFormat(tx.value, 8),
              style: style, textAlign: TextAlign.left)),
          DataCell(Text("${tx.txId}")),
          DataCell(Text("$a")),
          DataCell(Text("$m")),
        ],
        onSelectChanged: (_) {
          GoRouter.of(context).push('/tx/details?id=${tx.fullTxId}');
        });
  }

  @override
  SortConfig2? sortBy(String field) {
    active.setTxSortOrder(field);
    return active.txOrder;
  }
}
