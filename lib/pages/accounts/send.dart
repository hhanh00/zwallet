import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart' hide Account;
import '../../appsettings.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../pages/accounts/txplan.dart';
import '../../pages/accounts/submit.dart';
import '../../settings.dart';
import '../../store.dart';
import '../../store2.dart';
import '../scan.dart';

class SendContext {
  final String address;
  final int pools;
  final int amount;
  final MemoData memo;
  SendContext(this.address, this.pools, this.amount, this.memo);

  static SendContext? instance;
}

class SendPage extends StatefulWidget {
  final bool single;
  SendPage({required this.single});

  @override
  State<StatefulWidget> createState() => _SendState();
}

class _SendState extends State<SendPage> {
  int activeStep = 0;
  final typeKey = GlobalKey<SendAddressTypeState>();
  final addressKey = GlobalKey<SendAddressState>();
  final contactKey = GlobalKey<SendListState<Contact>>();
  final accountKey = GlobalKey<SendListState<Account>>();
  final poolKey = GlobalKey<SendPoolState>();
  final amountKey = GlobalKey<SendAmountState>();
  final memoKey = GlobalKey<SendMemoState>();
  final planKey = GlobalKey<SendReportState>();

  int type = 0;
  String address = '';
  int receivers = 0;
  PoolData poolData = PoolData(7, 0);
  int amount = 0;
  MemoData memo = MemoData(false, '', '');
  int? contactIndex;
  late final List<Account> accounts;
  int? accountIndex;
  String? txPlan;

  @override
  void initState() {
    super.initState();
    accounts = WarpApi.getAccountList(aa.coin);
  }

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

    if (activeStep == icons.length - 1)
      SendContext.instance = SendContext(address, poolData.pools, amount, memo);

    final hasContacts = contacts.contacts.isNotEmpty;
    final nextButton = activeStep < icons.length - 1
        ? IconButton.outlined(
            icon: Icon(Icons.chevron_right_rounded, size: 32),
            onPressed: () {
              if (!validate()) return;
              if (activeStep == 0 && type == 1) {
                _paymentURI();
                return;
              }
              if (activeStep == 0 && type == 4) {
                _latestPayment();
                return;
              } else {
                if (activeStep < icons.length - 1) {
                  setState(() {
                    activeStep++;
                  });
                }
              }
            },
          )
        : IconButton.filled(
            onPressed: txPlan != null
                ? () {
                    GoRouter.of(context)
                        .go('/account/submit_tx', extra: txPlan);
                  }
                : null,
            iconSize: 32,
            icon: Icon(Icons.send));

    final previousButton = activeStep > 0
        ? IconButton.outlined(
            icon: Icon(Icons.chevron_left_rounded, size: 32),
            onPressed: () {
              if (activeStep > 0) {
                setState(() {
                  activeStep--;
                });
              }
            },
          )
        : SizedBox();

    final recipientBuilder = RecipientObjectBuilder(
      address: address,
      amount: amount,
      replyTo: memo.reply,
      subject: memo.subject,
      memo: memo.memo,
    );
    final recipient = Recipient(recipientBuilder.toBytes());

    final b = [
      () => SendAddressType(type, key: typeKey, hasContacts: hasContacts),
      () {
        switch (type) {
          case 3:
            return SendList<Account>(accounts, accountIndex, key: accountKey,
                itemBuilder: (context, index, account,
                    {onTap, selected = false}) {
              final a = account.unpack();
              return ListTile(
                title: Text(a.name!),
                selected: selected,
                onTap: onTap,
              );
            });
          default:
            return SendAddress(address, key: addressKey);
        }
      },
      () => SendPool(
            poolData,
            key: poolKey,
          ),
      () => SendAmount(
          AmountState(amount: amount, spendable: poolData.spendable),
          key: amountKey),
      () => SendMemo(memo, key: memoKey),
      () => SendReport(key: planKey, recipient: recipient, 
        onPlan: (p) => setState(() { txPlan = p; })),
    ];
    final body = (activeStep < b.length) ? b[activeStep].call() : Container();
    receivers = WarpApi.receiversOfAddress(aa.coin, address);
    // print(address);
    // print(amount);
    // print(receivers);
    // print(memo);

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
                enableStepTapping: false,
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
    if (activeStep == 0) {
      type = typeKey.currentState!.type;
    }
    if (activeStep == 1) {
      String? v;
      switch (type) {
        case 0:
          v = addressKey.currentState!.address;
          break;
        // case 1 is payment URI
        case 2:
          contactIndex = contactKey.currentState!.index;
          v = contactIndex?.let((i) => contacts.contacts[i].address);
          break;
        case 3:
          accountIndex = accountKey.currentState!.index;
          v = accountIndex?.let((i) => accounts[i].address);
          break;
      }
      if (v == null) return false;
      address = v;
    }
    if (activeStep == 2) {
      final v = poolKey.currentState!.poolData;
      if (v == null) return false;
      poolData = v;
    }
    if (activeStep == 3) {
      final v = amountKey.currentState!.amount;
      if (v == null) return false;
      amount = v;
    }
    if (activeStep == 4) {
      final v = memoKey.currentState!.memo;
      if (v == null) return false;
      memo = v;
    }
    return true;
  }

  _paymentURI() async {
    final s = S.of(context);
    await scanQRCode(context, validator: (uri) {
      try {
        final p = WarpApi.decodePaymentURI(uri!);
        address = p.address!;
        amount = p.amount;
        memo = MemoData(false, '', p.memo!);
        return null;
      } on String {
        return s.invalidPaymentURI;
      }
    });
    activeStep = 5;
    setState(() {});
  }

  _latestPayment() {
    final sc = SendContext.instance;
    if (sc != null) {
      address = sc.address;
      amount = sc.amount;
      memo = sc.memo;
      activeStep = 5;
      setState(() {});
    }
  }
}

