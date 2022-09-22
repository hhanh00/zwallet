import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:velocity_x/velocity_x.dart';
import 'db.dart';
import 'main.dart';
import 'generated/l10n.dart';
import 'message_item.dart';
import 'store.dart';

class HistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      switch (settings.txView) {
        case ViewStyle.Table: return HistoryTable();
        case ViewStyle.List: return HistoryList();
        case ViewStyle.Auto: return OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) return HistoryList();
          else return HistoryTable();
        });
      }
    });
  }
}

class HistoryTable extends StatefulWidget {
  HistoryTable();

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<HistoryTable>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    super.build(context);
    return SingleChildScrollView(
        padding: EdgeInsets.all(4),
        scrollDirection: Axis.vertical,
        child: Observer(builder: (context) {
          final _1 = active.sortedTxs;
          return PaginatedDataTable(
              header: Text(S.of(context).tapTransactionForDetails, style: Theme.of(context).textTheme.bodyText2),
              actions: [
                IconButton(onPressed: _onExport, icon: Icon(Icons.save))
              ],
              columns: [
                DataColumn(
                    label: settings.showConfirmations
                        ? Text(s.confs)
                        : Text(s.height),
                    onSort: (_, __) {
                      setState(() {
                        settings.toggleShowConfirmations();
                      });
                    }),
                DataColumn(
                  label: Text(s.datetime +
                      active.txSortConfig.getIndicator("time")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("time");
                    });
                  },
                ),
                DataColumn(
                  label: Text(s.amount +
                      active.txSortConfig.getIndicator("amount")),
                  numeric: true,
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("amount");
                    });
                  },
                ),
                DataColumn(
                  label: Text('TXID' +
                      active.txSortConfig.getIndicator("txid")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("txid");
                    });
                  },
                ),
                DataColumn(
                  label: Text(s.address +
                      active.txSortConfig.getIndicator("address")),
                  onSort: (_, __) {
                    setState(() {
                      active.sortTx("address");
                    });
                  },
                ),
                DataColumn(
                  label: Text(s.memo +
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
    style = weightFromAmount(style, tx.value);
    final a = tx.contact ?? centerTrim(tx.address);
    final m = tx.memo.substring(0, min(tx.memo.length, 32));

    return DataRow(
        cells: [
          DataCell(Text("$confsOrHeight")),
          DataCell(Text("${txDateFormat.format(tx.timestamp)}")),
          DataCell(Text(decimalFormat(tx.value, 8),
              style: style, textAlign: TextAlign.left)),
          DataCell(Text("${tx.txid}")),
          DataCell(Text("$a")),
          DataCell(Text("$m")),
        ],
        onSelectChanged: (_) {
          Navigator.of(this.context).pushNamed('/tx', arguments: index);
        });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => active.txs.length;

  @override
  int get selectedRowCount => 0;
}

class HistoryList extends StatefulWidget {
  @override
  HistoryListState createState() => HistoryListState();
}

class HistoryListState extends State<HistoryList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final txs = active.sortedTxs;
      return ListView.builder(
          itemCount: txs.length,
          itemBuilder: (context, index) {
            final tx = txs[index];
            ZMessage? message;
            try {
              message = active.messages.firstWhere((m) => m.txId == tx.id);
            }
            on StateError {
              message = null;
            }
            return TxItem(tx, message, index);
          });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class TxItem extends StatelessWidget {
  final Tx tx;
  final int index;
  final ZMessage? message;
  TxItem(this.tx, this.message, this.index);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final contact = tx.contact.isEmptyOrNull ? '?' : tx.contact!;
    final initial = contact[0];
    final color = amountColor(context, tx.value);
    return Container(
      margin: EdgeInsets.only(top: 3.0, bottom: 3.0, right: 0.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () { _gotoTx(context); },
        child: Row(
          children: [
            Column(children: [
              CircleAvatar( child: Text(initial, style: theme.textTheme.headlineSmall!.apply(color: Colors.white)),
                backgroundColor: initialToColor(contact)),
              Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              Text('${tx.txid}', style: theme.textTheme.labelSmall),
            ]),
            Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
            Expanded(child: MessageContentWidget(tx.contact ?? tx.address, message, tx.memo)),
            SizedBox(
              width: 100,
              child: Column(children: [
                Text('${humanizeDateTime(tx.timestamp)}'),
                Text('${tx.value}', style: theme.textTheme.titleLarge!.copyWith(color: color)),
            ])),
          ]
      ))
    );
  }

  _gotoTx(BuildContext context) {
    Navigator.of(context).pushNamed('/tx', arguments: index);
  }
}

class MessageContentWidget extends StatelessWidget {
  final String address;
  final ZMessage? message;
  final String memo;

  MessageContentWidget(this.address, this.message, this.memo);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = message;
    if (m != null) {
      return Column(children: [
        Text('${trailing(address, 8)}', style: theme.textTheme.labelMedium),
        Text("${m.subject}", style: theme.textTheme.titleSmall),
        if (m.subject != m.body) Text("${m.body}", style: theme.textTheme.bodySmall),
      ]);
    }
    else {
      return Text(memo, style: theme.textTheme.bodySmall);
    }
  }
}
