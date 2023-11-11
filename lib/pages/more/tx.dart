import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../../appsettings.dart';
import '../../tablelist.dart';
import '../avatar.dart';
import '../utils.dart';
import '../widgets.dart';

class TxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SortSetting(
      child: Observer(
        builder: (context) {
          aaSequence.seqno;
          aaSequence.settingsSeqno;
          return TableListPage(
            view: appSettings.txView,
            items: aa.txs.items,
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
  Text? headerText(BuildContext context) => null;

  @override
  void inverseSelection() {}

  @override
  Widget toListTile(BuildContext context, int index, Tx tx, {void Function(void Function())? setState}) {
    ZMessage? message;
    try {
      message = aa.messages.items.firstWhere((m) => m.txId == tx.id);
    } on StateError {
      message = null;
    }
    return TxItem(tx, message, index: index);
  }

  @override
  List<ColumnDefinition> columns(BuildContext context) {
    final s = S.of(context);
    return [
      ColumnDefinition(field: 'height', label: s.height, numeric: true),
      ColumnDefinition(field: 'timestamp', label: s.datetime),
      ColumnDefinition(field: 'value', label: s.amount),
      ColumnDefinition(field: 'fullTxId', label: s.txID),
      ColumnDefinition(field: 'address', label: s.address),
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
        onSelectChanged: (_) => gotoTx(context, index));
  }

  @override
  SortConfig2? sortBy(String field) {
    aa.txs.setSortOrder(field);
    return aa.txs.order;
  }
  
  @override
  Widget? header(BuildContext context) => null;
}

class TxItem extends StatelessWidget {
  final Tx tx;
  final int? index;
  final ZMessage? message;
  TxItem(this.tx, this.message, {this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contact = tx.contact?.isEmpty ?? true ? '?' : tx.contact!;
    final initial = contact[0];
    final color = amountColor(context, tx.value);

    final av = avatar(initial);
    final dateString = Text(humanizeDateTime(context, tx.timestamp));
    final value = Text('${tx.value.toDoubleStringAsPrecised()}',
        style: theme.textTheme.titleLarge!.apply(color: color));
    final trailing = Column(children: [dateString, value]);

    return GestureDetector(
        onTap: () { if (index != null) gotoTx(context, index!); },
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            av,
            Gap(15),
            Expanded(
              child: MessageContentWidget(
                  tx.contact ?? tx.address ?? '', message, tx.memo ?? ''),
            ),
            SizedBox(width: 120, child: trailing),
          ],
        ));
  }
}

class TransactionPage extends StatefulWidget {
  final int txIndex;

  TransactionPage(this.txIndex);

  @override
  State<StatefulWidget> createState() => TransactionState();
}

class TransactionState extends State<TransactionPage> {
  late int idx;

  @override
  void initState() {
    super.initState();
    idx = widget.txIndex;
  }

  Tx get tx => aa.txs.items[idx];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final n = aa.txs.items.length;
    return Scaffold(
      appBar: AppBar(title: Text(s.transactionDetails),
      actions: [
            IconButton(
                onPressed: idx > 0 ? prev : null,
                icon: Icon(Icons.chevron_left)),
            IconButton(
                onPressed: idx < n - 1 ? next : null,
                icon: Icon(Icons.chevron_right)),
            IconButton(
                onPressed: open, icon: Icon(Icons.open_in_browser)),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(16),
            Panel(s.txID, text: tx.fullTxId),
            Gap(8),
            Panel(s.height, text: tx.height.toString()),
            Gap(8),
            Panel(s.confs, text: tx.confirmations.toString()),
            Gap(8),
            Panel(s.timestamp, text: noteDateFormat.format(tx.timestamp)),
            Gap(8),
            Panel(s.amount, text: tx.value.toDoubleStringAsPrecised(length: MAX_PRECISION)),
            Gap(8),
            Panel(s.address, text: tx.address ?? ''),
            Gap(8),
            Panel(s.contactName, text: tx.contact ?? ''), // Add Contact button
            Gap(8),
            Panel(s.memo, text: tx.memo ?? ''),
          ],
        ),
      ),
    );
  }

  open() {
    openTxInExplorer(tx.fullTxId);
  }

  prev() {
    if (idx > 0) idx -= 1;
    setState(() {});
  }

  next() {
    final n = aa.txs.items.length;
    if (idx < n-1) idx += 1;
    setState(() {});
  }

  _addContact() async {
    // await addContact(context, ContactT(address: tx.address));
  }
}

void gotoTx(BuildContext context, int index) {
  GoRouter.of(context).push('/history/details?index=$index');
}
