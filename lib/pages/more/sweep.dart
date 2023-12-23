import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/warp_api.dart';

import '../../appsettings.dart';
import '../settings.dart';
import '../widgets.dart';
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
  late final t = Theme.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final seedController = TextEditingController();
  final privateKeyController = TextEditingController();
  final indexController = TextEditingController(text: '0');
  final gapController = TextEditingController(text: '40');
  int _pool = 0;
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(s.sweep),
          actions: [IconButton(onPressed: ok, icon: Icon(Icons.check))],
        ),
        body: LoadingWrapper(loading,
            child: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 16),
              child: FormBuilder(
                key: formKey,
                child: Column(children: [
                  Divider(),
                  Text(s.source, style: t.textTheme.titleLarge),
                  Gap(8),
                  Panel(
                    s.seed,
                    child: Column(children: [
                      FormBuilderTextField(
                        name: 'seed',
                        decoration: InputDecoration(label: Text(s.seed)),
                        controller: seedController,
                        validator: _validSeed,
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
                  Gap(16),
                  Panel(s.privateKey,
                      child: FormBuilderTextField(
                        name: 'sk',
                        controller: privateKeyController,
                        validator: _validTKey,
                      )),
                  Divider(),
                  Gap(8),
                  Text(s.destination, style: t.textTheme.titleLarge),
                  Gap(16),
                  FieldUA(
                    _pool,
                    name: 'pool',
                    label: s.pool,
                    onChanged: (v) => setState(() => _pool = v!),
                    radio: true,
                    emptySelectionAllowed: true,
                  ),
                  if (_pool == 0)
                    InputTextQR('',
                        onChanged: (v) => setState(() => _address = v)),
                ]),
              ),
            ))));
  }

  ok() async {
    final form = formKey.currentState!;
    final seed = seedController.text;
    final sk = privateKeyController.text;

    if (!form.validate()) return;
    if (seed.isEmpty && sk.isEmpty) {
      form.fields['seed']!.invalidate(s.seedOrKeyRequired);
      form.fields['sk']!.invalidate(s.seedOrKeyRequired);
      return;
    }
    form.save();

    final latestHeight = await WarpApi.getLatestHeight(aa.coin);

    if (seed.isNotEmpty) {
      load(() async {
        try {
          final txPlan = await WarpApi.sweepTransparentSeed(
              aa.coin,
              aa.id,
              latestHeight,
              seed,
              _pool,
              _address ?? '',
              0,
              30,
              coinSettings.feeT);
          GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
        } on String catch (e) {
          form.fields['seed']!.invalidate(e);
        }
      });
    }

    if (sk.isNotEmpty) {
      await load(() async {
        try {
          final txPlan = await WarpApi.sweepTransparent(aa.coin, aa.id,
              latestHeight, sk, _pool, _address ?? '', coinSettings.feeT);
          GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
        } on String catch (e) {
          form.fields['sk']!.invalidate(e);
        }
      });
    }
  }

  String? _validSeed(String? v) {
    if (v == null) return null;
    if (v.isNotEmpty && !WarpApi.validSeed(aa.coin, v)) return s.invalidKey;
    return null;
  }

  String? _validTKey(String? v) {
    if (v == null) return null;
    if (v.isNotEmpty && !WarpApi.isValidTransparentKey(v)) return s.invalidKey;
    return null;
  }
}
