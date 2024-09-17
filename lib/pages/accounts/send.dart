import 'package:YWallet/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../main.dart';
import '../../accounts.dart';
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../settings.dart';
import '../utils.dart';
import '../widgets.dart';

class SendPage extends StatefulWidget {
  final PaymentRequestT payment;
  final bool custom;
  final bool single;
  SendPage(this.payment, {this.custom = false, this.single = true});

  @override
  State<StatefulWidget> createState() => SendState();
}

class SendState extends State<SendPage> with WithLoadingAnimation {
  late final s = S.of(context);
  late final t = Theme.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final addressKey = GlobalKey<InputTextQRState>();
  final poolKey = GlobalKey<PoolSelectionState>();
  final amountKey = GlobalKey<AmountPickerState>();
  final memoKey = GlobalKey<InputMemoState>();
  final confirmedHeight = syncStatus.confirmHeight ?? MAXHEIGHT;
  late BalanceT balances = warp.getBalance(aa.coin, aa.id, confirmedHeight);
  String _address = '';
  int _senderPools = 7;
  int _recipientPools = 0;
  bool _deductFee = false;
  int _amount = 0;
  UserMemoT _memo = UserMemoT(
      replyTo: appSettings.includeReplyTo != 0,
      subject: '',
      body: appSettings.memo);
  int recipientPoolsAvailable = 0;
  bool isShielded = false;
  bool isTex = false;
  late bool custom;

  @override
  void initState() {
    super.initState();
    custom = widget.custom ^ appSettings.customSend;
    _didUpdateSendContext(widget.payment);
  }

  @override
  void didUpdateWidget(SendPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    balances = warp.getBalance(aa.coin, aa.id, confirmedHeight);
    amountKey.currentState?.updateFxRate();
    _didUpdateSendContext(widget.payment);
  }

