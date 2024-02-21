import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../generated/intl/messages.dart';
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
  int addressMode = coins[aa.coin].defaultAddrMode;

  @override
  void initState() {
    super.initState();
    syncStatus2.update();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
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
                syncStatus2.changed;

                return Column(
                  children: [
                    SyncStatusWidget(),
                    Gap(8),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                          AddressCarousel(
                            onAddressModeChanged: (m) =>
                                setState(() => addressMode = m),
                          ),
                          Gap(8),
                          BalanceWidget(
                            addressMode,
                            key: key,
                          ),
                          Gap(16),
                          if (!aa.saved)
                            OutlinedButton(
                                onPressed: _backup,
                                child: Text(s.backupMissing))
                        ])),
                  ],
                );
              },
            ),
          ),
        ));
  }

  _send(bool custom) async {
    final protectSend = appSettings.protectSend;
    if (protectSend) {
      final authed = await authBarrier(context, dismissable: true);
      if (!authed) return;
    }
    final c = custom ? 1 : 0;
    GoRouter.of(context).push('/account/quick_send?custom=$c');
  }

  _backup() {
    GoRouter.of(context).push('/more/backup');
  }
}
