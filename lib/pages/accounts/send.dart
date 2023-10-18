import 'dart:convert';

import 'package:YWallet/appsettings.dart';
import 'package:YWallet/store.dart';
import 'package:YWallet/store2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../pages/accounts/txplan.dart';

class SendPage extends StatefulWidget {
  final bool single;
  SendPage({required this.single});

  @override
  State<StatefulWidget> createState() => _SendState();
}

class _SendState extends State<SendPage> {
  int activeStep = 0;
  final typeFormKey = GlobalKey<FormBuilderState>();
  final addressKey = GlobalKey<SendAddressState>();
  final poolKey = GlobalKey<SendPoolState>();
  final amountKey = GlobalKey<SendAmountState>();
  final memoKey = GlobalKey<SendMemoState>();

  String address = '';
  int amount = 0;
  int pools = 7;
  int spendable = 0;
  String memo = '';
  String txPlan = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final icons = [
      Icon(Icons.label),
      Icon(Icons.alternate_email),
      Icon(Icons.pool),
      Icon(Icons.paid),
      Icon(Icons.description),
      Icon(Icons.confirmation_number),
    ];

    final type = typeFormKey.currentState?.fields['type']!.value ?? 0;

    final nextButton = activeStep < icons.length - 1
        ? IconButton.outlined(
            icon: Icon(Icons.chevron_right_rounded, size: 32),
            onPressed: () {
              if (!validate()) return;
              if (activeStep < icons.length - 1) {
                setState(() {
                  activeStep++;
                });
              }
            },
          )
        : IconButton.filled(
            onPressed: () {
              GoRouter.of(context).go('/account/submit_tx', extra: txPlan);
            },
            iconSize: 32,
            icon: Icon(Icons.send));

    final previousButton = activeStep > 0 ? IconButton.outlined(
      icon: Icon(Icons.chevron_left_rounded, size: 32),
      onPressed: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
    ) : SizedBox();

    final recipientBuilder = RecipientObjectBuilder(
      address: address,
      amount: amount,
      memo: memo,
      subject: '',
    );
    final recipient = Recipient(recipientBuilder.toBytes());

    final b = [
      () => SendAddressType(formKey: typeFormKey),
      () => SendAddress(address,
          key: addressKey,
          onAddress: (a) => setState(() {
                address = a;
              })),
      () => SendPool(
            PoolData(pools, spendable),
            onPool: (p) => setState(() {
              pools = p.pools;
              spendable = p.spendable;
            }),
            key: poolKey,
          ),
      () => SendAmount(
            amount,
            spendable,
            key: amountKey,
            onAmount: (a) => setState(() {
              amount = a;
            }),
          ),
      () => SendMemo(memo,
          onMemo: (m) => setState(() {
                memo = m;
              }),
          key: memoKey),
      () => SendReport(
            recipient: recipient,
            onTxPlan: (p) => setState(() {
              txPlan = p;
            }),
          ),
    ];
    final body = (activeStep < b.length) ? b[activeStep].call() : Container();
    final receivers = WarpApi.receiversOfAddress(active.coin, address);
    print(address);
    print(amount);
    print(receivers);
    print(memo);

    return Scaffold(
        appBar: AppBar(
          title: Text(s.send),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              IconStepper(
                icons: icons,
                activeStep: activeStep,
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
              body,
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  previousButton,
                  nextButton,
                ],
              ),
            ],
          ),
        ));
  }

  bool validate() {
    if (activeStep == 1) return addressKey.currentState!.validate();
    if (activeStep == 2) return poolKey.currentState!.validate();
    if (activeStep == 3) return amountKey.currentState!.validate();
    if (activeStep == 4) return memoKey.currentState!.validate();
    // TODO: Revalidate everything before preparing the tx in case
    // the user skipped forward
    return true;
  }
}

class SendAddressType extends StatefulWidget {
  final int type;
  final void Function(int) onType;
  SendAddressType(this.type, {required this.onType});
  
  @override
  State<StatefulWidget> createState() => SendAddressTypeState();
}

class SendAddressTypeState extends State<SendAddressType> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilder(
      key: formKey,
      child: Column(children: [
        Title(s.recipient),
        SizedBox(height: 16),
        FormBuilderRadioGroup(
          name: 'type',
          initialValue: 0,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          orientation: OptionsOrientation.vertical,
          options: [
            FormBuilderFieldOption(value: 0, child: Text(s.address)),
            FormBuilderFieldOption(value: 1, child: Text(s.paymentURI)),
            FormBuilderFieldOption(value: 2, child: Text(s.contacts)),
            FormBuilderFieldOption(value: 3, child: Text(s.account)),
            FormBuilderFieldOption(value: 4, child: Text(s.lastPayment)),
          ],
        ),
      ]),
    );
  }
}

