import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:collection/collection.dart';

import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../main/qr_address.dart';
import '../settings.dart';
import '../widgets.dart';

class PaymentURIPage extends StatefulWidget {
  final int amount;
  PaymentURIPage({this.amount = 0});

  @override
  State<StatefulWidget> createState() => _PaymentURIState();
}

class _PaymentURIState extends State<PaymentURIPage> {
  late int amount;
  int receivers = appSettings.uaType;
  final memoController = TextEditingController();
  final inputKey = GlobalKey<InputAmountState>();

  @override
  void initState() {
    super.initState();
    amount = widget.amount;
  }

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
                uaType: receivers,
                amount: amount,
                memo: memoController.text,
                paymentURI: false,
              ),
              FieldUACheckbox(
                appSettings.uaType,
                label: s.receivers,
                name: 'receivers',
                onChanged: (v) {
                  receivers = v?.sum ?? 0;
                  setState(() {});
                },
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
