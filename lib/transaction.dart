import 'package:YWallet/contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'settings.dart';
import 'store.dart';
import 'generated/l10n.dart';

class TransactionPage extends StatefulWidget {
  final int txIndex;

  TransactionPage(this.txIndex);

  @override
  State<StatefulWidget> createState() => TransactionState();
}

class TransactionState extends State<TransactionPage> {
  late int txIndex;

  @override
  void initState() {
    super.initState();
    txIndex = widget.txIndex;
  }

  Tx get tx => active.sortedTxs[txIndex];

  @override
  Widget build(BuildContext context) {
    final n = active.sortedTxs.length;
    return Scaffold(
        appBar: AppBar(title: Text(S.of(context).transactionDetails)),
        body: ListView(padding: EdgeInsets.all(16), children: [
          ListTile(
              title: Text('TXID'), subtitle: SelectableText('${tx.fullTxId}')),
          ListTile(
              title: Text(S.of(context).height),
              subtitle: SelectableText('${tx.height}')),
          ListTile(
              title: Text(S.of(context).confs),
              subtitle:
                  SelectableText('${syncStatus.latestHeight - tx.height + 1}')),
          ListTile(
              title: Text(S.of(context).timestamp),
              subtitle: Text('${tx.timestamp}')),
          ListTile(
              title: Text(S.of(context).amount),
              subtitle: SelectableText(decimalFormat(tx.value, 8))),
          if (active.isPrivate)
            ListTile(
                title: Text(S.of(context).address),
                subtitle: SelectableText('${tx.address}'),
                trailing: IconButton(
                    icon: Icon(Icons.contacts), onPressed: _addContact)),
          if (active.isPrivate)
            ListTile(
                title: Text(S.of(context).contactName),
                subtitle: SelectableText('${tx.contact ?? "N/A"}')),
          if (active.isPrivate)
            ListTile(
                title: Text(S.of(context).memo),
                subtitle: SelectableText('${tx.memo}')),
          ButtonBar(alignment: MainAxisAlignment.center, children: [
            IconButton(
                onPressed: txIndex > 0 ? _prev : null,
                icon: Icon(Icons.chevron_left)),
            ElevatedButton(
                onPressed: _onOpen, child: Text(S.of(context).openInExplorer)),
            IconButton(
                onPressed: txIndex < n - 1 ? _next : null,
                icon: Icon(Icons.chevron_right)),
          ]),
        ]));
  }

  _onOpen() {
    final url = WarpApi.getProperty(active.coin, EXPLORER_KEY);
    launchUrl(Uri.parse("$url/${tx.fullTxId}"));
  }

  _prev() {
    setState(() {
      txIndex -= 1;
    });
  }

  _next() {
    setState(() {
      txIndex += 1;
    });
  }

  _addContact() async {
    await addContact(context, ContactT(address: tx.address));
  }
}
