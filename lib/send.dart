import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final SendPageArgs? args;

  SendPage(this.args);

  @override
  SendState createState() => SendState();
}

class SendState extends State<SendPage> {
  static final zero = decimalFormat(0, 3);
  final _formKey = GlobalKey<FormState>();
  var _address = "";
  var _amount = 0;
  var _maxAmountPerNote = Decimal.zero;
  var _sBalance = 0;
  var _tBalance = 0;
  var _excludedBalance = 0;
  var _underConfirmedBalance = 0;
  final _addressController = TextEditingController();
  final _memoController = TextEditingController();
  var _mZEC = true;
  var _inputInZEC = true;
  var _zecAmountController = TextEditingController(text: zero);
  var _fiatAmountController = TextEditingController(text: zero);
  final _maxAmountController = TextEditingController(text: zero);
  var _isExpanded = false;
  var _shieldTransparent = settings.shieldBalance;
  ReactionDisposer? _priceAutorunDispose;
  ReactionDisposer? _newBlockAutorunDispose;

  @override
  initState() {
    if (widget.args?.contact != null)
      _addressController.text = widget.args!.contact!.address;

    if (widget.args?.uri != null)
      _setPaymentURI(widget.args!.uri!);

    _updateFiatAmount();
    super.initState();

    _priceAutorunDispose = autorun((_) {
      _updateFiatAmount();
    });

    _newBlockAutorunDispose = autorun((_) async {
      final _ = syncStatus.latestHeight;
      final sBalance = await accountManager.getShieldedBalance();
      final tBalance = accountManager.tbalance;
      final excludedBalance = await accountManager.getExcludedBalance();
      final underConfirmedBalance =
          await accountManager.getUnderConfirmedBalance();
      setState(() {
        _sBalance = sBalance;
        _tBalance = tBalance;
        _excludedBalance = excludedBalance;
        _underConfirmedBalance = underConfirmedBalance;
      });
    });
  }

  @override
  void dispose() {
    _priceAutorunDispose?.call();
    _newBlockAutorunDispose?.call();
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
                            return contacts.contacts.where((c) => c.name
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (BuildContext context, Contact c) =>
                              ListTile(title: Text(c.name)),
                          noItemsFoundBuilder: (_) => SizedBox(),
                        )),
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
                              labelText:
                                  s.amountInSettingscurrency(coin.ticker)),
                          controller: _zecAmountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [makeInputFormatter(_mZEC)],
                          validator: _checkAmount,
                          onTap: () => setState(() {
                            _inputInZEC = true;
                          }),
                          onChanged: (_) {
                            _updateFiatAmount();
                          },
                          onSaved: _onAmount,
                        )),
                        TextButton(child: Text(s.max), onPressed: _onMax),
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
                                onTap: () => setState(() {
                                      _inputInZEC = false;
                                    }),
                                onChanged: (_) {
                                  _updateAmount();
                                }))
                      ]),
                      BalanceTable(_sBalance, _tBalance, _excludedBalance,
                          _underConfirmedBalance),
                      ExpansionPanelList(
                          expansionCallback: (_, isExpanded) {
                            setState(() {
                              _isExpanded = !isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (_, __) =>
                                  ListTile(title: Text(s.advancedOptions)),
                              body: Column(children: [
                                ListTile(
                                  title: TextFormField(
                                    decoration:
                                        InputDecoration(labelText: s.memo),
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
                                if (accountManager.canPay)
                                  CheckboxListTile(
                                    title: Text(s.shieldTransparentBalance),
                                    value: _shieldTransparent,
                                    onChanged: _onChangedShieldBalance,
                                  ),
                                ListTile(
                                    title: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: s.maxAmountPerNote),
                                  keyboardType: TextInputType.number,
                                  controller: _maxAmountController,
                                  inputFormatters: [makeInputFormatter(_mZEC)],
                                  validator: _checkMaxAmountPerNote,
                                  onSaved: _onSavedMaxAmountPerNote,
                                )),
                              ]),
                              isExpanded: _isExpanded,
                            )
                          ]),
                      Padding(padding: EdgeInsets.all(8)),
                      ButtonBar(
                          children: confirmButtons(context, _onSend,
                              okLabel: s.send, okIcon: Icon(MdiIcons.send)))
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
    if (!isFiat && amountInZAT(Decimal.parse(v.toString())) > spendable)
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
      _zecAmountController.text = amountToString(spendable);
      _updateFiatAmount();
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
        _setPaymentURI(code); // not an address
      } else {
        setState(() {
          _address = code;
          _addressController.text = _address;
        });
      }
    }
  }

  void _setPaymentURI(String uri) {
    final json = WarpApi.parsePaymentURI(uri);
    try {
      final payment = DecodedPaymentURI.fromJson(jsonDecode(json));
      setState(() {
        _address = payment.address;
        _addressController.text = _address;
        _memoController.text = payment.memo;
        _amount = payment.amount;
        _zecAmountController.text = amountFromZAT(_amount);
      });
    } on FormatException {}
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
          builder: (BuildContext context) => AlertDialog(
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

        int maxAmountPerNote = (_maxAmountPerNote * ZECUNIT_DECIMAL).toInt();
        final memo = _memoController.text;
        final address = unwrapUA(_address);

        if (accountManager.canPay) {
          if (settings.protectSend &&
              !await authenticate(context, s.pleaseAuthenticateToSend)) return;
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

          final msg = WarpApi.prepareTx(accountManager.active.id, address,
              _amount, memo, maxAmountPerNote, settings.anchorOffset, filename);

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

  get spendable => math.max(
      _sBalance - _excludedBalance - _underConfirmedBalance - DEFAULT_FEE, 0);
}

class BalanceTable extends StatelessWidget {
  final int sBalance;
  final int tBalance;
  final int excludedBalance;
  final int underConfirmedBalance;

  BalanceTable(this.sBalance, this.tBalance, this.excludedBalance,
      this.underConfirmedBalance);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tBalanceLabel = Text.rich(TextSpan(children: [
      TextSpan(text: S.of(context).unshieldedBalance + ' '),
      WidgetSpan(
        child: GestureDetector(
          child: Icon(Icons.shield_outlined),
          onTap: () {
            shieldTAddr(context);
          },
        ),
      )
    ]));

    return Container(
      decoration: BoxDecoration(border: Border.all(color: theme.dividerColor, width: 1),
      borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      BalanceRow(Text(S.of(context).totalBalance), totalBalance),
      BalanceRow(Text(S.of(context).underConfirmed), -underConfirmedBalance),
      BalanceRow(Text(S.of(context).excludedNotes), -excludedBalance),
      BalanceRow(tBalanceLabel, -tBalance),
      BalanceRow(Text(S.of(context).spendableBalance), spendable,
          style: TextStyle(color: Theme.of(context).primaryColor)),
    ]));
  }

  get totalBalance => sBalance + tBalance;

  get spendable => math.max(
      sBalance - excludedBalance - underConfirmedBalance - DEFAULT_FEE, 0);
}

class BalanceRow extends StatelessWidget {
  final label;
  final amount;
  final style;

  BalanceRow(this.label, this.amount, {this.style});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: label,
        trailing: Text(amountToString(amount),
            style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]).merge(style)),
        visualDensity: VisualDensity(horizontal: 0, vertical: -4));
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
