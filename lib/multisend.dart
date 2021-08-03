import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp/store.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';

class MultiPayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MultiPayState();
}

class MultiPayState extends State<MultiPayPage> {
  final _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi Pay')),
      body: Observer(builder: (context) {
        final rows = multipayData.recipients.asMap().entries.map((e) {
          final index = e.key;
          final recipient = e.value;
          final amount = recipient.amount / ZECUNIT;
          return Dismissible(
            key: UniqueKey(),
            child: ListTile(
                title: Text(recipient.address), subtitle: Text("$amount")),
            onDismissed: (_) {
              _remove(index);
            },
          );
        }).toList();
        return ListView(children: rows);
      }),
      bottomNavigationBar: BottomAppBar(
          child: Row(children: [
        IconButton(onPressed: _add, icon: Icon(Icons.add)),
        Spacer(),
        IconButton(onPressed: _send, icon: Icon(Icons.send)),
      ])),
    );
  }

  _add() async {
    final r = await showDialog<Recipient>(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              child: PayRecipient(),
            ));
    if (r != null) {
      multipayData.addRecipient(r);
    }
  }

  _remove(int index) {
    multipayData.removeRecipient(index);
  }

  _send() async {
    final amount = multipayData.recipients
            .map((r) => r.amount)
            .fold(0.0, (a, b) => a + b) /
        ZECUNIT;
    final count = multipayData.recipients.length;

    final approved = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Please Confirm'),
              content: SingleChildScrollView(
                  child: Text(
                      "Sending a total of $amount ZEC to $count recipients")),
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
      final snackBar1 = SnackBar(content: Text("Preparing transaction..."));
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBar1);

      final recipientsJson = jsonEncode(multipayData.recipients);
      final tx = await WarpApi.sendMultiPayment(accountManager.active.id,
          recipientsJson, settings.anchorOffset, (p) {});
      final snackBar2 = SnackBar(content: Text("TX ID: $tx"));
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBar2);

      multipayData.clear();
      Navigator.of(context).pop();
    }
  }
}

class PayRecipient extends StatefulWidget {
  PayRecipient();

  @override
  State<StatefulWidget> createState() => PayRecipientState();
}

class PayRecipientState extends State<PayRecipient> {
  final _formKey = GlobalKey<FormState>();
  var _amount = Decimal.zero;
  final _addressController = TextEditingController();
  var _currencyController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Send ZEC to...'),
                  minLines: 4,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _addressController,
                  validator: _checkAddress,
                ),
              ),
              IconButton(
                  icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScan)
            ]),
            TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _currencyController,
                validator: _checkAmount),
            ButtonBar(children: [
              IconButton(icon: new Icon(MdiIcons.cancel), onPressed: _onCancel),
              IconButton(icon: new Icon(MdiIcons.plus), onPressed: _onAdd),
            ])
          ]),
        ));
  }

  void _onScan() async {
    var code = await BarcodeScanner.scan();
    setState(() {
      final address = code.rawContent;
      _addressController.text = address;
    });
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onAdd() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _amount = Decimal.parse(_currencyController.text.replaceAll(',', ''));
      final r = Recipient(
          _addressController.text, (_amount * ZECUNIT_DECIMAL).toInt(), "");
      Navigator.of(context).pop(r);
    }
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
    return null;
  }
}
