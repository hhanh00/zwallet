import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp/dualmoneyinput.dart';
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
  final _amountKey = GlobalKey<DualMoneyInputState>();
  var _address = "";
  var _maxAmountPerNote = Decimal.zero;
  var _sBalance = 0;
  var _tBalance = 0;
  var _excludedBalance = 0;
  var _underConfirmedBalance = 0;
  var _unconfirmedSpentBalance = 0;
  var _unconfirmedBalance = 0;
  final _addressController = TextEditingController();
  final _memoController = TextEditingController();
  final _maxAmountController = TextEditingController(text: zero);
  var _isExpanded = false;
  var _useMillis = true;
  var _useTransparent = settings.shieldBalance;
  ReactionDisposer? _newBlockAutorunDispose;

  @override
  initState() {
    if (widget.args?.contact != null)
      _addressController.text = widget.args!.contact!.address;

    final uri = widget.args?.uri;
    if (uri != null)
      Future.microtask(() {
        _setPaymentURI(uri);
      });

    super.initState();

    _newBlockAutorunDispose = autorun((_) async {
      final _ = syncStatus.latestHeight;
      final sBalance = await accountManager.getShieldedBalance();
      final tBalance = accountManager.tbalance;
      final excludedBalance = await accountManager.getExcludedBalance();
      final underConfirmedBalance =
          await accountManager.getUnderConfirmedBalance();
      final unconfirmedSpentBalance = await accountManager.getUnconfirmedSpentBalance();
      final unconfirmedBalance = accountManager.unconfirmedBalance;
      setState(() {
        _sBalance = sBalance;
        _tBalance = tBalance;
        _excludedBalance = excludedBalance;
        _underConfirmedBalance = underConfirmedBalance;
        _unconfirmedSpentBalance = unconfirmedSpentBalance;
        _unconfirmedBalance = unconfirmedBalance;
      });
    });
  }

  @override
  void dispose() {
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
                      DualMoneyInputWidget(key: _amountKey, child: TextButton(child: Text(s.max), onPressed: _onMax), spendable: spendable),
                      BalanceTable(_sBalance, _tBalance, _useTransparent, _excludedBalance,
                          _underConfirmedBalance, change),
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
                                    value: _useMillis,
                                    onChanged: _setUseMillis),
                                if (accountManager.canPay)
                                  CheckboxListTile(
                                    title: Text(s.useTransparentBalance),
                                    value: _useTransparent,
                                    onChanged: _onChangedUseTransparent,
                                  ),
                                ListTile(
                                    title: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: s.maxAmountPerNote),
                                  keyboardType: TextInputType.number,
                                  controller: _maxAmountController,
                                  inputFormatters: [makeInputFormatter(amountInput?.useMillis)],
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
      _useMillis = false;
      amountInput?.setAmount(spendable);
    });
  }

  void _onChangedUseTransparent(bool? v) {
    if (v == null) return;
    setState(() {
      _useTransparent = v;
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

  void _setUseMillis(bool? vv) {
    final v = vv ?? false;
    amountInput?.setMillis(v);
    setState(() {
      _useMillis = v;
    });
  }

  void _setPaymentURI(String uri) {
    final json = WarpApi.parsePaymentURI(uri);
    try {
      final payment = DecodedPaymentURI.fromJson(jsonDecode(json));
      setState(() {
        _address = payment.address;
        _addressController.text = _address;
        _memoController.text = payment.memo;
        amountInput?.setAmount(payment.amount);
      });
    } on FormatException {}
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

  void _onSend() async {
    final s = S.of(context);
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final amount = amountInput?.amount ?? 0;
      final aZEC = amountToString(amount);
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
                  amount,
                  memo,
                  maxAmountPerNote,
                  settings.anchorOffset,
                  _useTransparent,
                  progressPort.sendPort));

          final snackBar2 = SnackBar(content: Text("${s.txId}: $tx"));
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);
          await accountManager.fetchAccountData(true);
        } else {
          Directory tempDir = await getTemporaryDirectory();
          String filename = "${tempDir.path}/tx.json";

          final msg = WarpApi.prepareTx(accountManager.active.id, address,
              amountInput?.amount ?? 0, memo, maxAmountPerNote, settings.anchorOffset, filename);

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

  get spendable => math.max((_useTransparent ? _tBalance : 0) +
      _sBalance - _excludedBalance - _underConfirmedBalance - DEFAULT_FEE, 0);

  get change => _unconfirmedSpentBalance + _unconfirmedBalance;

  DualMoneyInputState? get amountInput => _amountKey.currentState;
}

class BalanceTable extends StatelessWidget {
  final int sBalance;
  final int tBalance;
  final bool useTBalance;
  final int excludedBalance;
  final int underConfirmedBalance;
  final int change;

  BalanceTable(this.sBalance, this.tBalance, this.useTBalance, this.excludedBalance,
      this.underConfirmedBalance, this.change);

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
      BalanceRow(Text(S.of(context).underConfirmed), -underConfirmed),
      BalanceRow(Text(S.of(context).excludedNotes), -excludedBalance),
      if (!useTBalance) BalanceRow(tBalanceLabel, -tBalance),
      BalanceRow(Text(S.of(context).spendableBalance), spendable,
          style: TextStyle(color: Theme.of(context).primaryColor)),
    ]));
  }

  get totalBalance => sBalance + tBalance + change;
  get underConfirmed => -underConfirmedBalance - change;

  get spendable => math.max(
      sBalance + (useTBalance ? tBalance : 0) - excludedBalance - underConfirmedBalance - DEFAULT_FEE, 0);
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
      param.useTransparent, (percent) {
    param.port.send(percent);
  });
  param.port.send(0);
  return tx;
}
