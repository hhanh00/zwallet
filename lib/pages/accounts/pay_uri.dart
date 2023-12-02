import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../main/home.dart';
import '../main/qr_address.dart';
import '../utils.dart';
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
  int addressMode = coins[aa.coin].defaultAddrMode;
  final availableMode = WarpApi.getAvailableAddrs(aa.coin, aa.id);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.paymentURI)),
      body: SingleChildScrollView(
        child: FormBuilder(
          child: Padding(padding: EdgeInsets.all(16),
          child: Column(
            children: [
              QRAddressWidget(
                addressMode,
                uaType: coinSettings.uaType,
                amount: amount,
                memo: memoController.text,
                paymentURI: false,
              ),
              AmountPicker(Amount(amount, false), onChanged: onAmount, canDeductFee: false),
              FormBuilderTextField(
                name: 'memo',
                decoration: InputDecoration(label: Text(s.memo)),
                controller: memoController,
                onChanged: (_) => onMemo(),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  onAmount(Amount? a) {
    EasyDebounce.debounce('payment_uri', Duration(milliseconds: 500), () {
      amount = a!.value;
      setState(() {});
    });
  }

  onMemo() {
    EasyDebounce.debounce('payment_uri', Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  onMode() {
    setState(() => addressMode = nextAddressMode(addressMode, availableMode));
  }
}
