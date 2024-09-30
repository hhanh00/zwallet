import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/warp.dart';

import '../../generated/intl/messages.dart';
import '../../appsettings.dart';
import '../../store.dart';
import '../../accounts.dart';
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
  int mask = 0;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    syncStatus.updateBCHeight();
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
              syncStatus.changed;
              final balance = warp.getBalance(aa.coin, aa.id, MAXHEIGHT);

              return Column(
                children: [
                  SyncStatusWidget(),
                  Gap(8),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        AddressCarousel(
                          onAddressModeChanged: (_, m) => setState(() => mask = m),
                          onQRPressed: () {
                            GoRouter.of(context).push('/account/payment_uri');
                          },
                        ),
                        Gap(8),
                        BalanceWidget(
                          key: ValueKey(balance),
                          balance,
                          mask & 7,
                        ),
                        Gap(16),
                        if (!aa.saved)
                          OutlinedButton(
                              onPressed: _backup, child: Text(s.backupMissing))
                      ])),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _send(bool custom) async {
    final protectSend = appSettings.protectSend;
    if (protectSend) {
      final authed = await authBarrier(context, dismissable: true);
      if (!authed) return;
    }
    final c = custom ? 1 : 0;
    GoRouter.of(context).push('/account/send?custom=$c');
  }

  _backup() {
    GoRouter.of(context).push('/more/backup');
  }
}
