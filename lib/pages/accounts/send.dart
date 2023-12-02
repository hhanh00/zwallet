import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tuple/tuple.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../more/contacts.dart';
import '../scan.dart';
import '../utils.dart';
import '../widgets.dart';
import 'manager.dart';

class SendContext {
  final String address;
  final int pools;
  final int amount;
  final bool deductFee;
  final MemoData? memo;
  SendContext(this.address, this.pools, this.amount, this.deductFee, this.memo);

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
  final contactKey = GlobalKey<ContactListState>();
  final accountKey = GlobalKey<AccountListState>();
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
  bool deductFee = false;
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
      Icon(Icons.label, color: background), // type
      Icon(Icons.alternate_email, color: background), // address
      Icon(Icons.pool, color: background), // pools
      Icon(Icons.paid, color: background), // amount
      Icon(Icons.description, color: background), // memo
      // Icon(Icons.confirmation_number),
    ];

    if (activeStep == icons.length - 1)
      SendContext.instance =
          SendContext(address, pools, amount, deductFee, memo);

    final isTransparent = WarpApi.receiversOfAddress(aa.coin, address) == 1;
    // skip memo if recipient is transparent address
    final lastStep =
        activeStep == icons.length - 1 || (isTransparent && activeStep == 3);
    final hasContacts = contacts.isNotEmpty;
    final nextButton = !lastStep
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
              }
              if (activeStep == 1 && !widget.single)
                setState(
                    () => activeStep += 2); // skip pool selection when multipay
              else if (activeStep < icons.length - 1) {
                setState(() => activeStep++);
              }
            },
          )
        : IconButton(onPressed: calcPlan, iconSize: 32, icon: Icon(Icons.send));

    final previousButton = IconButton(
      icon: Icon(Icons.chevron_left_rounded, size: 32),
      onPressed: () {
        if (activeStep == 3 && !widget.single)
          setState(() => activeStep -= 2);
        else if (activeStep > 0) {
          setState(() => activeStep--);
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
            final i = contacts.indexWhere((c) => c.address == address);
            return Expanded(
              child: ContactList(
                key: contactKey,
                initialSelect: i >= 0 ? i : null,
              ),
            );
          case 3:
            final i = accounts.indexWhere((a) => a.address == address);
            return Expanded(
              child: AccountList(
                key: accountKey,
                initialSelect: i >= 0 ? i : null,
              ),
            );
          default:
            return SendAddress(address, key: addressKey);
        }
      },
      () => SendPool(
            pools,
            key: poolKey,
            balances: balances,
          ),
      () => SendAmount(
            amount,
            spendable: spendable,
            key: amountKey,
            canDeductFee: widget.single,
          ),
      () => SendMemo(memo, key: memoKey),
    ];
    final content = b[activeStep].call();
    receivers = WarpApi.receiversOfAddress(aa.coin, address);
    // print(address);
    // print(amount);
    // print(receivers);
    // print(memo);

    final body = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
          wrapWithLoading(content),
        ],
      ),
    );

    // These already contain a scrollable list, we cannot have two
    // scrollable widgets
    final hasList = activeStep == 1 && (type == 2 || type == 3);

    return Scaffold(
        appBar: AppBar(
          title: Text(s.send),
          actions: actions,
        ),
        body: hasList ? body : SingleChildScrollView(child: body));
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
          final c = contactKey.currentState!.selectedContact;
          v = c?.let((c) => c.address!);
          break;
        case 3:
          final a = accountKey.currentState!.selectedAccount;
          v = a?.let((a) => a.address!);
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
      amount = v.item1;
      deductFee = v.item2;
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
      final p = WarpApi.decodePaymentURI(aa.coin, uri!);
      if (p == null) return s.invalidPaymentURI;
      address = p.address!;
      amount = p.amount;
      memo = MemoData(false, '', p.memo!);
      SendContext.instance =
          SendContext(address, pools, amount, deductFee, memo);
      return null;
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
      feeIncluded: deductFee,
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
    final s = S.of(context);
    return FormBuilder(
      key: formKey,
      child: InputTextQR(widget.address,
          label: s.address,
          lines: 4,
          validator: addressValidator,
          onChanged: (v) => _address = v!),
    );
  }

  String? get address {
    final form = formKey.currentState!;
    if (!form.validate()) return null;
    form.save();
    return _address;
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
  final bool canDeductFee;
  SendAmount(this.initialAmount,
      {super.key, required this.spendable, required this.canDeductFee});

  @override
  State<StatefulWidget> createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  final formKey = GlobalKey<FormBuilderState>();
  late int _amount = widget.initialAmount;
  bool _deductFee = false;

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
          onChanged: (a) => setState(
            () {
              _amount = a!.value;
              _deductFee = a.deductFee;
            },
          ),
          canDeductFee: widget.canDeductFee,
        ),
      ),
    ]);
  }

  Tuple2<int, bool>? get amount {
    if (!formKey.currentState!.validate()) return null;
    return Tuple2(_amount, _deductFee);
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
          FormBuilderSwitch(
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
  final SendContext? sendContext;
  QuickSendPage({this.sendContext});

  @override
  State<StatefulWidget> createState() => _QuickSendState();
}

class _QuickSendState extends State<QuickSendPage> with WithLoadingAnimation {
  late final s = S.of(context);
  late final t = Theme.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final addressKey = GlobalKey<InputTextQRState>();
  final amountKey = GlobalKey<AmountPickerState>();
  final memoKey = GlobalKey<InputMemoState>();
  late final balances =
      WarpApi.getPoolBalances(aa.coin, aa.id, appSettings.anchorOffset, false)
          .unpack();
  late String _address = widget.sendContext?.address ?? '';
  late int _pools = widget.sendContext?.pools ?? 7;
  late int _amount = widget.sendContext?.amount ?? 0;
  late bool _deductFee = widget.sendContext?.deductFee ?? false;
  late MemoData _memo = widget.sendContext?.memo ??
      MemoData(appSettings.includeReplyTo != 0, '', appSettings.memo);

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
        body: wrapWithLoading(SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  InputTextQR(
                    _address,
                    key: addressKey,
                    lines: 4,
                    onChanged: _onAddress,
                    validator: composeOr([addressValidator, paymentURIValidator]),
                    buttonsBuilder: _extraAddressButtons,
                  ),
                  PoolSelection(
                    _pools,
                    balances: aa.poolBalances,
                    onChanged: (v) => _pools = v!,
                  ),
                  AmountPicker(
                    _amount,
                    key: amountKey,
                    spendable: spendable,
                    onChanged: (a) {
                      _amount = a!.value;
                      _deductFee = a.deductFee;
                    },
                  ),
                  InputMemo(
                    _memo,
                    key: memoKey,
                    onChanged: (v) => _memo = v!,
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  List<Widget> _extraAddressButtons(BuildContext context,
      {Function(String)? onChanged}) {
    return [
      IconButton(
          onPressed: () async {
            final c = await GoRouter.of(context)
                .push<Contact>('/more/contacts?selectable=1');
            c?.let((c) => onChanged?.call(c.address!));
          },
          icon: FaIcon(FontAwesomeIcons.addressBook)),
      Gap(8),
      IconButton(
          onPressed: () async {
            final a = await GoRouter.of(context)
                .push<Account>('/account/account_manager');
            print('${a?.address}');
            a?.let((a) => onChanged?.call(a.address!));
          },
          icon: FaIcon(FontAwesomeIcons.users)),
    ];
  }

  send() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      logger.d(
          'send $_address $_amount $_deductFee $_pools ${_memo.reply} ${_memo.subject} ${_memo.memo}');
      final builder = RecipientObjectBuilder(
        address: _address,
        amount: _amount,
        feeIncluded: _deductFee,
        replyTo: _memo.reply,
        subject: _memo.subject,
        memo: _memo.memo,
      );
      final recipient = Recipient(builder.toBytes());
      SendContext.instance =
          SendContext(_address, _pools, _amount, _deductFee, _memo);
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

  _onAddress(String? v) {
    if (v == null) return;
    final puri = WarpApi.decodePaymentURI(aa.coin, v);
    if (puri != null) {
      addressKey.currentState!.setValue(puri.address!);
      amountKey.currentState!.setAmount(puri.amount);
      memoKey.currentState!.setMemoBody(puri.memo!);
    }
    else 
      _address = v;
  }
}
