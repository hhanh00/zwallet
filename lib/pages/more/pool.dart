import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../appsettings.dart';
import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../input_widgets.dart';
import '../utils.dart';

const MAX_NOTES = 25;

class PoolTransferPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoolTransferState();
}

class _PoolTransferState extends State<PoolTransferPage>
    with WithLoadingAnimation {
  late final s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  late final BalanceT balance;
  final memoController = TextEditingController(text: appSettings.memo);
  final splitController = TextEditingController(text: amountToString(0));
  late final List<double> balances;
  int amount = 0;
  int from = 1;
  int to = 2;
  UserMemoT memo = UserMemoT(body: '');

  @override
  void initState() {
    super.initState();
    balance = warp.getBalance(aa.coin, aa.id, syncStatus.confirmHeight);
    balances = [balance.transparent, balance.sapling, balance.orchard]
        .map((b) => b / ZECUNIT)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final spendable = balance.masked(from);
    return Scaffold(
      appBar: AppBar(
          title: Text(s.poolTransfer),
          actions: [IconButton(onPressed: ok, icon: Icon(Icons.check))]),
      body: wrapWithLoading(
        SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                HorizontalBarChart(balances),
                Gap(16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SegmentedPicker(
                        from,
                        name: 'from',
                        labels: poolLabels(),
                        available: 7,
                        onChanged: (v) => setState(() {
                          from = v!;
                        }),
                        multiSelectionEnabled: true,
                      ),
                      Gap(16),
                      SegmentedPicker(
                        to,
                        name: 'to',
                        labels: poolLabels(),
                        available: 7,
                        onChanged: (v) => setState(() {
                          to = v!;
                        }),
                        multiSelectionEnabled: false,
                      ),
                      Gap(16),
                      Text('${s.spendable}: ${amountToString(spendable)}'),
                      Gap(16),
                      AmountPicker(
                        amount,
                        name: 'amount',
                        maxAmount: spendable,
                        onChanged: (a) => setState(() => amount = a!),
                      ),
                      Gap(16),
                      MemoInput(
                        memo,
                        name: 'memo',
                        onSaved: (m) => memo = m!,
                      ),
                      Gap(16),
                      FormBuilderTextField(
                        name: 'split',
                        decoration:
                            InputDecoration(label: Text(s.maxAmountPerNote)),
                        controller: splitController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0, inclusive: true),
                          ],
                        ),
                      ),
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
    final form = formKey.currentState!;
    if (!form.saveAndValidate()) return;

    int splitAmount = stringToAmount(splitController.text);
    load(() async {
      try {
        final toAddress = warp.getAccountAddress(aa.coin, aa.id, now(), to);
        if (memo.replyTo)
          memo.sender = warp.getAccountAddress(aa.coin, aa.id, now(), 
            coinSettings.replyUa);
        if (splitAmount == 0) splitAmount = MAXMONEY;
        final n = amount ~/ splitAmount;
        final m = amount % splitAmount;
        if (n > MAX_NOTES) {
          await showMessageBox(context, s.error, s.tooManyNotes);
          return;
        }
        List<RecipientT> recipients = [];
        if (m != 0)
          recipients.add(RecipientT(
            address: toAddress,
            amount: m,
            pools: to,
          ));
        for (var i = 0; i < n; i++) {
          recipients.add(RecipientT(
            address: toAddress,
            amount: splitAmount,
            pools: to,
          ));
        }
        recipients.firstOrNull?.memo = memo;
        final payment = PaymentRequestT(
            recipients: recipients,
            srcPools: from,
            senderPayFees: true,
            useChange: true,
            height: syncStatus.confirmHeight,
            expiration: syncStatus.expirationHeight);

        final plan = await warp.pay(aa.coin, aa.id, payment);
        GoRouter.of(context).push('/account/txplan?tab=more', extra: plan);
      } on String catch (e) {
        await showMessageBox(context, s.error, e, type: DialogType.error);
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