class SendAddressType extends StatefulWidget {
  final int type;
  final bool hasContacts;
  SendAddressType(this.type, {super.key, required this.hasContacts});

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
          initialValue: widget.type,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          orientation: OptionsOrientation.vertical,
          options: [
            FormBuilderFieldOption(value: 0, child: Text(s.address)),
            FormBuilderFieldOption(value: 1, child: Text(s.paymentURI)),
            if (widget.hasContacts)
              FormBuilderFieldOption(value: 2, child: Text(s.contacts)),
            FormBuilderFieldOption(value: 3, child: Text(s.account)),
            if (SendContext.instance != null)
              FormBuilderFieldOption(value: 4, child: Text(s.lastPayment)),
          ],
        ),
      ]),
    );
  }

  int get type {
    return formKey.currentState!.fields['type']?.value as int;
  }
}

class SendAddress extends StatefulWidget {
  final String address;
  SendAddress(this.address, {super.key});

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
          maxLines: 8,
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

  _qr() async {
    addressController.text = await scanQRCode(context, validator: (address) {
      final s = S.of(context);
      return _addressCheck(address, s);
    });
  }

  String? _addressCheck(String? v, S s) {
    if (v == null || v.isEmpty) return s.addressIsEmpty;
    final valid = WarpApi.validAddress(aa.coin, v);
    if (!valid) return s.invalidAddress;
    return null;
  }

  String? get address {
    final form = formKey.currentState!;
    if (!form.validate()) return null;
    return addressController.text;
  }
}

class SendList<T> extends StatefulWidget {
  final List<T> items;
  final int? index;
  final Widget Function(BuildContext, int, T,
      {bool selected, void Function()? onTap}) itemBuilder;
  SendList(this.items, this.index, {super.key, required this.itemBuilder});
  @override
  State<StatefulWidget> createState() => SendListState<T>();
}

class SendListState<T> extends State<SendList<T>> {
  final formKey = GlobalKey<FormBuilderState>();
  late int? selectedIndex = widget.index;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cs = widget.items;
    return FormBuilder(
      key: formKey,
      child: FormBuilderField(
        builder: (field) => InputDecorator(
            decoration: InputDecoration(
                label: Text(s.accounts), errorText: field.errorText),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => widget.itemBuilder(
                  context, index, widget.items[index],
                  selected: index == selectedIndex,
                  onTap: () => _select(index)),
              separatorBuilder: (context, index) => Divider(),
              itemCount: cs.length,
            )),
        name: 'account',
      ),
    );
  }

  _select(int index) {
    if (selectedIndex == index)
      selectedIndex = null;
    else
      selectedIndex = index;
    setState(() {});
  }

  int? get index {
    final s = S.of(context);
    final form = formKey.currentState!;
    if (selectedIndex == null) {
      form.fields['account']!.invalidate(s.noSelection);
      return null;
    }
    return selectedIndex;
  }
}

