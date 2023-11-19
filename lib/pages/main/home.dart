import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../appsettings.dart';
import '../../store2.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../utils.dart';
import 'balance.dart';
import 'sync_status.dart';
import 'qr_address.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final key = ValueKey(aaSequence.seqno);
      return HomePageInner(key: key);
    });
  }
}

class HomePageInner extends StatefulWidget {
  HomePageInner({super.key});
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePageInner> {
  final key = GlobalKey<BalanceState>();
  late int addressMode;

  @override
  void initState() {
    super.initState();
    addressMode = coins[aa.coin].defaultAddrMode;
    syncStatus2.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GestureDetector(
            onLongPress: () => _send(true),
            child: FloatingActionButton(
              onPressed: () => _send(false),
              child: Icon(Icons.send),
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Observer(
              builder: (context) {
                aaSequence.seqno;
                aa.poolBalances;
                syncStatus2.syncedHeight;
                syncStatus2.syncing;

                return Column(
                  children: [
                    SyncStatusWidget(),
                    Gap(8),
                    QRAddressWidget(
                        uaType: coinSettings.uaType, onMode: _onMode),
                    Gap(8),
                    BalanceWidget(addressMode, key: key),
                  ],
                );
              },
            ),
          ),
        ));
  }

  _onMode(int mode) {
    addressMode = mode;
    setState(() {});
  }

  _send(bool quick) async {
    final protectSend = appSettings.protectSend;
    if (protectSend) {
      final authed = await authBarrier(context, dismissable: true);
      if (!authed) return;
    }
    if (quick)
      GoRouter.of(context).push('/account/quick_send');
    else
      GoRouter.of(context).push('/account/send');
  }
}
