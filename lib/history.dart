import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'main.dart';
import 'generated/l10n.dart';

class HistoryWidget extends StatefulWidget {
  HistoryWidget();

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
              header: Text(S.of(context).tapTransactionForDetails, style: Theme.of(context).textTheme.bodyText2),
              actions: [
                IconButton(onPressed: _onExport, icon: Icon(Icons.save))
              ],
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
                DataColumn(
                  label: Text(S.of(context).datetime +
                      active.txSortConfig.getIndicator("time")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("time");
                    });
                  },
                ),
                DataColumn(
                  label: Text(S.of(context).amount +
                      active.txSortConfig.getIndicator("amount")),
                  numeric: true,
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("amount");
                    });
                  },
                ),
                DataColumn(
                  label: Text(S.of(context).txId +
                      active.txSortConfig.getIndicator("txid")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("txid");
                    });
                  },
                ),
                DataColumn(
                  label: Text(S.of(context).address +
                      active.txSortConfig.getIndicator("address")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("address");
                    });
                  },
                ),
                DataColumn(
                  label: Text(S.of(context).memo +
                      active.txSortConfig.getIndicator("memo")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("memo");
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

  _onExport() async {
    final csvData = active.sortedTxs.map((tx) => [
      tx.fullTxId, tx.height, tx.timestamp, tx.address, tx.contact ?? '',
      tx.value, tx.memo]).toList();
    await shareCsv(csvData, 'tx_history.csv', S.of(context).transactionHistory);
  }
}

class HistoryDataSource extends DataTableSource {
  BuildContext context;

  HistoryDataSource(this.context);

  @override
  DataRow getRow(int index) {
    final tx = active.sortedTxs[index];
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
          DataCell(Text(decimalFormat(tx.value, 8),
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
  int get rowCount => active.txs.length;

  @override
  int get selectedRowCount => 0;
}
