import 'dart:isolate';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/warp_api.dart';
import 'package:decimal/decimal.dart';
import 'dart:math' as math;

import 'main.dart';
import 'store.dart';

class SendPage extends StatefulWidget {
  SendPage();

  @override
  SendState createState() => SendState();
}

class SendState extends State<SendPage> {
  final _formKey = GlobalKey<FormState>();
  var _address = "";
  var _amount = Decimal.zero;
  var _maxAmountPerNote = Decimal.zero;
  var _balance = 0;
  final _addressController = TextEditingController();
  var _mZEC = true;
  var _currencyController = _makeMoneyMaskedTextController(true);
  var _maxAmountPerNoteController = _makeMoneyMaskedTextController(true);
  var _includeFee = false;
  var _isExpanded = false;

  @override
  initState() {
    Future.microtask(() async {
      final balance = await accountManager
          .getBalanceSpendable(syncStatus.latestHeight - settings.anchorOffset);
      setState(() {
        _balance = math.max(balance - DEFAULT_FEE, 0);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Send ZEC')),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Send ZEC to...'),
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _addressController,
                        onSaved: _onAddress,
                        validator: _checkAddress,
                      ),
                    ),
                    IconButton(
                        icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScan)
                  ]),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            controller: _currencyController,
                            validator: _checkAmount,
                            onSaved: _onAmount)),
                    TextButton(child: Text('MAX'), onPressed: _onMax),
                  ]),
                  ExpansionPanelList(
                      expansionCallback: (_, isExpanded) {
                        setState(() {
                          _isExpanded = !isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                            headerBuilder: (_, __) =>
                                ListTile(title: Text('Advanced Options')),
                            body: Column(children: [
                              CheckboxListTile(
                                  title: Text('Round to mZEC'),
                                  value: _mZEC,
                                  onChanged: _onChangedmZEC),
                              CheckboxListTile(
                                  title: Text('Include Fee in Amount'),
                                  value: _includeFee,
                                  onChanged: _onChangedIncludeFee),
                              ListTile(
                                  title: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Max Amount per Note'),
                                keyboardType: TextInputType.number,
                                controller: _maxAmountPerNoteController,
                                validator: _checkMaxAmountPerNote,
                                onSaved: _onSavedMaxAmountPerNote,
                              ))
                            ]),
                            isExpanded: _isExpanded)
                      ]),
                  Padding(padding: EdgeInsets.all(8)),
                  Text("Spendable: ${_balance / ZECUNIT} ZEC"),
                  ButtonBar(children: [
                    IconButton(
                        icon: new Icon(MdiIcons.cancel), onPressed: _onCancel),
                    IconButton(
                        icon: new Icon(MdiIcons.send), onPressed: _onSend),
                  ])
                ]))));
  }

  String _checkAddress(String v) {
    if (v.isEmpty) return 'Address is empty';
    if (!WarpApi.validAddress(v)) return 'Invalid Address';
    return null;
  }

  String _checkAmount(String vs) {
    final v = double.tryParse(vs);
    if (v == null) return 'Amount must be a number';
    if (v <= 0.0) return 'Amount must be positive';
    if (v > _balance) return 'Not enough balance';
    return null;
  }

  String _checkMaxAmountPerNote(String vs) {
    final v = double.tryParse(vs);
    if (v == null) return 'Amount must be a number';
    if (v < 0.0) return 'Amount must be positive';
    return null;
  }

  void _onMax() {
    setState(() {
      _mZEC = false;
      _currencyController = _makeMoneyMaskedTextController(false);
      _includeFee = false;
      _currencyController.updateValue(
          (Decimal.fromInt(_balance) / ZECUNIT_DECIMAL).toDouble());
    });
  }

  void _onChangedIncludeFee(bool v) {
    setState(() {
      _includeFee = v;
    });
  }

  void _onChangedmZEC(bool v) {
    setState(() {
      _mZEC = v;
      final amount = _currencyController.numberValue;
      _currencyController = _makeMoneyMaskedTextController(v);
      _currencyController.updateValue(amount);
      _maxAmountPerNoteController = _makeMoneyMaskedTextController(v);
    });
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onScan() async {
    var code = await BarcodeScanner.scan();
    setState(() {
      _address = code.rawContent;
      _addressController.text = _address;
    });
  }

  void _onAmount(v) {
    _amount = Decimal.parse(v);
  }

  void _onAddress(v) {
    _address = v;
  }

  void _onSavedMaxAmountPerNote(v) {
    _maxAmountPerNote = Decimal.parse(v);
  }

  void _onSend() async {
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final approved = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Please Confirm'),
                content: SingleChildScrollView(
                    child: Text("Sending $_amount ZEC to $_address")),
                actions: <Widget>[
                  TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                  TextButton(
                      child: Text('Approve'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }),
                ],
              ));
      if (approved) {
        Navigator.of(context).pop();
        final snackBar1 = SnackBar(content: Text("Preparing transaction..."));
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBar1);

        int amount = (_amount * ZECUNIT_DECIMAL).toInt();
        if (_includeFee) amount -= DEFAULT_FEE;
        int maxAmountPerNote = (_maxAmountPerNote * ZECUNIT_DECIMAL).toInt();
        final tx = await compute(
            sendPayment,
            SendPaymentParam(
                accountManager.active.id,
                _address,
                amount,
                maxAmountPerNote,
                settings.anchorOffset,
                progressPort.sendPort));

        final snackBar2 = SnackBar(content: Text("TX ID: $tx"));
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBar2);
      }
    }
  }

  static MoneyMaskedTextController _makeMoneyMaskedTextController(bool mZEC) =>
      MoneyMaskedTextController(
          decimalSeparator: '.',
          thousandSeparator: ',',
          precision: mZEC ? 3 : 8);
}

class SendPaymentParam {
  int account;
  String address;
  int amount;
  int maxAmountPerNote;
  int anchorOffset;
  SendPort sendPort;

  SendPaymentParam(this.account, this.address, this.amount,
      this.maxAmountPerNote, this.anchorOffset, this.sendPort);
}

sendPayment(SendPaymentParam param) async {
  param.sendPort.send(0);
  final tx = await WarpApi.sendPayment(param.account, param.address,
      param.amount, param.maxAmountPerNote, param.anchorOffset, (percent) {
    param.sendPort.send(percent);
  });
  param.sendPort.send(0);
  return tx;
}