class SendPool extends StatefulWidget {
  final PoolData initialPools;
  SendPool(this.initialPools, {super.key});

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
            aa.coin, aa.id, appSettings.anchorOffset)
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

  PoolData? get poolData {
    if (!formKey.currentState!.validate()) return null;
    return PoolData(pools, spendable);
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

class AmountState {
  int amount;
  int spendable;
  AmountState({required this.amount, required this.spendable});
}

class SendAmount extends StatefulWidget {
  final AmountState initialAmount;
  SendAmount(this.initialAmount, {super.key});

  @override
  State<StatefulWidget> createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  final formKey = GlobalKey<FormBuilderState>();
  double? fxRate;
  int _amount = 0;
  final amountController = TextEditingController();
  final fiatController = TextEditingController();
  final nformat = NumberFormat();

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount.amount;
    amountController.text = amountToString2(_amount);
    Future(() async {
      final c = coins[aa.coin];
      fxRate = await getFxRate(c.currency, appSettings.currency);
      _update(AmountSource.Crypto);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = coins[aa.coin];
    final spendable = widget.initialAmount.spendable;
    return FormBuilder(
      key: formKey,
      child: Column(children: [
        Title(s.amount),
        SizedBox(height: 16),
        Text('${s.spendable}  ${amountToString2(spendable)}'),
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
              _amount = (zec * ZECUNIT).toInt();
              _update(AmountSource.Crypto);
            } on FormatException {}
          },
          validator: (_) {
            try {
              if (_amount < 0) return s.amountMustBePositive;
              if (_amount > spendable) return s.amountTooHigh;
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
                _amount = (zec * ZECUNIT).toInt();
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
            _amount = spendable * v ~/ 100;
            _update(AmountSource.Slider);
          },
        )
      ]),
    );
  }

  _update(AmountSource source) {
    if (source != AmountSource.Crypto)
      amountController.text = nformat.format(_amount / ZECUNIT);
    fxRate?.let((fx) {
      if (source != AmountSource.Fiat)
        fiatController.text = nformat.format(_amount * fx / ZECUNIT);
    });
    final spendable = widget.initialAmount.spendable;
    if (source != AmountSource.Slider && spendable != 0) {
      final p = _amount / spendable * 100;
      formKey.currentState!.fields['slider']!.setValue(p.clamp(0.0, 100.0));
    }
    setState(() {});
  }

  int? get amount {
    if (!formKey.currentState!.validate()) return null;
    return _amount;
  }
}

class MemoData {
  final bool reply;
  final String subject;
  final String memo;
  MemoData(this.reply, this.subject, this.memo);
}

class SendMemo extends StatefulWidget {
  final MemoData memo;
  SendMemo(this.memo, {super.key});

  @override
  State<StatefulWidget> createState() => SendMemoState();
}

class SendMemoState extends State<SendMemo> {
  late bool reply = widget.memo.reply;
  late final subjectController =
      TextEditingController(text: widget.memo.subject);
  late final memoController = TextEditingController(text: widget.memo.memo);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilder(
        key: formKey,
        child: Column(children: [
          Title(s.memo),
          SizedBox(height: 16),
          FormBuilderCheckbox(
            name: 'reply',
            initialValue: widget.memo.reply,
            title: Text(s.includeReplyTo),
            onChanged: (v) => setState(() {
              reply = v!;
            }),
          ),
          FormBuilderTextField(
            name: 'subject',
            controller: subjectController,
            decoration: InputDecoration(label: Text(s.subject)),
          ),
          FormBuilderTextField(
            name: 'memo',
            controller: memoController,
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

  MemoData? get memo {
    if (!formKey.currentState!.validate()) return null;
    return MemoData(reply, subjectController.text, memoController.text);
  }
}

class SendReport extends StatefulWidget {
  final Recipient recipient;
  final void Function(String) onPlan;
  final bool signOnly;
  SendReport({super.key, required this.recipient, 
    required this.onPlan, this.signOnly = false});
  @override
  State<StatefulWidget> createState() => SendReportState();
}

class SendReportState extends State<SendReport> {
  String? txPlan;
  String? error;

  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        final plan = await WarpApi.prepareTx(
            aa.coin,
            aa.id,
            [widget.recipient],
            appSettings.anchorOffset,
            CoinSettingsExtension.load(aa.coin).feeT);
        widget.onPlan(plan);
        txPlan = plan;
      } on String catch (e) {
        error = e;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final plan = txPlan;
    if (plan == null && error == null)
      return Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: t.primaryColor,
          size: 200,
        ),
      );
    else if (plan != null)
      return TxPlanPage.fromPlan(plan, widget.signOnly);
    else
      return Jumbotron(error!, severity: Severity.Error);
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
