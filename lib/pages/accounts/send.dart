import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../scan.dart';
import '../utils.dart';
import '../widgets.dart';

class SendContext {
  final String address;
  final int pools;
  final int amount;
  final MemoData? memo;
  SendContext(this.address, this.pools, this.amount, this.memo);

  static SendContext? instance;
}

class SendPage extends StatefulWidget {
  final bool single;
  SendPage({required this.single});

  @override
  State<StatefulWidget> createState() => _SendState();
}

class _SendState extends State<SendPage> with WithLoadingAnimation {
  int activeStep = 0;
  final typeKey = GlobalKey<SendAddressTypeState>();
  final addressKey = GlobalKey<SendAddressState>();
  final contactKey = GlobalKey<SendListState<Contact>>();
  final accountKey = GlobalKey<SendListState<Account>>();
  final poolKey = GlobalKey<SendPoolState>();
  final amountKey = GlobalKey<SendAmountState>();
  final memoKey = GlobalKey<SendMemoState>();
  late final PoolBalanceT balances =
      WarpApi.getPoolBalances(aa.coin, aa.id, appSettings.anchorOffset, false)
          .unpack();

  int type = 0;
  String address = '';
  int receivers = 0;
  int pools = 7;
  int amount = 0;
  MemoData memo = MemoData(false, '', appSettings.memo);
  int? contactIndex;
  late final accounts = WarpApi.getAccountList(aa.coin);
  late final contacts = WarpApi.getContacts(aa.coin);
  int? accountIndex;
  // String? txPlan;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);

    final background = t.colorScheme.onPrimary;
    final icons = [
      Icon(Icons.label, color: background),
      Icon(Icons.alternate_email, color: background),
      Icon(Icons.pool, color: background),
      Icon(Icons.paid, color: background),
      Icon(Icons.description, color: background),
      // Icon(Icons.confirmation_number),
    ];

    if (activeStep == icons.length - 1)
      SendContext.instance = SendContext(address, pools, amount, memo);

    final hasContacts = contacts.isNotEmpty;
    final nextButton = activeStep < icons.length - 1
        ? IconButton(
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
        : IconButton(onPressed: calcPlan, iconSize: 32, icon: Icon(Icons.send));

    final previousButton = IconButton(
      icon: Icon(Icons.chevron_left_rounded, size: 32),
      onPressed: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
    );

    final actions = [
      if (activeStep > 0) previousButton,
      nextButton,
    ];

    final spendable = getSpendable(pools, balances);

    final b = [
      () => SendAddressType(type, key: typeKey, hasContacts: hasContacts),
      () {
        switch (type) {
          case 2:
            return SendList<Contact>(contacts, contactIndex, key: contactKey,
                itemBuilder: (context, index, c, {onTap, selected = false}) {
              return ListTile(
                title: Text(c.name!),
                selected: selected,
                onTap: onTap,
              );
            });
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
            pools,
            key: poolKey,
            balances: balances,
          ),
      () => SendAmount(amount, spendable: spendable, key: amountKey),
      () => SendMemo(memo, key: memoKey),
    ];
    final body = b[activeStep].call();
    receivers = WarpApi.receiversOfAddress(aa.coin, address);
    // print(address);
    // print(amount);
    // print(receivers);
    // print(memo);

    return Scaffold(
        appBar: AppBar(
          title: Text(s.send),
          actions: actions,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              IconStepper(
                stepColor: t.colorScheme.primary,
                icons: icons,
                activeStep: activeStep,
                enableNextPreviousButtons: false,
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
                enableStepTapping: false,
              ),
              wrapWithLoading(body),
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
          v = contactIndex?.let((i) => contacts[i].address);
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
      final v = poolKey.currentState!.pools;
      if (v == null) return false;
      pools = v;
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
        final p = WarpApi.decodePaymentURI(aa.coin, uri!);
        address = p.address!;
        amount = p.amount;
        memo = MemoData(false, '', p.memo!);
        return null;
      } on String {
        return s.invalidPaymentURI;
      }
    });
    await calcPlan();
  }

  _latestPayment() async {
    final sc = SendContext.instance;
    if (sc != null) {
      address = sc.address;
      amount = sc.amount;
      memo = sc.memo ?? MemoData(false, '', appSettings.memo);
      await calcPlan();
    }
  }

