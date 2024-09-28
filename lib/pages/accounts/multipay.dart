import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../utils.dart';
import '../widgets.dart';
import '../../accounts.dart';
import '../../generated/intl/messages.dart';

class MultiPayPage extends StatefulWidget {
  final PaymentRequestT? payment;
  MultiPayPage(this.payment);

  @override
  State<StatefulWidget> createState() => _MultiPayState();
}

class _MultiPayState extends State<MultiPayPage> {
  late final S s = S.of(context);
  late PaymentRequestT payment =
      widget.payment ?? PaymentRequestExtension.empty();
  int? selected;
  bool waiting = false;

  @override
  Widget build(BuildContext context) {
    final recipients = payment.recipients!;
    return Scaffold(
      appBar: AppBar(title: Text(s.multiPay), actions: [
        selected == null
            ? IconButton(onPressed: add, icon: Icon(Icons.add))
            : IconButton(onPressed: delete, icon: Icon(Icons.delete)),
        if (recipients.isNotEmpty) 
          IconButton(onPressed: qr, icon: Icon(Icons.qr_code)),
        if (recipients.isNotEmpty) 
          IconButton(onPressed: send, icon: Icon(Icons.send)),
      ]),
      body: LoadingWrapper(
        waiting,
        child: ListView.separated(
          itemBuilder: (context, index) => GestureDetector(
              onTap: () => select(index),
              child: MultiPayRecipient(recipients[index],
                  selected: selected == index)),
          separatorBuilder: (context, index) => Divider(),
          itemCount: recipients.length,
        ),
      ),
    );
  }

  select(int index) {
    if (selected == index)
      selected = null;
    else
      selected = index;
    setState(() {});
  }

  add() async {
    final p = await GoRouter.of(context)
        .push<PaymentRequestT>('/account/multi_pay/new');
    if (p != null) payment.recipients!.addAll(p.recipients!);
  }

  edit() {}
  delete() async {
    final s = S.of(context);
    final confirmed =
        await showConfirmDialog(context, s.delete, s.deletePayment);
    if (confirmed) {
      payment.recipients!.removeAt(selected!);
      selected = null;
      setState(() {});
    }
  }

  send() async {
    final s = S.of(context);
    try {
      _calculating(true);
      final txPlan = await warp.pay(
        aa.coin,
        aa.id,
        payment,
      );
      GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
    } on String catch (e) {
      await showMessageBox(context, s.error, e);
    } finally {
      _calculating(false);
    }
  }

  qr() {
    final qr = warp.makePaymentURI(aa.coin, payment);
    GoRouter.of(context).push('/showqr', extra: qr);
  }

  _calculating(bool v) {
    if (mounted) setState(() => waiting = v);
  }
}

class MultiPayRecipient extends StatelessWidget {
  final RecipientT recipient;
  final bool selected;
  MultiPayRecipient(this.recipient, {super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ListTile(
      title: Text(recipient.address!),
      subtitle: Text(recipient.memo?.body ?? ''),
      trailing: Text(amountToString(recipient.amount)),
      selected: selected,
      selectedTileColor: t.colorScheme.inversePrimary,
    );
  }
}
