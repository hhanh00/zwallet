import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'store.dart';
import 'generated/l10n.dart';

class TransactionPage extends StatefulWidget {
  final Tx tx;

  TransactionPage(this.tx);

  @override
  State<StatefulWidget> createState() => TransactionState();
}

class TransactionState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(title: Text(S.of(context).transactionDetails)),
        body: ListView(padding: EdgeInsets.all(16), children: [
          ListTile(
              title: Text(S.of(context).txId), subtitle: SelectableText('${widget.tx.fullTxId}')),
          ListTile(
              title: Text(S.of(context).height), subtitle: SelectableText('${widget.tx.height}')),
          ListTile(
              title: Text(S.of(context).timestamp),
              subtitle: Text('${widget.tx.timestamp}')),
          ListTile(title: Text(S.of(context).amount), subtitle: SelectableText('${widget.tx.value.toStringAsFixed(8)}')),
          ListTile(
              title: Text(S.of(context).address), subtitle: SelectableText('${widget.tx.address ?? S.of(context).na}')),
          ListTile(title: Text(S.of(context).memo), subtitle: SelectableText('${widget.tx.memo ?? S.of(context).na}')),
          ElevatedButton(onPressed: _onOpen, child: Text(S.of(context).openInExplorer))
        ]));
  }

  _onOpen() {
    launch("${coin.explorerUrl}${widget.tx.fullTxId}");
  }
}