  calcPlan() async {
    final s = S.of(context);
    if (!validate()) return;
    final recipientBuilder = RecipientObjectBuilder(
      address: address,
      amount: amount,
      replyTo: memo.reply,
      subject: memo.subject,
      memo: memo.memo,
    );
    final recipient = Recipient(recipientBuilder.toBytes());
    if (!widget.single) GoRouter.of(context).pop(recipient);
    try {
      await load(() async {
        final plan = await WarpApi.prepareTx(
            aa.coin,
            aa.id,
            [recipient],
            pools,
            coinSettings.replyUa,
            appSettings.anchorOffset,
            CoinSettingsExtension.load(aa.coin).feeT);
        GoRouter.of(context).push('/account/txplan?tab=account', extra: plan);
      });
    } on String catch (e) {
      await showMessageBox2(context, s.error, e);
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
        MediumTitle(s.recipient),
        Gap(16),
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
  late String _address = widget.address;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: InputAddress(widget.address, onSaved: (v) => _address = v!),
    );
  }

  String? get address {
    final form = formKey.currentState!;
    if (!form.validate()) return null;
    form.save();
    return _address;
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
        name: 'value',
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
      form.fields['value']!.invalidate(s.noSelection);
      return null;
    }
    return selectedIndex;
  }
}

class SendPool extends StatefulWidget {
  final int initialPools;
  final PoolBalanceT balances;
  SendPool(this.initialPools, {super.key, required this.balances});

  @override
  State<StatefulWidget> createState() => SendPoolState();
}

class SendPoolState extends State<SendPool> {
  late int _pools = widget.initialPools;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          MediumTitle(s.pools),
          Gap(16),
          PoolSelection(
            _pools,
            balances: widget.balances,
            onChanged: (v) => setState(() => _pools = v!),
          ),
        ],
      ),
    );
  }

  int? get pools {
    if (!formKey.currentState!.validate()) return null;
    return _pools;
  }
}

class SendAmount extends StatefulWidget {
  final int initialAmount;
  final int spendable;
  SendAmount(this.initialAmount, {super.key, required this.spendable});

  @override
  State<StatefulWidget> createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  final formKey = GlobalKey<FormBuilderState>();
  late int _amount = widget.initialAmount;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(children: [
      MediumTitle(s.amount),
      Gap(16),
      FormBuilder(
        key: formKey,
        child: AmountPicker(
          widget.initialAmount,
          spendable: widget.spendable,
          onChanged: (v) => setState(() => _amount = v!),
        ),
      ),
    ]);
  }

  int? get amount {
    if (!formKey.currentState!.validate()) return null;
    return _amount;
  }
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
          MediumTitle(s.memo),
          Gap(16),
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

class QuickSendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuickSendState();
}

class _QuickSendState extends State<QuickSendPage> with WithLoadingAnimation {
  late final s = S.of(context);
  late final t = Theme.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  late final balances =
      WarpApi.getPoolBalances(aa.coin, aa.id, appSettings.anchorOffset, false)
          .unpack();
  String _address = '';
  int _pools = 7;
  int _amount = 0;
  MemoData? _memo;

  @override
  Widget build(BuildContext context) {
    final spendable = getSpendable(_pools, balances);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.send),
          actions: [
            IconButton(
              onPressed: send,
              icon: Icon(Icons.send),
            )
          ],
        ),
        body: wrapWithLoading(
          SingleChildScrollView(
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  InputAddress(_address,
                      onSaved: (v) => setState(() => _address = v!)),
                  PoolSelection(
                    _pools,
                    balances: aa.poolBalances,
                    onChanged: (v) => setState(() => _pools = v!),
                  ),
                  AmountPicker(
                    _amount,
                    spendable: spendable,
                    onChanged: (v) => setState(() => _amount = v!),
                  ),
                  InputMemo(
                    MemoData(
                        appSettings.includeReplyTo != 0, '', appSettings.memo),
                    onSaved: (v) => setState(() => _memo = v!),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  send() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      print(
          '$_address $_amount $_pools ${_memo?.reply} ${_memo?.subject} ${_memo?.memo}');
      final builder = RecipientObjectBuilder(
        address: _address,
        amount: _amount,
        replyTo: _memo?.reply ?? false,
        subject: _memo?.subject ?? '',
        memo: _memo?.memo ?? '',
      );
      final recipient = Recipient(builder.toBytes());
      SendContext.instance = SendContext(_address, _pools, _amount, _memo);
      try {
        final plan = await load(() => WarpApi.prepareTx(
            aa.coin,
            aa.id,
            [recipient],
            _pools,
            coinSettings.replyUa,
            appSettings.anchorOffset,
            coinSettings.feeT));
        GoRouter.of(context).push('/account/txplan?tab=account', extra: plan);
      } on String catch (e) {
        showMessageBox2(context, s.error, e);
      }
    }
  }
}
