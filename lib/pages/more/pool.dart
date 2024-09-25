import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../appsettings.dart';
import '../../pages/widgets.dart';
import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../input_widgets.dart';
import '../settings.dart';
import '../utils.dart';

class PoolTransferPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoolTransferState();
}

class _PoolTransferState extends State<PoolTransferPage>
    with WithLoadingAnimation {
  late final s = S.of(context);
  final memoController = TextEditingController(text: appSettings.memo);
  final splitController = TextEditingController(text: amountToString(0));
  late final List<double> balances;
  int amount = 0;
  int from = 1;
  int to = 2;

  @override
  void initState() {
    super.initState();
    final pb = aa.poolBalances;
    balances = [pb.transparent, pb.sapling, pb.orchard]
        .map((b) => b / ZECUNIT)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final spendable = aa.poolBalances.get(from);
    return Scaffold(
      appBar: AppBar(
          title: Text(s.poolTransfer),
          actions: [IconButton(onPressed: ok, icon: Icon(Icons.check))]),
      body: wrapWithLoading(
        SingleChildScrollView(
          child: FormBuilder(
            child: Column(
              children: [
                HorizontalBarChart(balances),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      FieldUA(
                        from,
                        name: 'from',
                        label: s.fromPool,
                        onChanged: (v) => setState(() {
                          from = v!;
                        }),
                        radio: true,
                      ),
                      FieldUA(
                        to,
                        name: 'to',
                        label: s.toPool,
                        onChanged: (v) => setState(() {
                          to = v!;
                        }),
                        radio: true,
                      ),
                      Gap(16),
                      // AmountPicker(
                      //   amount,
                      //   spendable: spendable,
                      //   onChanged: (a) => setState(() => amount = a!),
                      // ),
                      Gap(16),
                      FormBuilderTextField(
                        name: 'memo',
                        decoration: InputDecoration(label: Text(s.memo)),
                        controller: memoController,
                        maxLines: 10,
                      ),
                      FormBuilderTextField(
                          name: 'split',
                          decoration:
                              InputDecoration(label: Text(s.maxAmountPerNote)),
                          controller: splitController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0, inclusive: false),
                          ]))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ok() async {
    final splitAmount = stringToAmount(splitController.text);
    load(() async {
      try {
        // TODO
        // final plan = await warp.transferPool(
        //   aa.coin,
        //   aa.id,
        //   from,
        //   to,
        //   amount,
        //   false,
        //   memoController.text,
        //   splitAmount,
        //   appSettings.anchorOffset,
        // );
        // GoRouter.of(context).push('/account/txplan?tab=more', extra: plan);
      } on String catch (e) {
        await showMessageBox2(context, s.error, e);
      }
    });
  }
}

class HorizontalBarChart extends StatelessWidget {
  final List<double> values;
  final double height;

  HorizontalBarChart(this.values, {this.height = 32});

  @override
  Widget build(BuildContext context) {
    final palette = getPalette(Theme.of(context).primaryColor, values.length);

    final sum = values.fold<double>(0, ((acc, v) => acc + v));
    final stacks = values.asMap().entries.map((e) {
      final i = e.key;
      final color = palette[i];
      final v = NumberFormat.compact().format(values[i]);
      final flex = sum != 0 ? max((values[i] / sum * 100).round(), 1) : 1;
      return Flexible(
          child: Container(
              child: Center(
                  child: Text(v,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white))),
              color: color,
              height: height),
          flex: flex);
    }).toList();

    return IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: stacks));
  }
}

extension PoolBalanceExtension on BalanceT {
  int get(int p) {
    switch (p) {
      case 1:
        return transparent;
      case 2:
        return sapling;
      case 4:
        return orchard;
    }
    throw 'Invalid pool';
  }
}
