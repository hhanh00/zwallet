import 'package:YWallet/appsettings.dart';
import 'package:YWallet/pages/settings.dart';
import 'package:YWallet/pages/widgets.dart';
import 'package:YWallet/store2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';

class SweepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SweepState();
}

class _SweepState extends State<SweepPage>
    with WithLoadingAnimation<SweepPage> {
  late final s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final seedController = TextEditingController();
  final privateKeyController = TextEditingController();
  final indexController = TextEditingController(text: '0');
  final gapController = TextEditingController(text: '40');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(s.sweep),
          actions: [IconButton(onPressed: ok, icon: Icon(Icons.check))],
        ),
        body: LoadingWrapper(loading,
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                child: Column(children: [
                  SizedBox(height: 8),
                  Panel(
                    s.seed,
                    child: Column(children: [
                      FormBuilderTextField(
                        name: 'seed',
                        decoration: InputDecoration(label: Text(s.seed)),
                        controller: seedController,
                      ),
                      FormBuilderTextField(
                        name: 'index',
                        decoration:
                            InputDecoration(label: Text(s.accountIndex)),
                        controller: indexController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.integer(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'limit',
                        decoration: InputDecoration(label: Text(s.gapLimit)),
                        controller: gapController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.integer(),
                        ]),
                      ),
                    ]),
                  ),
                  SizedBox(height: 16),
                  Panel(s.privateKey,
                      child: FormBuilderTextField(
                        name: 'sk',
                        controller: privateKeyController,
                      )),
                  FieldUARadio(0, name: 'pool', label: s.pool),
                ]),
              ),
            )));
  }

  ok() async {
    final form = formKey.currentState!;
    final seed = seedController.text;
    final sk = privateKeyController.text;

    final latestHeight = await WarpApi.getLatestHeight(aa.coin);
    final pool = form.fields['pool']!.value as int;

    try {
      if (seed.isNotEmpty) {
        load(() async {
          final txPlan = await WarpApi.sweepTransparentSeed(aa.coin, aa.id,
              latestHeight, seed, pool, 0, 30, coinSettings.feeT);
          GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
        });
      }

      if (sk.isNotEmpty) {
        await load(() async {
          final txPlan = await WarpApi.sweepTransparent(
              aa.coin, aa.id, latestHeight, sk, pool, coinSettings.feeT);
          GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
        });
      }
    } on String catch (e) {
      form.fields['sk']!.invalidate(e);
    }
  }
}
