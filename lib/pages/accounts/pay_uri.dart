import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../generated/intl/messages.dart';
import '../input_widgets.dart';
import '../main/qr_address.dart';

class PaymentURIPage extends StatefulWidget {
  final int amount;
  PaymentURIPage({this.amount = 0});

  @override
  State<StatefulWidget> createState() => _PaymentURIState();
}

class _PaymentURIState extends State<PaymentURIPage> {
  late int amount = widget.amount;
  String memo = '';
  final memoController = TextEditingController();
  String address = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.paymentURI)),
        body: SingleChildScrollView(
          child: FormBuilder(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  AddressCarousel(
                    key: ValueKey('$amount:$memo'),
                    amount: amount,
                    memo: memo,
                    onChanged: (a) => address = a!,
                    onQRPressed: () {
                      GoRouter.of(context).push(
                        '/showqr?title=$memo',
                        extra: address,
                      );
                    },
                  ),
                  AmountPicker(amount, name: 'amount', onChanged: onAmount),
                  FormBuilderTextField(
                    name: 'memo',
                    decoration: InputDecoration(label: Text(s.memo)),
                    controller: memoController,
                    onChanged: onMemo,
                    enableSuggestions: true,
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  onAmount(int? a) {
    EasyDebounce.debounce('uri', Duration(seconds: 1), () {
      setState(() {
        amount = a ?? 0;
      });
    });
  }

  onMemo(String? m) {
    EasyDebounce.debounce('uri', Duration(seconds: 1), () {
      setState(() {
        memo = m ?? '';
      });
    });
  }
}
