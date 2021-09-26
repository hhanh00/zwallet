import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/warp_api.dart';
import 'package:decimal/decimal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math' as math;

import 'main.dart';
import 'store.dart';
import 'generated/l10n.dart';

class SendPage extends StatefulWidget {
  final Contact? contact;

  SendPage(this.contact);

  @override
  SendState createState() => SendState();
}

class SendState extends State<SendPage> {
  static final zero = decimalFormat(0, 3);
  final _formKey = GlobalKey<FormState>();
  var _address = "";
  var _amount = 0;
  var _maxAmountPerNote = Decimal.zero;
  var _balance = 0;
  final _addressController = TextEditingController();
  final _memoController = TextEditingController();
  var _mZEC = true;
  var _inputInZEC = true;
  var _zecAmountController = TextEditingController(text: zero);
  var _fiatAmountController = TextEditingController(text: zero);
  final _maxAmountController = TextEditingController(text: zero);
  var _includeFee = false;
  var _isExpanded = false;
  var _shieldTransparent = settings.shieldBalance;
  ReactionDisposer? _priceAutorunDispose;

  @override
  initState() {
    if (widget.contact != null)
      _addressController.text = widget.contact!.address;
    Future.microtask(() async {
      final balance = await accountManager
          .getBalanceSpendable(syncStatus.latestHeight - settings.anchorOffset);
      setState(() {
        _balance = math.max(balance - DEFAULT_FEE, 0);
      });
    });
    _updateFiatAmount();
    super.initState();

    _priceAutorunDispose = autorun((_) {
      _updateFiatAmount();
    });
  }

