import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp/store.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';

class MultiPayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MultiPayState();
}

class MultiPayState extends State<MultiPayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).multiPay)),
      body: Observer(builder: (context) {
        if (multipayData.recipients.isEmpty) return NoRecipient();
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
            .fold<double>(0.0, (a, b) => a + b) /
        ZECUNIT;
    final count = multipayData.recipients.length;

    final approved = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
            title: Text(S.of(context).pleaseConfirm),
            content: SingleChildScrollView(
                child: Text(S
                    .of(context)
                    .sendingATotalOfAmountCointickerToCountRecipients(
                        amount, coin.ticker, count))),
            actions: confirmButtons(
                context, () => Navigator.of(context).pop(true),
                cancelValue: false)));

    if (approved) {
      final s = S.of(context);
      Navigator.of(context).pop();

      final snackBar1 = SnackBar(content: Text(s.preparingTransaction));
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar1);

      final recipientsJson = jsonEncode(multipayData.recipients);
      final tx = await WarpApi.sendMultiPayment(accountManager.active.id,
          recipientsJson, settings.anchorOffset, (p) {});
      final snackBar2 = SnackBar(content: Text("${s.txId}: $tx"));
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);

      multipayData.clear();
      await accountManager.fetchAccountData(true);
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
  var _currencyController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          labelText:
                              S.of(context).sendCointickerTo(coin.ticker)),
                      controller: _addressController,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline),
                  validator: _checkAddress,
                  onSuggestionSelected: (Contact contact) {
                    _addressController.text = contact.name;
                  },
                  suggestionsCallback: (String pattern) {
                    return contacts.contacts.where((c) =>
                        c.name.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (BuildContext context, Contact c) =>
                      ListTile(title: Text(c.name)),
                  noItemsFoundBuilder: (_) => SizedBox(),
                ),
              ),
              IconButton(
                  icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScan)
            ]),
            TextFormField(
                decoration: InputDecoration(labelText: S.of(context).amount),
                keyboardType: TextInputType.number,
                controller: _currencyController,
                inputFormatters: [makeInputFormatter(true)],
                validator: _checkAmount),
            TextFormField(
              decoration: InputDecoration(labelText: S.of(context).memo),
              minLines: 4,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _memoController,
            ),
            ButtonBar(
                children: confirmButtons(context, _onAdd,
                    okLabel: S.of(context).add, okIcon: Icon(MdiIcons.plus)))
          ]),
        ));
  }

  void _onScan() async {
    final address = await scanCode(context);
    if (address != null)
      setState(() {
        _addressController.text = address;
      });
  }

  void _onAdd() {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      _amount = Decimal.parse(parseNumber(_currencyController.text).toString());
      final c =
          contacts.contacts.where((c) => c.name == _addressController.text);
      final address =
          c.isEmpty ? unwrapUA(_addressController.text) : c.first.address;
      final r = Recipient(
          address, (_amount * ZECUNIT_DECIMAL).toInt(), _memoController.text);
      Navigator.of(context).pop(r);
    }
  }

  String? _checkAddress(String? v) {
    if (v == null || v.isEmpty) return S.of(context).addressIsEmpty;
    final c = contacts.contacts.where((c) => c.name == v);
    if (c.isNotEmpty) return null;
    final zaddr = WarpApi.getSaplingFromUA(v);
    if (zaddr.isNotEmpty) return null;
    if (!WarpApi.validAddress(v)) return S.of(context).invalidAddress;
    return null;
  }

  String? _checkAmount(String? vs) {
    if (vs == null) return S.of(context).amountMustBeANumber;
    if (checkNumber(vs)) return S.of(context).amountMustBeANumber;
    final v = parseNumber(vs);
    if (v <= 0.0) return S.of(context).amountMustBePositive;
    return null;
  }
}

class NoRecipient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget contact = SvgPicture.asset('assets/multipay.svg',
        color: Theme.of(context).primaryColor, semanticsLabel: 'Contacts');

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(child: contact, height: 150, width: 150),
      Padding(padding: EdgeInsets.symmetric(vertical: 16)),
      Text(S.of(context).noRecipient,
          style: Theme.of(context).textTheme.headline5),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      Text(S.of(context).addARecipientAndItWillShowHere,
          style: Theme.of(context).textTheme.bodyText1),
    ]));
  }
}
