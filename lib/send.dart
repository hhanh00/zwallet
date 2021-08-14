import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/warp_api.dart';
import 'package:decimal/decimal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;

import 'main.dart';
import 'store.dart';

class SendPage extends StatefulWidget {
  final Contact contact;

  SendPage(this.contact);

  @override
  SendState createState() => SendState();
}

class SendState extends State<SendPage> {
  final _formKey = GlobalKey<FormState>();
  var _address = "";
  var _amount = 0;
  var _maxAmountPerNote = Decimal.zero;
  var _balance = 0;
  final _addressController = TextEditingController();
  final _memoController = TextEditingController();
  final _otherAmountController = TextEditingController();
  var _mZEC = true;
  var _useFX = false;
  var _currencyController = _makeMoneyMaskedTextController(true);
  var _maxAmountPerNoteController = _makeMoneyMaskedTextController(true);
  var _includeFee = false;
  var _isExpanded = false;
  ReactionDisposer _priceAutorunDispose;

  @override
  initState() {
    if (widget.contact != null)
      _addressController.text = widget.contact.address;
    Future.microtask(() async {
      final balance = await accountManager
          .getBalanceSpendable(syncStatus.latestHeight - settings.anchorOffset);
      setState(() {
        _balance = math.max(balance - DEFAULT_FEE, 0);
      });
    });
    _updateOtherAmount();
    super.initState();

    _priceAutorunDispose = autorun((_) {
      final price = priceStore.zecPrice;
      _updateOtherAmount();
    });
  }

