import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../main/qr_address.dart';
import '../widgets.dart';

class PaymentURIPage extends StatefulWidget {
  final int amount;
  PaymentURIPage({this.amount = 0});

  @override
  State<StatefulWidget> createState() => _PaymentURIState();
}

class _PaymentURIState extends State<PaymentURIPage> {
  late int amount = widget.amount;
  final memoController = TextEditingController();
  final inputKey = GlobalKey<InputAmountState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final a = AmountState(amount: amount);
    return Scaffold(
      appBar: AppBar(title: Text(s.paymentURI)),
      body: SingleChildScrollView(
        child: FormBuilder(
          child: Column(
            children: [
              QRAddressWidget(
                uaType: coinSettings.uaType,
                amount: amount,
                memo: memoController.text,
                paymentURI: false,
              ),
              InputAmountWidget(a, key: inputKey, onChange: onAmount),
              FormBuilderTextField(
                name: 'memo',
                decoration: InputDecoration(label: Text(s.memo)),
                controller: memoController,
                onChanged: (_) => setState(() {}),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onAmount(int a) {
    EasyDebounce.debounce('payment_uri', Duration(milliseconds: 500), () {
      amount = a;
      setState(() {});
    });
  }
}
