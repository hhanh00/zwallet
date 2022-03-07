import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dualmoneyinput.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';
import 'settings.dart';

class PaymentURIPage extends StatefulWidget {
  final String address;

  PaymentURIPage(String? _address): address = _address ?? active.account.address;

  @override
  PaymentURIState createState() => PaymentURIState();
}

class PaymentURIState extends State<PaymentURIPage> {
  var _memoController = TextEditingController(text: '');
  var qrText = "";
  final _formKey = GlobalKey<FormState>();
  final amountKey = GlobalKey<DualMoneyInputState>();

  @override
  void initState() {
    super.initState();
    qrText = widget.address;
    Future.microtask(() {
      priceStore.fetchCoinPrice(active.coin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final qrSize = getScreenSize(context) / 1.5;

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(title: Text(S.of(context).receive(activeCoin().ticker))),
          body: SingleChildScrollView(
            child: GestureDetector(
                onTap: () { FocusScope.of(context).unfocus(); },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(onTap: _ok, child: QrImage(
                            data: qrText,
                            size: qrSize,
                            backgroundColor: Colors.white)),
                          Padding(padding: EdgeInsets.all(8)),
                          DualMoneyInputWidget(key: amountKey),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: S.of(context).memo),
                            minLines: 4,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: _memoController,
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          ButtonBar(children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.clear),
                              label: Text('RESET'),
                              onPressed: _reset,
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.build),
                              label: Text('MAKE QR'),
                              onPressed: _ok,
                            ),
                          ]),
                        ]))))));
  }

  void _updateQR() {
    final amount = amountKey.currentState!.amount;
    final memo = _memoController.text;

    final String _qrText;
    if (amount > 0) {
      _qrText = WarpApi.makePaymentURI(active.coin, widget.address, amount, memo);
    } else
      _qrText = widget.address;

    setState(() {
      qrText = _qrText;
    });
  }

  void _reset() {
    _memoController.clear();
    amountKey.currentState?.clear();
    setState(() {
      qrText = widget.address;
    });
  }

  void _ok() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      _updateQR();
      FocusScope.of(context).unfocus();
    }
  }
}