class SendAddress extends StatefulWidget {
  final String address;
  final void Function(String) onAddress;
  SendAddress(this.address, {super.key, required this.onAddress});

  @override
  State<StatefulWidget> createState() => SendAddressState();
}

class SendAddressState extends State<SendAddress> {
  final formKey = GlobalKey<FormBuilderState>();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilder(
      key: formKey,
      child: Row(children: [
        Expanded(
            child: FormBuilderTextField(
          name: 'address',
          controller: addressController,
          maxLines: 4,
          decoration: InputDecoration(label: Text(s.address)),
          validator: (v) => _addressCheck(v, s),
        )),
        SizedBox(
            width: 80,
            child:
                IconButton.outlined(onPressed: _qr, icon: Icon(Icons.qr_code))),
      ]),
    );
  }

  _qr() {} // TODO

  String? _addressCheck(String? v, S s) {
    if (v == null || v.isEmpty) return s.addressIsEmpty;
    final valid = WarpApi.validAddress(active.coin, v);
    if (!valid) return s.invalidAddress;
    return null;
  }

  bool validate() {
    final form = formKey.currentState!;
    if (!form.validate()) return false;
    widget.onAddress(addressController.text);
    return true;
  }
}

class SendPool extends StatefulWidget {
  final PoolData initialPools;
  final void Function(PoolData data) onPool;
  SendPool(this.initialPools, {super.key, required this.onPool});

  @override
  State<StatefulWidget> createState() => SendPoolState();
}

class SendPoolState extends State<SendPool> {
  PoolBalanceT bals = PoolBalanceT();
  late int pools = widget.initialPools.pools;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    bals = WarpApi.getPoolBalances(
            active.coin, active.id, appSettings.anchorOffset)
        .unpack();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final style = t.textTheme.titleLarge!;
    List<int> initialPools = [];
    var p = pools;
    for (var i = 0; i < 3; i++) {
      if (p & 1 != 0) initialPools.add(i);
      p ~/= 2;
    }
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          Title(s.pools),
          SizedBox(height: 16),
          FormBuilderCheckboxGroup<int>(
            name: 'pools',
            orientation: OptionsOrientation.vertical,
            initialValue: initialPools,
            onChanged: (values) {
              pools = 0;
              for (var v in values!) {
                pools |= 1 << v;
              }
              setState(() {});
            },
            options: [
              FormBuilderFieldOption(
                value: 0,
                child: ListTile(
                  trailing: Text(amountToString2(bals.transparent)),
                  title: Text(s.transparent,
                      style: style.apply(color: Colors.red)),
                ),
              ),
              FormBuilderFieldOption(
                value: 1,
                child: ListTile(
                  trailing: Text(amountToString2(bals.sapling)),
                  title:
                      Text(s.sapling, style: style.apply(color: Colors.yellow)),
                ),
              ),
              FormBuilderFieldOption(
                value: 2,
                child: ListTile(
                  trailing: Text(amountToString2(bals.orchard)),
                  title:
                      Text(s.orchard, style: style.apply(color: Colors.green)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('${s.spendable} ${amountToString2(spendable)}')
        ],
      ),
    );
  }

  int get spendable {
    return (pools & 1 != 0 ? bals.transparent : 0) +
        (pools & 2 != 0 ? bals.sapling : 0) +
        (pools & 4 != 0 ? bals.orchard : 0);
  }

  bool validate() {
    if (!formKey.currentState!.validate()) return false;
    widget.onPool(PoolData(pools, spendable));
    return true;
  }
}

class PoolData {
  final int pools;
  final int spendable;
  PoolData(this.pools, this.spendable);
}

enum AmountSource {
  Crypto,
  Fiat,
  Slider,
}

class SendAmount extends StatefulWidget {
  final int initialAmount;
  final int spendable;
  final void Function(int) onAmount;
  SendAmount(this.initialAmount, this.spendable,
      {super.key, required this.onAmount});

  @override
  State<StatefulWidget> createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  final formKey = GlobalKey<FormBuilderState>();
  double? fxRate;
  int amount = 0;
  final amountController = TextEditingController();
  final fiatController = TextEditingController();
  final nformat = NumberFormat();

