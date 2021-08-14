import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
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
              title: Text('TXID'), subtitle: SelectableText('${widget.tx.fullTxId}')),
          ListTile(
              title: Text('Height'), subtitle: SelectableText('${widget.tx.height}')),
          ListTile(
              title: Text('Timestamp'),
              subtitle: Text('${widget.tx.timestamp}')),
          ListTile(title: Text('Amount'), subtitle: SelectableText('${widget.tx.value.toStringAsFixed(8)}')),
          ListTile(
              title: Text('Address'), subtitle: SelectableText('${widget.tx.address ?? "N/A"}')),
          ListTile(title: Text('Memo'), subtitle: SelectableText('${widget.tx.memo ?? "N/A"}')),
          ElevatedButton(onPressed: _onOpen, child: Text('Open in Explorer'))
        ]));
  }

  _onOpen() {
    launch("${coin.explorerUrl}${widget.tx.fullTxId}");
  }
}
