import 'package:flutter/material.dart';
import 'package:warp_api/warp_api.dart';
import 'db.dart';
import 'generated/l10n.dart';
import 'main.dart';

class ScanTAddrPage extends StatefulWidget {
  @override
  ScanTAddrPageState createState() => ScanTAddrPageState();
}

class ScanTAddrPageState extends State<ScanTAddrPage> {
  List<TAccount>? tAccounts = null;

  @override
  void initState() {
    Future(() async {
      await WarpApi.scanTransparentAccounts(active.coin, active.id, settings.gapLimit);
      final dbr = DbReader(active.coin, active.id);
      final _accounts = await dbr.getTAccounts();
      setState(() {
        tAccounts = _accounts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _accounts = tAccounts;
    return Scaffold(
      appBar: AppBar(title: Text('Scan Transparent Addresses')),
      body: (_accounts == null) ?
          Center(child: Text('Scanning addresses'))
        : Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (BuildContext context, int index) {
                final a = _accounts[index];
                return ListTile(title: Text(a.address), subtitle: Text(amountToString(a.balance)));
              })),
          ButtonBar(children: confirmButtons(this.context, onPressed))
        ]
      )
    );
  }

  onPressed() async {
    final s = S.of(context);
    final _accounts = tAccounts ?? [];
    for (var account in _accounts) {
      final name = s.subAccountIndexOf(account.aindex, active.account.name);
      WarpApi.newSubAccount(name, account.aindex, 1);
    }
    await accounts.refresh();
    await accounts.updateTBalance();
    Navigator.of(context).pop();
  }
}

