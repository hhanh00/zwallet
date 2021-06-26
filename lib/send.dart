import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';

class SendPage extends StatefulWidget {
  SendPage();

  @override
  SendState createState() => SendState();
}

class SendState extends State<SendPage> {
  final _formKey = GlobalKey<FormState>();
  var _address = "";
  var _amount = 0.0;
  var _balance = 0;
  final _addressController = TextEditingController();
  final _currencyController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', precision: 3);

  @override
  initState() {
    Future.microtask(() async {
      final balance = await accountManager.getBalanceSpendable(syncStatus.latestHeight - 10);
      setState(() {
        _balance = balance;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_address);
    return Scaffold(
      appBar: AppBar(title: Text('Send ZEC')),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: TextFormField(
                    decoration: InputDecoration(labelText: 'Send ZEC to...'),
                    minLines: 4, maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _addressController,
                    onSaved: onAddress,
                    validator: checkAddress,
                    ),
                  ),
                  IconButton(icon: new Icon(MdiIcons.qrcodeScan), onPressed: onScan)
                ]
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _currencyController,
                validator: checkAmount,
                onSaved: onAmount
              ),
              Padding(padding: EdgeInsets.all(8)),
              Text("Spendable: ${_balance / ZECUNIT } ZEC"),
              ButtonBar(
                children: [
                  IconButton(icon: new Icon(MdiIcons.send), onPressed: onSend),
                  IconButton(icon: new Icon(MdiIcons.cancel), onPressed: onCancel)
                ]
              )
            ]
          )
        )
      )
    );
  }

  String checkAddress(String v) {
    if (v.isEmpty) return 'Address is empty';
    if (!WarpApi.validAddress(v)) return 'Invalid Address';
    return null;
  }

  String checkAmount(String vs) {
    final v = double.tryParse(vs);
    if (v == null) return 'Amount must be a number';
    if (v <= 0.0) return 'Amount must be positive';
    if (v > _balance) return 'Not enough balance';
    return null;
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void onScan() async {
    var code = await BarcodeScanner.scan();
    setState(() {
      _address = code.rawContent;
      _addressController.text = _address;
    });
  }

  void onAmount(v) {
    _amount = double.parse(v);
  }

  void onAddress(v) {
    _address = v;
  }

  void onSend() async {
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final approved = await showDialog(context: context, barrierDismissible: false,
        builder: (BuildContext context) =>
          AlertDialog(title: Text('Please Confirm'),
            content: SingleChildScrollView(
              child: Text("Sending $_amount ZEC to $_address")
            ),
            actions: <Widget>[
              TextButton(child: Text('Cancel'), onPressed: () {Navigator.of(context).pop(false);}),
              TextButton(child: Text('Approve'), onPressed: () {Navigator.of(context).pop(true);}),
            ],
          )
      );
      if (approved) {
        Navigator.of(context).pop();
        final snackBar1 = SnackBar(
            content: Text("Preparing transaction..."));
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBar1);

        final amount = (_amount * ZECUNIT).toInt();
        final tx = await compute(sendPayment, SendPaymentParam(accountManager.active.id, _address, amount));

        final snackBar2 = SnackBar(
            content: Text("TX ID: $tx"));
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBar2);
      }
    }
  }
}

class SendPaymentParam {
  int account;
  String address;
  int amount;

  SendPaymentParam(this.account, this.address, this.amount);
}

sendPayment(SendPaymentParam param) {
  final tx = WarpApi.sendPayment(param.account, param.address, param.amount);
  return tx;
}
