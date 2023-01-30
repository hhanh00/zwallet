import 'package:flutter/material.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';
import 'db.dart';
import 'generated/l10n.dart';
import 'main.dart';

class ScanTAddrPage extends StatefulWidget {
  @override
  ScanTAddrPageState createState() => ScanTAddrPageState();
}

class ScanTAddrPageState extends State<ScanTAddrPage> {
  List<AddressBalance>? addresses;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final _addresses = await WarpApi.scanTransparentAccounts(active.coin, active.id, settings.gapLimit);
      final dbr = DbReader(active.coin, active.id);
      setState(() {
        addresses = _addresses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _addresses = addresses;
    return Scaffold(
      appBar: AppBar(title: Text('Scan Transparent Addresses')),
      body: (_addresses == null) ?
          Center(child: Text('Scanning addresses'))
        : Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (BuildContext context, int index) {
                final a = _addresses[index];
                return ListTile(title: Text(a.address!), subtitle: Text(amountToString(a.balance, MAX_PRECISION)));
              })),
          ButtonBar(children: confirmButtons(this.context, onPressed))
        ]
      )
    );
  }

  onPressed() async {
    final s = S.of(context);
    final _accounts = addresses ?? [];
    for (var account in _accounts) {
      final name = s.subAccountIndexOf(account.index, active.account.name);
      WarpApi.newSubAccount(name, account.index, 1);
    }
    Navigator.of(context).pop();
  }
}

