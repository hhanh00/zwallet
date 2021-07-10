import 'package:flutter/material.dart';

import 'store.dart';

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
        appBar: AppBar(title: Text('Transaction Details')),
        body: ListView(padding: EdgeInsets.all(16), children: [
          ListTile(
              title: Text('TXID'), subtitle: Text('${widget.tx.fullTxId}')),
          ListTile(
              title: Text('Height'), subtitle: Text('${widget.tx.height}')),
          ListTile(
              title: Text('Timestamp'),
              subtitle: Text('${widget.tx.timestamp}')),
          ListTile(title: Text('Amount'), subtitle: Text('${widget.tx.value}')),
          ListTile(
              title: Text('Address'), subtitle: Text('${widget.tx.address}')),
          ListTile(title: Text('Memo'), subtitle: Text('${widget.tx.memo}')),
        ]));
  }
}
