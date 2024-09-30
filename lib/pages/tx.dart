import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:hex/hex.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../accounts.dart';
import '../generated/intl/messages.dart';
import '../appsettings.dart';
import '../store.dart';
import '../tablelist.dart';
import 'avatar.dart';
import 'utils.dart';
import 'widgets.dart';

class TxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TxPageState();
}

class TxPageState extends State<TxPage> {
  @override
  Widget build(BuildContext context) {
    return SortSetting(
      child: Observer(
        builder: (context) {
          aaSequence.seqno;
          aaSequence.settingsSeqno;
          syncStatus.changed;
          return TableListPage(
            listKey: PageStorageKey('txs'),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
  Widget toListTile(BuildContext context, int index, Tx tx,
      {void Function(void Function())? setState}) {
    ZMessage? message;
    message = aa.messages.items.firstWhereOrNull((m) => m.txId == tx.id);
    return TxItem(tx, message, index: index);
  }

  @override
  List<ColumnDefinition> columns(BuildContext context) {
    final s = S.of(context);
    return [
      ColumnDefinition(field: 'height', label: s.height, numeric: true),
      ColumnDefinition(field: 'confirmations', label: s.confs, numeric: true),
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
    final m = tx.memo.substring(0, min(tx.memo.length, 32));

    return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text("${tx.height}")),
          DataCell(Text("${tx.confirmations}")),
          DataCell(Text("${txDateFormat.format(tx.timestamp)}")),
          DataCell(Text(amountToString(tx.value),
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
    final value = Text('${amountToString(tx.value)}',
        style: theme.textTheme.titleLarge!.apply(color: color));
    final trailing = Column(children: [dateString, value]);

    return GestureDetector(
        onTap: () {
          if (index != null) gotoTx(context, index!);
        },
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            av,
            Gap(15),
            Expanded(
              child:
                  MessageContentWidget(tx.contact ?? tx.address ?? '', message),
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
  late final s = S.of(context);
  late int idx;
  late final TransactionInfoExtendedT details;
  List<Widget>? tins;
  List<Widget>? touts;
  List<Widget>? sins;
  List<Widget>? souts;

  @override
  void initState() {
    super.initState();
    idx = widget.txIndex;
    details = warp.getTransactionDetails(aa.coin, tx.fullTxId);
    logger.i(details);
    tins = details.tins?.map((tin) {
      return ListTile(
        leading: Icon(Icons.arrow_left),
        title: Text(tin.address!),
        // subtitle: Text('$txid:${tin.vout}'),
        trailing: Text(amountToString(tin.value)),
      );
    }).toList();
    touts = details.touts?.map((tout) {
      return ListTile(
        leading: Icon(Icons.arrow_right),
        title: Text(tout.address!),
        trailing: Text(amountToString(tout.value)),
      );
    }).toList();
    List<InputShieldedT> soins = [];
    soins.addAll(details.sins ?? []);
    soins.addAll(details.oins ?? []);
    sins = soins.map((sin) {
      sin.address;
      sin.value;
      return ListTile(
        leading: Icon(Icons.arrow_left),
        title: Text(sin.address ?? ''),
        trailing: Text(sin.address != null ? amountToString(sin.value) : '?'),
      );
    }).toList();

    List<OutputShieldedT> soouts = [];
    soouts.addAll(details.souts ?? []);
    soouts.addAll(details.oouts ?? []);
    souts = soouts.map((sout) {
      return ListTile(
        leading: Icon(Icons.arrow_right),
        title: Text(sout.address ?? ''),
        subtitle: Text(sout.memo ?? ''),
        trailing: Text(sout.address != null ? amountToString(sout.value) : '?'),
      );
    }).toList();
  }

  Tx get tx => aa.txs.items[idx];

  @override
  Widget build(BuildContext context) {
    final n = aa.txs.items.length;
    return Scaffold(
        appBar: AppBar(title: Text(s.transactionDetails), actions: [
          IconButton(
              onPressed: idx > 0 ? prev : null, icon: Icon(Icons.chevron_left)),
          IconButton(
              onPressed: idx < n - 1 ? next : null,
              icon: Icon(Icons.chevron_right)),
          IconButton(onPressed: open, icon: Icon(Icons.open_in_browser)),
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Gap(16),
                Panel(s.txID, text: reversedHex(tx.fullTxId)),
                Gap(8),
                Panel(s.height, text: tx.height.toString()),
                Gap(8),
                Panel(s.confs, text: tx.confirmations.toString()),
                Gap(8),
                Panel(s.timestamp, text: noteDateFormat.format(tx.timestamp)),
                Gap(8),
                Panel(s.amount, text: amountToString(tx.value)),
                Gap(8),
                Panel(s.address, text: tx.address ?? ''),
                Gap(8),
                Panel(s.contactName,
                    text: tx.contact ?? ''), // Add Contact button
                Gap(8),
                ExpansionTile(
                  title: Text(s.transparent),
                  children: [
                    ...?tins,
                    ...?touts,
                  ],
                ),
                ExpansionTile(
                  title: Text(s.shielded),
                  children: [
                    ...?sins,
                    ...?souts,
                  ],
                )
              ],
            ),
          ),
        ));
  }

  open() {
    openTxInExplorer(reversedHex(tx.fullTxId));
  }

  prev() {
    if (idx > 0) idx -= 1;
    setState(() {});
  }

  next() {
    final n = aa.txs.items.length;
    if (idx < n - 1) idx += 1;
    setState(() {});
  }

  _addContact() async {
    // await addContact(context, ContactT(address: tx.address));
  }
}

void gotoTx(BuildContext context, int index) {
  GoRouter.of(context).push('/history/details?index=$index');
}