  @override
  void initState() {
    super.initState();
    amount = widget.initialAmount;
    amountController.text = amountToString2(amount);
    Future(() async {
      final c = coins[active.coin];
      fxRate = await getFxRate(c.currency, appSettings.currency);
      _update(AmountSource.Crypto);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = coins[active.coin];
    return FormBuilder(
      key: formKey,
      child: Column(children: [
        Title(s.amount),
        SizedBox(height: 16),
        Text('${s.spendable}  ${amountToString2(widget.spendable)}'),
        SizedBox(height: 16),
        FormBuilderTextField(
          name: 'amount',
          decoration: InputDecoration(label: Text(c.ticker)),
          controller: amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (v0) {
            final v = v0 == null || v0.isEmpty ? '0' : v0;
            try {
              final zec = nformat.parse(v).toDouble();
              amount = (zec * ZECUNIT).toInt();
              _update(AmountSource.Crypto);
            } on FormatException {}
          },
          validator: (_) {
            try {
              if (amount < 0) return s.amountMustBePositive;
              if (amount > widget.spendable) return s.amountTooHigh;
              return null;
            } on FormatException {
              return s.nan;
            }
          },
        ),
        FormBuilderTextField(
            name: 'fiat',
            decoration: InputDecoration(label: Text(appSettings.currency)),
            controller: fiatController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            enabled: fxRate != null,
            onChanged: (v0) {
              final v = v0 == null || v0.isEmpty ? '0' : v0;
              try {
                final fiat = nformat.parse(v).toDouble();
                final zec = fiat / fxRate!;
                amount = (zec * ZECUNIT).toInt();
                _update(AmountSource.Fiat);
              } on FormatException {}
            }),
        FormBuilderSlider(
          name: 'slider',
          initialValue: 0,
          min: 0,
          max: 100,
          divisions: 10,
          onChanged: (v0) {
            final v = v0 ?? 0;
            amount = widget.spendable * v ~/ 100;
            _update(AmountSource.Slider);
          },
        )
      ]),
    );
  }

  _update(AmountSource source) {
    if (source != AmountSource.Crypto)
      amountController.text = nformat.format(amount / ZECUNIT);
    fxRate?.let((fx) {
      if (source != AmountSource.Fiat)
        fiatController.text = nformat.format(amount * fx / ZECUNIT);
      // slider
    });
    if (source != AmountSource.Slider && widget.spendable != 0) {
      final p = amount / widget.spendable * 100;
      formKey.currentState!.fields['slider']!.setValue(p.clamp(0.0, 100.0));
    }
    setState(() {});
  }

  bool validate() {
    if (!formKey.currentState!.validate()) return false;
    widget.onAmount.call(amount);
    return true;
  }
}

class SendMemo extends StatefulWidget {
  final String memo;
  final void Function(String) onMemo;

  SendMemo(this.memo, {super.key, required this.onMemo});

  @override
  State<StatefulWidget> createState() => SendMemoState();
}

class SendMemoState extends State<SendMemo> {
  late final controller = TextEditingController(text: widget.memo);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilder(
        key: formKey,
        child: Column(children: [
          Title(s.memo),
          SizedBox(height: 16),
          FormBuilderTextField(
            name: 'memo',
            controller: controller,
            decoration: InputDecoration(label: Text(s.memo)),
            maxLines: 10,
            validator: (v) {
              if (v == null) return null;
              if (utf8.encode(v).length > 511) return s.memoTooLong;
              return null;
            },
          )
        ]));
  }

  bool validate() {
    if (!formKey.currentState!.validate()) return false;
    widget.onMemo(controller.text);
    return true;
  }
}

class SendReport extends StatefulWidget {
  final Recipient recipient;
  final bool signOnly;
  final void Function(String) onTxPlan;
  SendReport(
      {required this.recipient, required this.onTxPlan, this.signOnly = false});
  @override
  State<StatefulWidget> createState() => SendReportState();
}

class SendReportState extends State<SendReport> {
  String? txPlan;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final plan = await WarpApi.prepareTx(
          active.coin,
          active.id,
          [widget.recipient],
          appSettings.anchorOffset,
          getCoinSettings(active.coin).feeT);
      widget.onTxPlan(plan);
      txPlan = plan;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final plan = txPlan;
    if (plan != null)
      return TxPlanPage.fromPlan(plan, widget.signOnly);
    else
      return Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: t.primaryColor,
          size: 200,
        ),
      );
  }
}

class Title extends StatelessWidget {
  final String title;
  Title(this.title);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: t.colorScheme.primary),
        child: Text(title, style: t.textTheme.bodyLarge));
  }
}
