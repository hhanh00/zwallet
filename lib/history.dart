import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'main.dart';
import 'store.dart';
import 'generated/l10n.dart';

class HistoryWidget extends StatefulWidget {
  final void Function(int index) tabTo;

  HistoryWidget(this.tabTo);

  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<HistoryWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        padding: EdgeInsets.all(4),
        scrollDirection: Axis.vertical,
        child: Observer(builder: (context) {
          return PaginatedDataTable(
              columns: [
                DataColumn(
                    label: settings.showConfirmations
                        ? Text(S.of(context).confs)
                        : Text(S.of(context).height),
                    onSort: (_, __) {
                      setState(() {
                        settings.toggleShowConfirmations();
                      });
                    }),
                DataColumn(label: Text(S.of(context).datetime)),
                DataColumn(
                    label:
                        Text(S.of(context).amount + _sortIndicator("amount")),
                    numeric: true,
                    onSort: (_, __) {
                      setState(() {
                        accountManager.sortTx("amount");
                      });
                    }),
                DataColumn(
                  label: Text(S.of(context).txId + _sortIndicator("txid")),
                  onSort: (_, __) {
                    setState(() {
                      accountManager.sortTx("txid");
                    });
                  },
                ),
                DataColumn(
                  label:
                      Text(S.of(context).address + _sortIndicator("address")),
                  onSort: (_, __) {
                    setState(() {
                      accountManager.sortTx("address");
                    });
                  },
                ),
                DataColumn(
                  label: Text(S.of(context).memo + _sortIndicator("memo")),
                  onSort: (_, __) {
                    setState(() {
                      accountManager.sortTx("memo");
                    });
                  },
                ),
              ],
              columnSpacing: 16,
              showCheckboxColumn: false,
              availableRowsPerPage: [5, 10, 25, 100],
              onRowsPerPageChanged: (int? value) {
                settings.setRowsPerPage(value ?? 25);
              },
              showFirstLastButtons: true,
              rowsPerPage: settings.rowsPerPage,
              source: HistoryDataSource(context));
        }));
  }

  String _sortIndicator(String field) {
    if (accountManager.txSortOrder.field != field) return '';
    if (accountManager.txSortOrder.order == SortOrder.Ascending)
      return ' \u2191';
    if (accountManager.txSortOrder.order == SortOrder.Descending)
      return ' \u2193';
    return '';
  }
}

class HistoryDataSource extends DataTableSource {
  BuildContext context;

  HistoryDataSource(this.context);

  @override
  DataRow getRow(int index) {
    final tx = accountManager.sortedTxs[index];
    final confsOrHeight = settings.showConfirmations
        ? syncStatus.latestHeight - tx.height + 1
        : tx.height;
    final color = amountColor(context, tx.value);
    var style = Theme.of(context).textTheme.bodyText2!.copyWith(color: color);
    style = fontWeight(style, tx.value);
    final a = tx.contact ?? addressLeftTrim(tx.address);
    final m = tx.memo.substring(0, min(tx.memo.length, 32));

    return DataRow(
        cells: [
          DataCell(Text("$confsOrHeight")),
          DataCell(Text("${tx.timestamp}")),
          DataCell(Text("${tx.value.toStringAsFixed(8)}",
              style: style, textAlign: TextAlign.left)),
          DataCell(Text("${tx.txid}")),
          DataCell(Text("$a")),
          DataCell(Text("$m")),
        ],
        onSelectChanged: (_) {
          Navigator.of(this.context).pushNamed('/tx', arguments: tx);
        });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => accountManager.txs.length;

  @override
  int get selectedRowCount => 0;
}