  @override
  void dispose() {
    _priceAutorunDispose!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.sendCointicker(coin.ticker))),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _addressController,
                              decoration: InputDecoration(
                                  labelText: s.sendCointickerTo(coin.ticker)),
                              minLines: 4,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                            ),
                            onSaved: _onAddress,
                            validator: _checkAddress,
                            onSuggestionSelected: (Contact contact) {
                              _addressController.text = contact.name;
                            },
                            suggestionsCallback: (String pattern) {
                              return contacts.contacts.where((c) =>
                                  c.name
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()));
                            },
                            itemBuilder: (BuildContext context, Contact c) =>
                                ListTile(title: Text(c.name)),
                            noItemsFoundBuilder: (_) => SizedBox(),
                          ),
                        ),
                        IconButton(
                            icon: new Icon(MdiIcons.qrcodeScan),
                            onPressed: _onScan)
                      ]),
                      Row(children: [
                        Expanded(
                            child: TextFormField(
                              style: !_inputInZEC
                                  ? TextStyle(fontWeight: FontWeight.w200)
                                  : TextStyle(),
                              decoration: InputDecoration(
                                  labelText: s.amountInSettingscurrency(coin.ticker)),
                              controller: _zecAmountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [makeInputFormatter(_mZEC)],
                              validator: _checkAmount,
                              onTap: () =>
                                  setState(() {
                                    _inputInZEC = true;
                                  }),
                              onChanged: (_) {
                                _updateFiatAmount();
                              },
                              onSaved: _onAmount,
                            )),
                        TextButton(
                            child: Text(s.max), onPressed: _onMax),
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            style: _inputInZEC
                                ? TextStyle(fontWeight: FontWeight.w200)
                                : TextStyle(),
                            decoration: InputDecoration(
                                labelText: s.amountInSettingscurrency(
                                    settings.currency)),
                            controller: _fiatAmountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [makeInputFormatter(_mZEC)],
                            validator: (v) => _checkAmount(v, isFiat: true),
                            onTap: () =>
                                setState(() {
                                  _inputInZEC = false;
                                }),
                            onChanged: (_) {
                              _updateAmount();
                            },
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
                                  ListTile(
                                      title: Text(s.advancedOptions)),
                              body: Column(children: [
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: s.memo),
                                    minLines: 4,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    controller: _memoController,
                                  ),
                                ),
                                CheckboxListTile(
                                    title: Text(s.roundToMillis),
                                    value: _mZEC,
                                    onChanged: _onChangedmZEC),
                                CheckboxListTile(
                                    title:
                                    Text(s.includeFeeInAmount),
                                    value: _includeFee,
                                    onChanged: _onChangedIncludeFee),
                                if (accountManager.canPay)
                                  CheckboxListTile(
                                    title: Text(
                                        s.shieldTransparentBalance),
                                    value: _shieldTransparent,
                                    onChanged: _onChangedShieldBalance,
                                  ),
                                ListTile(
                                    title: TextFormField(
                                      decoration: InputDecoration(
                                          labelText:
                                          s.maxAmountPerNote),
                                      keyboardType: TextInputType.number,
                                      controller: _maxAmountController,
                                      inputFormatters: [
                                        makeInputFormatter(_mZEC)
                                      ],
                                      validator: _checkMaxAmountPerNote,
                                      onSaved: _onSavedMaxAmountPerNote,
                                    )),
                              ]),
                              isExpanded: _isExpanded,
                            )
                          ]),
                      Padding(padding: EdgeInsets.all(8)),
                      Text(
                        "${s.spendable}: ${decimalFormat(
                            _balance / ZECUNIT, 8, symbol: coin.ticker)}",
                      ),
                      Observer(builder: (context) {
                        final tbal = accountManager.tbalance;
                        return tbal > 0 ? RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                "${s.unshielded}: ${decimalFormat(
                                    tbal / ZECUNIT, 3,
                                    symbol: coin.ticker)} ",),
                              WidgetSpan(

                                child: GestureDetector(
                                  child: Icon(Icons.shield_outlined),
                                  onTap: () {
                                    shieldTAddr(context);
                                  },
                                ),
                              )
                            ])) : Container();
                      }),
                      ButtonBar(
                          children: confirmButtons(context, _onSend,
                              okLabel: s.send,
                              okIcon: Icon(MdiIcons.send)))
                    ])))));
  }

  String? _checkAddress(String? v) {
    final s = S.of(context);
    if (v == null || v.isEmpty) return s.addressIsEmpty;
    final c = contacts.contacts.where((c) => c.name == v);
    if (c.isNotEmpty) return null;
    final zaddr = WarpApi.getSaplingFromUA(v);
    if (zaddr.isNotEmpty) return null;
    if (!WarpApi.validAddress(v)) return s.invalidAddress;
    return null;
  }

  String? _checkAmount(String? vs, {bool isFiat: false}) {
    final s = S.of(context);
    if (vs == null) return s.amountMustBeANumber;
    if (!checkNumber(vs)) return s.amountMustBeANumber;
    final v = parseNumber(vs);
    if (v < 0.0) return s.amountMustBePositive;
    if (!isFiat && v == 0.0) return s.amountMustBePositive;
    if (!isFiat && amountInZAT(Decimal.parse(v.toString())) > _balance)
      return s.notEnoughBalance;
    return null;
  }

  String? _checkMaxAmountPerNote(String? vs) {
    final s = S.of(context);
    if (vs == null) return s.amountMustBeANumber;
    if (!checkNumber(vs)) return s.amountMustBeANumber;
    final v = parseNumber(vs);
    if (v < 0.0) return s.amountMustBePositive;
    return null;
  }

  void _onMax() {
    setState(() {
      _mZEC = false;
      _includeFee = false;
      _zecAmountController.text =
          (Decimal.fromInt(_balance) / ZECUNIT_DECIMAL).toString();
      _updateFiatAmount();
    });
  }

  void _onChangedIncludeFee(bool? v) {
    setState(() {
      _includeFee = v ?? false;
    });
  }

  void _onChangedmZEC(bool? v) {
    if (v == null) return;
    setState(() {
      _mZEC = v;
      _zecAmountController.text = _trimToPrecision(_zecAmountController.text);
      _fiatAmountController.text = _trimToPrecision(_fiatAmountController.text);
    });
  }

  void _onChangedShieldBalance(bool? v) {
    if (v == null) return;
    setState(() {
      _shieldTransparent = v;
    });
  }

  void _onScan() async {
    final code = await scanCode(context);
    if (code != null) {
      if (_checkAddress(code) != null) {
        final json = WarpApi.parsePaymentURI(code);
        final payment = DecodedPaymentURI.fromJson(jsonDecode(json));
        setState(() {
          _address = payment.address;
          _addressController.text = _address;
          _memoController.text = payment.memo;
          _amount = payment.amount;
          _zecAmountController.text = amountFromZAT(_amount);
        });
      } else {
        setState(() {
          _address = code;
          _addressController.text = _address;
        });
      }
    }
  }

  void _onAmount(String? vs) {
    final v = parseNumber(vs);
    _amount = amountInZAT(Decimal.parse(v.toString()));
  }

  void _onAddress(v) {
    final c = contacts.contacts.where((c) => c.name == v);
    if (c.isEmpty)
      _address = v;
    else {
      _address = c.first.address;
    }
  }

  void _onSavedMaxAmountPerNote(vs) {
    final v = parseNumber(vs);
    _maxAmountPerNote = Decimal.parse(v.toString());
  }

  void _updateAmount() {
    final rate = 1.0 / priceStore.zecPrice;
    final amount = parseNumber(_fiatAmountController.text);
    final otherAmount = _formatCurrency(amount * rate);
    setState(() {
      _zecAmountController.text = otherAmount;
    });
  }

  void _updateFiatAmount() {
    final rate = priceStore.zecPrice;
    final amount = parseNumber(_zecAmountController.text);
    final otherAmount = _formatCurrency(amount * rate);
    setState(() {
      _fiatAmountController.text = otherAmount;
    });
  }

  String _formatCurrency(double v) => decimalFormat(v, precision(_mZEC));

  void _onSend() async {
    final s = S.of(context);
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final aZEC = (Decimal.fromInt(_amount) / ZECUNIT_DECIMAL).toString();
      final approved = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              AlertDialog(
                  title: Text(s.pleaseConfirm),
                  content: SingleChildScrollView(
                      child: Text(s.sendingAzecCointickerToAddress(
                          aZEC, coin.ticker, _address))),
                  actions: confirmButtons(
                      context, () => Navigator.of(context).pop(true),
                      okLabel: s.approve, cancelValue: false)));
      if (approved) {
        Navigator.of(context).pop();

        final snackBar1 = SnackBar(content: Text(s.preparingTransaction));
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar1);

        if (_includeFee) _amount -= DEFAULT_FEE;
        int maxAmountPerNote = (_maxAmountPerNote * ZECUNIT_DECIMAL).toInt();
        final memo = _memoController.text;
        final address = unwrapUA(_address);

        if (accountManager.canPay) {
          if (settings.protectSend &&
              !await authenticate(
                  context, s.pleaseAuthenticateToSend)) return;
          final tx = await compute(
              sendPayment,
              PaymentParams(
                  accountManager.active.id,
                  address,
                  _amount,
                  memo,
                  maxAmountPerNote,
                  settings.anchorOffset,
                  _shieldTransparent,
                  progressPort.sendPort));

          final snackBar2 = SnackBar(content: Text("${s.txId}: $tx"));
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);
          await accountManager.fetchAccountData(true);
        } else {
          Directory tempDir = await getTemporaryDirectory();
          String filename = "${tempDir.path}/tx.json";

          final msg = WarpApi.prepareTx(
              accountManager.active.id,
              address,
              _amount,
              memo,
              maxAmountPerNote,
              settings.anchorOffset,
              filename);

          Share.shareFiles([filename], subject: s.unsignedTransactionFile);

          final snackBar2 = SnackBar(content: Text(msg));
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);
        }
      }
    }
  }

  int amountInZAT(Decimal v) => (v * ZECUNIT_DECIMAL).toInt();

  String amountFromZAT(int v) =>
      (Decimal.fromInt(v) / ZECUNIT_DECIMAL).toString();

  double _fx() {
    return priceStore.zecPrice;
  }

  String _trimToPrecision(String v) {
    double vv = parseNumber(v);
    return decimalFormat(vv, precision(_mZEC));
  }
}

sendPayment(PaymentParams param) async {
  param.port.send(0);
  final tx = await WarpApi.sendPayment(
      param.account,
      param.address,
      param.amount,
      param.memo,
      param.maxAmountPerNote,
      param.anchorOffset,
      param.shieldBalance, (percent) {
    param.port.send(percent);
  });
  param.port.send(0);
  return tx;
}
