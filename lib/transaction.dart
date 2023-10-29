import 'package:YWallet/contact.dart';
import 'package:YWallet/store2.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'appsettings.dart';
import 'main.dart';
import 'store.dart';
import 'generated/intl/messages.dart';

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

  Tx get tx => active.txs[txIndex];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final n = active.sortedTxs.length;
    return Scaffold(
        appBar: AppBar(title: Text(s.transactionDetails)),
        body: ListView(padding: EdgeInsets.all(16), children: [
          ListTile(
              title: Text(s.txID), subtitle: SelectableText('${tx.fullTxId}')),
          ListTile(
              title: Text(s.height),
              subtitle: SelectableText('${tx.height}')),
          ListTile(
              title: Text(s.confs),
              subtitle:
                  SelectableText('${tx.confirmations}')),
          ListTile(
              title: Text(s.timestamp),
              subtitle: Text('${tx.timestamp}')),
          ListTile(
              title: Text(s.amount),
              subtitle: SelectableText(decimalFormat(tx.value, 8))),
          ListTile(
              title: Text(s.address),
              subtitle: SelectableText('${tx.address}'),
              trailing: IconButton(
                  icon: Icon(Icons.contacts), onPressed: _addContact)),
          ListTile(
              title: Text(s.contactName),
              subtitle: SelectableText('${tx.contact ?? "N/A"}')),
          ListTile(
              title: Text(s.memo),
              subtitle: SelectableText('${tx.memo}')),
          ButtonBar(alignment: MainAxisAlignment.center, children: [
            IconButton(
                onPressed: txIndex > 0 ? _prev : null,
                icon: Icon(Icons.chevron_left)),
            ElevatedButton(
                onPressed: _onOpen, child: Text(s.openInExplorer)),
            IconButton(
                onPressed: txIndex < n - 1 ? _next : null,
                icon: Icon(Icons.chevron_right)),
          ]),
        ]));
  }

  _onOpen() {
    openTxInExplorer(tx.fullTxId);
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

void openTxInExplorer(String txId) {
    final settings = CoinSettingsExtension.load(active.coin);
    final url = settings.resolveBlockExplorer(active.coin);
    launchUrl(Uri.parse("$url/$txId"), mode: LaunchMode.inAppWebView);
}
