import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/warp_api.dart';

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
  final int availableMode = WarpApi.getAvailableAddrs(aa.coin, aa.id);
  late int addressMode = coins[aa.coin].defaultAddrMode;

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
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: [
                    QRAddressWidget(
                      addressMode,
                      uaType: coinSettings.uaType,
                      onMode: _nextAddressMode,
                    ),
                    Gap(8),
                    BalanceWidget(
                      addressMode,
                      key: key,
                      onMode: _nextAddressMode,
                    ),
                    Gap(16),
                    if (!aa.saved)
                      OutlinedButton(onPressed: _backup, child: Text(s.backupMissing))
                  ])),
                ],);
              },
            ),
          ),
        ));
  }

  _send(bool custom) async {
    custom ^= appSettings.customSend;
    final protectSend = appSettings.protectSend;
    if (protectSend) {
      final authed = await authBarrier(context, dismissable: true);
      if (!authed) return;
    }
    final c = custom ? 1 : 0;
    GoRouter.of(context).push('/account/quick_send?custom=$c');
  }

  // Addr Modes
  // 0: As chosen in settings
  // 1: T
  // 2: S
  // 3: O
  // 4: Diversified
  _nextAddressMode() {
    setState(() => addressMode = nextAddressMode(addressMode, availableMode));
  }

  _backup() {
    GoRouter.of(context).push('/more/backup');
  }
}

int nextAddressMode(int addressMode, int availableMode) {
  final c = coins[aa.coin];
  while (true) {
    addressMode = (addressMode - 1) % 5;
    if (addressMode == 0 && !c.supportsUA) continue;
    if (addressMode == c.defaultAddrMode) break;
    if (addressMode == 4) break; // diversified address
    if (availableMode & (1 << (addressMode - 1)) != 0) break;
  }
  return addressMode;
}
