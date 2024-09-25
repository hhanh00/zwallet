import 'package:YWallet/pages/input_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../generated/intl/messages.dart';
import '../../appsettings.dart';
import '../../store.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../accounts/send.dart';
import '../utils.dart';
import '../widgets.dart';
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
  int mask = 0;
  int _pools = 2;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    syncStatus.update();
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
              aa.poolBalances;
              syncStatus.changed;

              return Column(
                children: [
                  SyncStatusWidget(),
                  Gap(8),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        AddressCarousel(
                          onAddressModeChanged: (m) => setState(() => mask = m),
                          onQRPressed:
                              () {}, // TODO: Go to Payment URI or save QR
                        ),
                        Gap(8),
                        BalanceWidget(
                          mask & 7,
                          key: key,
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
