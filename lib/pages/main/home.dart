import 'package:YWallet/store2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../accounts.dart';
import 'balance.dart';
import 'sync_status.dart';
import 'qr_address.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final key = GlobalKey<BalanceState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            FloatingActionButton(onPressed: _send, child: Icon(Icons.send)),
        body: SingleChildScrollView(
          child: Center(
            child: Observer(
              builder: (context) {
                aaSequence.seqno;
                aa.poolBalances;
                syncStatus2.syncedHeight;
                syncStatus2.syncing;
                print("REBUILD ${aa.id}");

                return Column(
                  children: [
                    SyncStatusWidget(),
                    Padding(padding: EdgeInsets.all(8)),
                    QRAddressWidget(onMode: _onMode),
                    BalanceWidget(key: key),
                  ],
                );
              },
            ),
          ),
        ));
  }

  _onMode(int mode) {
    key.currentState!.setMode(mode);
  }

  _send() {
    GoRouter.of(context).push('/account/send');
  }
}
