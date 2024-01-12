import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../main.dart';
import '../../accounts.dart';
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';
import '../widgets.dart';

class SendContext {
  final String address;
  final int pools;
  final Amount amount;
  final MemoData? memo;
  SendContext(this.address, this.pools, this.amount, this.memo);
  static SendContext? fromPaymentURI(String puri) {
    final p = WarpApi.decodePaymentURI(aa.coin, puri);
    if (p == null) throw S.of(navigatorKey.currentContext!).invalidPaymentURI;
    return SendContext(
        p.address!, 7, Amount(p.amount, false), MemoData(false, '', p.memo!));
  }

  static SendContext? instance;
}

class QuickSendPage extends StatefulWidget {
  final SendContext? sendContext;
  final bool custom;
  final bool single;
  QuickSendPage({this.sendContext, this.custom = false, this.single = true});

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
  late Amount _amount = widget.sendContext?.amount ?? Amount(0, false);
  late MemoData _memo = widget.sendContext?.memo ??
      MemoData(appSettings.includeReplyTo != 0, '', appSettings.memo);

  @override
  Widget build(BuildContext context) {
    final customSendSettings = appSettings.customSendSettings;
    final spendable = getSpendable(_pools, balances);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.send),
          actions: [
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
                    validator:
                        composeOr([addressValidator, paymentURIValidator]),
                    buttonsBuilder: (context, {Function(String)? onChanged}) =>
                        _extraAddressButtons(
                      context,
                      widget.custom,
                      onChanged: onChanged,
                    ),
                  ),
                  Gap(8),
                  if (widget.single && widget.custom && customSendSettings.pools)
                    PoolSelection(
                      _pools,
                      balances: aa.poolBalances,
                      onChanged: (v) => setState(() => _pools = v!),
                    ),
                  Gap(8),
                  AmountPicker(
                    _amount,
                    key: amountKey,
                    spendable: spendable,
                    onChanged: (a) => _amount = a!,
                    canDeductFee: widget.single,
                    custom: widget.custom,
                  ),
                  Gap(8),
                  if (isShielded && customSendSettings.memo)
                    InputMemo(
                      _memo,
                      key: memoKey,
                      onChanged: (v) => _memo = v!,
                      custom: widget.custom,
                    ),
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
                  .push<Contact>('/account/quick_send/contacts');
              c?.let((c) => onChanged?.call(c.address!));
            },
            icon: FaIcon(FontAwesomeIcons.addressBook)),
      Gap(8),
      if (!custom || customSendSettings.accounts)
        IconButton(
            onPressed: () async {
              final a = await GoRouter.of(context)
                  .push<Account>('/account/quick_send/accounts');
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
          'send $_address $_amount $_pools ${_memo.reply} ${_memo.subject} ${_memo.memo}');
      final sc = SendContext(_address, _pools, _amount, _memo);
      SendContext.instance = sc;
      final builder = RecipientObjectBuilder(
        address: _address,
        amount: _amount.value,
        feeIncluded: _amount.deductFee,
        replyTo: _memo.reply,
        subject: _memo.subject,
        memo: _memo.memo,
      );
      final recipient = Recipient(builder.toBytes());
      if (widget.single) {
        try {
          final plan = await load(() => WarpApi.prepareTx(
                aa.coin,
                aa.id,
                [recipient],
                _pools,
                coinSettings.replyUa,
                appSettings.anchorOffset,
                coinSettings.feeT,
                coinSettings.zFactor,
              ));
          GoRouter.of(context).push('/account/txplan?tab=account', extra: plan);
        } on String catch (e) {
          showMessageBox2(context, s.error, e);
        }
      } else {
        GoRouter.of(context).pop(recipient);
      }
    }
  }

  _onAddress(String? v) {
    if (v == null) return;
    final puri = WarpApi.decodePaymentURI(aa.coin, v);
    if (puri != null) {
      logger.d('$puri');
      addressKey.currentState!.setValue(puri.address!);
      amountKey.currentState!.setAmount(puri.amount);
      memoKey.currentState!.setMemoBody(puri.memo!);
    } else
      _address = v;
    setState(() {});
  }

  bool get isShielded {
    final address = addressKey.currentState?.controller.text;
    return address.isNotEmptyAndNotNull &&
        WarpApi.receiversOfAddress(aa.coin, address!) != 1;
  }
}
