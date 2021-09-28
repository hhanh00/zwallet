import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';

class PaymentURIPage extends StatefulWidget {
  final String address;

  PaymentURIPage(this.address);

  @override
  PaymentURIState createState() => PaymentURIState();
}

class PaymentURIState extends State<PaymentURIPage> {
  var _amountController = TextEditingController(text: '');
  var _memoController = TextEditingController(text: '');
  var qrText = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    qrText = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    final qrSize = getScreenSize(context) / 1.5;

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: GestureDetector(
                onTap: () { FocusScope.of(context).unfocus(); },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).receivePayment,
                              style: Theme.of(context).textTheme.headline5),
                          Padding(padding: EdgeInsets.all(8)),
                          QrImage(
                              data: qrText,
                              size: qrSize,
                              backgroundColor: Colors.white),
                          Padding(padding: EdgeInsets.all(8)),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Amount Requested'),
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [makeInputFormatter(true)],
                            validator: _checkAmount,
                          ),
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
                              icon: Icon(Icons.build),
                              label: Text('MAKE QR'),
                              onPressed: _ok,
                            ),
                          ]),
                        ])))));
  }

  String? _checkAmount(String? vs) {
    if (vs == null || vs.isEmpty) return null;
    if (!checkNumber(vs)) return S.of(context).amountMustBeANumber;
    final a = parseNumber(vs);
    if (a >= MAXMONEY) return S.of(context).amountTooHigh;
    return null;
  }

  void _updateQR() {
    final amount = _amountController.text;
    final memo = _memoController.text;

    final String _qrText;
    if (amount.isNotEmpty) {
      final a = (Decimal.parse(amount) * ZECUNIT_DECIMAL).toInt();
      _qrText = WarpApi.makePaymentURI(widget.address, a, memo);
    } else
      _qrText = widget.address;

    setState(() {
      qrText = _qrText;
    });
  }

  void _ok() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      _updateQR();
    }
  }
}