  @override
  void dispose() {
    _priceAutorunDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Send ${coin.ticker}')),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Send ${coin.ticker} to...'),
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
                            decoration:
                                InputDecoration(labelText: thisAmountLabel()),
                            keyboardType: TextInputType.number,
                            controller: _currencyController,
                            validator: _checkAmount,
                            onChanged: (_) { _updateOtherAmount(); },
                            onSaved: _onAmount)),
                    TextButton(child: Text('MAX'), onPressed: _onMax),
                  ]),
                  Row(children: [
                    Expanded(
                          child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: otherAmountLabel()),
                            controller: _otherAmountController,
                              ),
                    ),
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
                              ListTile(
                                  title: TextFormField(
                                decoration: InputDecoration(labelText: 'Memo'),
                                minLines: 4,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: _memoController,
                              )),
                              CheckboxListTile(
                                  title: Text('Round to millis'),
                                  value: _mZEC,
                                  onChanged: _onChangedmZEC),
                              Observer(builder: (context) => CheckboxListTile(
                                  title: Text('Use ${settings.currency}'),
                                  value: _useFX,
                                  onChanged: _onChangedUseFX)),
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
                              )),
                            ]),
                            isExpanded: _isExpanded)
                      ]),
                  Padding(padding: EdgeInsets.all(8)),
                  Text("Spendable: ${_balance / ZECUNIT} ${coin.ticker}"),
                  ButtonBar(
                      children: confirmButtons(context, _onSend, okLabel: 'SEND', okIcon: Icon(MdiIcons.send)))
                ]))));
  }

  String _checkAddress(String v) {
    if (v.isEmpty) return 'Address is empty';
    if (!WarpApi.validAddress(v)) return 'Invalid Address';
    return null;
  }

  String _checkAmount(String vs) {
    final vss = vs.replaceAll(',', '');
    final v = double.tryParse(vss);
    if (v == null) return 'Amount must be a number';
    if (v <= 0.0) return 'Amount must be positive';
    if (amountInZAT(Decimal.parse(vss)) > _balance) return 'Not enough balance';
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
      _useFX = false;
      _currencyController = _makeMoneyMaskedTextController(false);
      _includeFee = false;
      _currencyController.updateValue(
          (Decimal.fromInt(_balance) / ZECUNIT_DECIMAL).toDouble());
      _updateOtherAmount();
    });
  }

  void _onChangedIncludeFee(bool v) {
    setState(() {
      _includeFee = v;
    });
  }

  void _onChangedUseFX(bool v) {
    setState(() {
      _useFX = v;
      _currencyController
          .updateValue(double.parse(_otherAmountController.text));
      _updateOtherAmount();
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

  void _onScan() async {
    var code = await BarcodeScanner.scan();
    setState(() {
      _address = code.rawContent;
      _addressController.text = _address;
    });
  }

  void _onAmount(String vs) {
    final vss = vs.replaceAll(',', '');
    _amount = amountInZAT(Decimal.parse(vss));
  }

  void _onAddress(v) {
    _address = v;
  }

  void _onSavedMaxAmountPerNote(v) {
    _maxAmountPerNote = Decimal.parse(v);
  }

  void _updateOtherAmount() {
    final price = _fx().toDouble();
    final amount = _currencyController.numberValue;
    final otherAmount = (_useFX) ? (amount / price).toStringAsFixed(8) : (amount * price).toStringAsFixed(8);
    _otherAmountController.text = otherAmount;
  }

  void _onSend() async {
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final aZEC = (Decimal.fromInt(_amount) / ZECUNIT_DECIMAL).toString();
      final approved = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Please Confirm'),
                content: SingleChildScrollView(
                    child: Text("Sending $aZEC ${coin.ticker} to $_address")),
                actions: confirmButtons(context, () => Navigator.of(context).pop(true), okLabel: 'APPROVE', cancelValue: false)
              ));
      if (approved) {
        Navigator.of(context).pop();
        final snackBar1 = SnackBar(content: Text("Preparing transaction..."));
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBar1);

        if (_includeFee) _amount -= DEFAULT_FEE;
        int maxAmountPerNote = (_maxAmountPerNote * ZECUNIT_DECIMAL).toInt();
        final memo = _memoController.text;

        if (accountManager.canPay) {
          final tx = await compute(
              sendPayment,
              PaymentParams(
                  accountManager.active.id,
                  _address,
                  _amount,
                  memo,
                  maxAmountPerNote,
                  settings.anchorOffset,
                  progressPort.sendPort));

          final snackBar2 = SnackBar(content: Text("TX ID: $tx"));
          rootScaffoldMessengerKey.currentState.showSnackBar(snackBar2);
        } else {
          Directory tempDir = await getTemporaryDirectory();
          String filename = "${tempDir.path}/tx.json";

          final msg = WarpApi.prepareTx(accountManager.active.id, _address, _amount, memo,
              maxAmountPerNote, settings.anchorOffset, filename);

          Share.shareFiles([filename], subject: "Unsigned Transaction File");

          final snackBar2 = SnackBar(content: Text(msg));
          rootScaffoldMessengerKey.currentState.showSnackBar(snackBar2);
        }
      }
    }
  }

  static MoneyMaskedTextController _makeMoneyMaskedTextController(bool mZEC) =>
      MoneyMaskedTextController(
          decimalSeparator: '.',
          thousandSeparator: ',',
          precision: mZEC ? 3 : 8);

  String thisAmountLabel() => _useFX ? "Amount in ${settings.currency}" : "Amount in ${coin.ticker}";

  String otherAmountLabel() => _useFX ? "Amount in ${coin.ticker}" : "Amount in ${settings.currency}";

  int amountInZAT(Decimal v) => _useFX
      ? (v / _fx() * ZECUNIT_DECIMAL).toInt()
      : (v * ZECUNIT_DECIMAL).toInt();

  Decimal _fx() { return Decimal.parse("${priceStore.zecPrice}"); }
}

sendPayment(PaymentParams param) async {
  param.port.send(0);
  final tx = await WarpApi.sendPayment(
      param.account,
      param.address,
      param.amount,
      param.memo,
      param.maxAmountPerNote,
      param.anchorOffset, (percent) {
    param.port.send(percent);
  });
  param.port.send(0);
  return tx;
}
