import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart' hide Account;
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../scan.dart';
import '../utils.dart';
import '../widgets.dart';

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

class _SendState extends State<SendPage> with WithLoadingAnimation {
  int activeStep = 0;
  final typeKey = GlobalKey<SendAddressTypeState>();
  final addressKey = GlobalKey<SendAddressState>();
  final contactKey = GlobalKey<SendListState<Contact>>();
  final accountKey = GlobalKey<SendListState<Account>>();
  final poolKey = GlobalKey<SendPoolState>();
  final amountKey = GlobalKey<SendAmountState>();
  final memoKey = GlobalKey<SendMemoState>();
  // final planKey = GlobalKey<SendReportState>();

  int type = 0;
  String address = '';
  int receivers = 0;
  PoolData poolData = PoolData(7, 0);
  int amount = 0;
  MemoData memo = MemoData(false, '', '');
  int? contactIndex;
  late final accounts = WarpApi.getAccountList(aa.coin);
  late final contacts = WarpApi.getContacts(aa.coin);
  int? accountIndex;
  // String? txPlan;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final icons = [
      Icon(Icons.label),
      Icon(Icons.alternate_email),
      Icon(Icons.pool),
      Icon(Icons.paid),
      Icon(Icons.description),
      // Icon(Icons.confirmation_number),
    ];

    if (activeStep == icons.length - 1)
      SendContext.instance = SendContext(address, poolData.pools, amount, memo);

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
            poolData,
            key: poolKey,
          ),
      () => SendAmount(
          AmountState(amount: amount, spendable: poolData.spendable),
          key: amountKey),
      () => wrapWithLoading(SendMemo(memo, key: memoKey)),
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
          actions: actions,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              IconStepper(
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
              body,
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
        SendStepTitle(s.recipient),
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
    print('SendAddressState address');
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
    bals =
        WarpApi.getPoolBalances(aa.coin, aa.id, appSettings.anchorOffset, false)
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
          SendStepTitle(s.pools),
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
              if (aa.hasUA)
                FormBuilderFieldOption(
                  value: 2,
                  child: ListTile(
                    trailing: Text(amountToString2(bals.orchard)),
                    title: Text(s.orchard,
                        style: style.apply(color: Colors.green)),
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

class SendAmount extends StatefulWidget {
  final AmountState initialAmount;
  SendAmount(this.initialAmount, {super.key});

  @override
  State<StatefulWidget> createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  final inputKey = GlobalKey<InputAmountState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(children: [
      SendStepTitle(s.amount),
      SizedBox(height: 16),
      InputAmountWidget(key: inputKey, widget.initialAmount),
    ]);
  }

  int? get amount {
    final state = inputKey.currentState!;
    return state.amount;
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
          SendStepTitle(s.memo),
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

class SendStepTitle extends StatelessWidget {
  final String title;
  SendStepTitle(this.title);

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

class QuickSendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuickSendState();
}

class _QuickSendState extends State<QuickSendPage> {
  late final s = S.of(context);
  late final t = Theme.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  String _address = '';
  int _pools = 7;
  int _amount = 0;
  String _memo = '';

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              InputAddress(_address, onSaved: (v) => setState(() => _address = v!)),
              PoolSelection(
                _pools,
                balances: aa.poolBalances,
                onChanged: (v) => setState(() => _pools = v!),
              ),
              AmountPicker(
                _amount,
                spendable: spendable,
                onSaved: (v) => setState(() => _amount = v!),
              ),
              FormBuilderTextField(
                name: 'memo',
                decoration: InputDecoration(label: Text(s.memo)),
                initialValue: appSettings.memo,
                onSaved: (v) => setState(() => _memo = v!),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  send() {}

  int get spendable {
    return (_pools & 1 != 0 ? aa.poolBalances.transparent : 0) +
        (_pools & 2 != 0 ? aa.poolBalances.sapling : 0) +
        (_pools & 4 != 0 ? aa.poolBalances.orchard : 0);
  }
}