  @override
  Widget build(BuildContext context) {
    final customSendSettings = appSettings.customSendSettings;
    final spendable = getSpendable(_senderPools, balances);
    final numReceivers = numPoolsOf(recipientPoolsAvailable);

    return Scaffold(
        appBar: AppBar(
          title: Text(s.send),
          actions: [
            IconButton(
              onPressed: _toggleCustom,
              icon: Icon(Icons.tune),
            ),
            IconButton(
              onPressed: send,
              icon: Icon(widget.single ? Icons.send : Icons.add),
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
                    label: s.address,
                    lines: 4,
                    onChanged: _onAddress,
                    validator: addressOrUriValidator,
                    buttonsBuilder: (context, {Function(String)? onChanged}) =>
                        _extraAddressButtons(
                      context,
                      custom,
                      onChanged: onChanged,
                    ),
                  ),
                  Gap(8),
                  FieldUA(_recipientPools,
                      name: 'recipient_pools',
                      label: s.receivers,
                      onChanged: (v) => setState(() => _recipientPools = v!),
                      radio: false,
                      pools: recipientPoolsAvailable,
                      hidden: numReceivers <= 1 ||
                          !custom ||
                          !customSendSettings.recipientPools),
                  Gap(8),
                  PoolSelection(
                    _senderPools,
                    key: poolKey,
                    balances: aa.poolBalances,
                    onChanged: (v) => setState(() => _senderPools = v!),
                    hidden: !widget.single ||
                        !custom ||
                        !customSendSettings.pools ||
                        isTex,
                  ),
                  Gap(8),
                  AmountPicker(
                    _amount,
                    key: amountKey,
                    spendable: spendable,
                    onChanged: (a) => _amount = a!,
                    custom: custom,
                  ),
                  Gap(8),
                  if (widget.single && custom)
                    Row(children: [
                      if (customSendSettings.deductFee)
                        Expanded(child: FormBuilderSwitch(
                            name: 'deduct_fee',
                            initialValue: _deductFee,
                            title: Text(s.deductFee),
                            onChanged: (v) {
                              _deductFee = v!;
                            })),
                      if (customSendSettings.max)
                        IconButton(
                          onPressed: amountMax,
                          icon: FaIcon(FontAwesomeIcons.maximize),
                        ),
                    ]),
                  Gap(8),
                  InputMemo(_memo,
                      key: memoKey,
                      onChanged: (v) => _memo = v!,
                      custom: custom,
                      hidden: !isShielded || (custom && !customSendSettings.memo)),
                ],
              ),
            ),
          ),
        )));
  }

  List<Widget> _extraAddressButtons(BuildContext context, bool custom,
      {Function(String)? onChanged}) {
    final customSendSettings = appSettings.customSendSettings;
    return [
      if (!custom || customSendSettings.contacts)
        IconButton(
            onPressed: () async {
              final c = await GoRouter.of(context)
                  .push<ContactCardT>('/account/quick_send/contacts');
              c?.let((c) => onChanged?.call(c.address!));
            },
            icon: FaIcon(FontAwesomeIcons.addressBook)),
      Gap(8),
      if (!custom || customSendSettings.accounts)
        IconButton(
            onPressed: () async {
              final a = await GoRouter.of(context)
                  .push<AccountNameT>('/account/quick_send/accounts');
              a?.let((a) {
                final address = warp.getAccountAddress(a.coin, a.id, now(), 7);
                onChanged?.call(address);
              });
            },
            icon: FaIcon(FontAwesomeIcons.users)),
    ];
  }

  amountMax() {
    final spendable = getSpendable(_senderPools, balances);
    formKey.currentState!.fields['deduct_fee']?.setValue(true);
    amountKey.currentState!.setAmount(spendable);
  }

  send() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      final p = PaymentRequestT(
          address: _address,
          amount: _amount,
          memo: _memo);
      GetIt.I.registerSingleton(p);
      if (widget.single) {
        final req = PaymentRequestsT(payments: [p]);
        try {
          final plan = await load(() async => await warp.pay(
                aa.coin,
                aa.id,
                req,
                _senderPools,
                !_deductFee,
                appSettings.anchorOffset,
              ));
          logger.d(plan);
          GoRouter.of(context).push('/account/txplan?tab=account', extra: plan);
        } on String catch (e) {
          showMessageBox2(context, s.error, e);
        }
      } else {
        GoRouter.of(context).pop(p);
      }
    }
  }

  _onAddress(String? v) {
    if (v == null) return;
    final valid = warp.isValidAddressOrUri(aa.coin, v);
    if (valid == 0) return;
    if (valid == 1) {
      _address = v;
      _didUpdateAddress(v);
    } else {
      final puri = warp.parsePaymentURI(aa.coin, v)!;
      final p = puri.payments!.first;
      _didUpdateSendContext(p);
    }
    setState(() {});
  }

  void _didUpdateSendContext(PaymentRequestT payment) {
    _address = payment.address!;
    _amount = payment.amount;
    _memo = payment.memo!;
    addressKey.currentState?.setValue(_address);
    amountKey.currentState?.setAmount(_amount);
    memoKey.currentState?.setMemoBody(_memo);
    _didUpdateAddress(_address);
  }

  _didUpdateAddress(String? address) {
    if (address == null || address.isEmpty) return;
    isTex = false;
    try {
      final receivers = warp.decodeAddress(aa.coin, address);
      isTex = receivers.tex;
      if (isTex) {
        poolKey.currentState?.setPools(1);
        _senderPools = 1;
      }
      isShielded = receivers.sapling != null || receivers.orchard != null;
      final pools = (receivers.transparent != null ? 1 : 0) |
          (receivers.sapling != null ? 2 : 0) |
          (receivers.orchard != null ? 4 : 0);
      recipientPoolsAvailable = pools & coinSettings.receipientPools;
      _recipientPools = recipientPoolsAvailable;
    } on String catch (e) {
      logger.d(e);
    }
  }

  _toggleCustom() {
    setState(() => custom = !custom);
  }
}
