import 'dart:convert';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'accounts.dart';
import 'dualmoneyinput.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';
import 'package:decimal/decimal.dart';
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

  bool get isMulti => args?.isMulti ?? false;
}

class SendState extends State<SendPage> {
  static final zero = decimalFormat(0, 3);
  final _formKey = GlobalKey<FormState>();
  final _amountKey = GlobalKey<DualMoneyInputState>();
  var _initialAmount = 0;
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
  final _subjectController = TextEditingController();
  var _memoInitialized = false;
  final _maxAmountController = TextEditingController(text: zero);
  var _isExpanded = false;
  var _useMillis = true;
  var _useTransparent = settings.shieldBalance || active.showTAddr;
  ReactionDisposer? _newBlockAutorunDispose;
  final _fee = DEFAULT_FEE;
  var _usedBalance = 0;
  var _replyTo = settings.includeReplyTo;

  @override
  initState() {
    super.initState();

    final draftRecipient = active.draftRecipient;
    if (draftRecipient != null) {
      _addressController.text = draftRecipient.address;
      _initialAmount = draftRecipient.amount;
      _maxAmountController.text = NumberFormat.currency().format(draftRecipient.max_amount_per_note);
      _memoController.text = draftRecipient.memo;
      _replyTo = draftRecipient.reply_to;
      _subjectController.text = draftRecipient.subject;
      _memoInitialized = true;
      active.setDraftRecipient(null);
    }

    if (widget.args?.contact != null)
      _addressController.text = widget.args!.contact!.address;
    if (widget.args?.address != null)
      _addressController.text = widget.args!.address!;
    if (widget.args?.subject != null)
      _subjectController.text = widget.args!.subject!;
    final recipients = widget.args?.recipients ?? [];
    _usedBalance = recipients.fold(0, (acc, r) => acc + r.amount);

    final uri = widget.args?.uri;
    if (uri != null)
      Future.microtask(() {
        _setPaymentURI(uri);
      });

    _newBlockAutorunDispose = autorun((_) async {
      final _ = active.dataEpoch;
      final sBalance = active.balances.shieldedBalance;
      final tBalance = active.tbalance;
      final excludedBalance = active.balances.excludedBalance;
      final underConfirmedBalance = active.balances.underConfirmedBalance;
      final unconfirmedSpentBalance = active.balances.unconfirmedBalance;
      final unconfirmedBalance = active.balances.unconfirmedBalance;
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
    final simpleMode = settings.simpleMode;
    if (!_memoInitialized) {
      _memoController.text = settings.memoSignature ?? s.sendFrom(APP_NAME);
      _memoInitialized = true;
    }

    return Scaffold(
        appBar: AppBar(title: Text(s.sendCointicker(active.coinDef.ticker))),
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
                                labelText: s.sendCointickerTo(active.coinDef.ticker)),
                            minLines: 4,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                          ),
                          onSaved: _onAddress,
                          validator: _checkAddress,
                          onSuggestionSelected: (Suggestion suggestion) {
                            _addressController.text = suggestion.name;
                          },
                          suggestionsCallback: (String pattern) {
                            final matchingContacts = contacts.contacts.where((c) => c.name
                                .toLowerCase()
                                .contains(pattern.toLowerCase())).map((c) => ContactSuggestion(c));
                            final matchingAccounts = accounts.list
                                .where((a) => a.coin == active.coin && a.name
                                .toLowerCase()
                                .contains(pattern.toLowerCase())).map((a) => AccountSuggestion(a));
                            return [...matchingContacts, ...matchingAccounts];
                          },
                          itemBuilder: (BuildContext context, Suggestion suggestion) =>
                              ListTile(title: Text(suggestion.name)),
                          noItemsFoundBuilder: (_) => SizedBox(),
                        )),
                        IconButton(
                            icon: new Icon(MdiIcons.qrcodeScan),
                            onPressed: _onScan)
                      ]),
                      DualMoneyInputWidget(
                          key: _amountKey,
                          child:
                              TextButton(child: Text(s.max), onPressed: _onMax),
                          initialValue: _initialAmount,
                          useMillis: _useMillis,
                          spendable: spendable),
                      if (!simpleMode) BalanceTable(_sBalance, _tBalance, _useTransparent,
                          _excludedBalance, _underConfirmedBalance, change, _usedBalance, _fee),
                      Container(child: InputDecorator(
                        decoration: InputDecoration(labelText: s.memo),
                        child: Column(children: [
                      FormBuilderCheckbox(
                        name: 'reply-to',
                        title: Text(s.includeReplyTo),
                        initialValue: _replyTo,
                        onChanged: (_) {
                          setState(() {
                            _replyTo = true;
                          });
                        },
                      ),
                      TextFormField(
                        decoration:
                        InputDecoration(labelText: s.subject),
                        controller: _subjectController,
                      ),
                      TextFormField(
                        decoration:
                        InputDecoration(labelText: s.body),
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _memoController,
                      )]))),
                      if (!simpleMode) ExpansionPanelList(
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
                                CheckboxListTile(
                                    title: Text(s.roundToMillis),
                                    value: _useMillis,
                                    onChanged: _setUseMillis),
                                if (active.canPay && !widget.isMulti)
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
                                  inputFormatters: [
                                    makeInputFormatter(amountInput?.useMillis)
                                  ],
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
                              okLabel: widget.isMulti ? s.add : s.send,
                              okIcon: Icon(MdiIcons.send)))
                    ])))));
  }

  Suggestion? getSuggestion(String v) {
    final c = contacts.contacts.where((c) => c.name == v);
    if (c.isNotEmpty) return ContactSuggestion(c.first);
    final a = accounts.list.where((a) => a.name == v);
    if (a.isNotEmpty) return AccountSuggestion(a.first);
  }

  String? _checkAddress(String? v) {
    final s = S.of(context);
    if (v == null || v.isEmpty) return s.addressIsEmpty;
    final suggestion = getSuggestion(v);
    if (suggestion != null) return null;
    if (!WarpApi.validAddress(active.coin, v)) return s.invalidAddress;
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
      _setPaymentURI(code);
    }
  }

  void _setUseMillis(bool? vv) {
    final v = vv ?? false;
    amountInput?.setMillis(v);
    setState(() {
      _useMillis = v;
    });
  }

  void _setPaymentURI(String uriOrAddress) {
    try {
      final paymentURI = decodeAddress(context, uriOrAddress);
      setState(() {
        _address = paymentURI.address;
        _addressController.text = _address;
        if (paymentURI.memo.isNotEmpty)
          _memoController.text = paymentURI.memo;
        if (paymentURI.amount != 0)
          amountInput?.setAmount(paymentURI.amount);
      });
    }
    on String catch (e) {
      showSnackBar(S.of(context).invalidQrCode(e));
    }
  }

  void _onAddress(v) {
    final suggestion = getSuggestion(v);
    if (suggestion == null)
      _address = v;
    else {
      _address = suggestion.address;
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
      final aZEC = amountToString(amount, MAX_PRECISION);
      final approved = widget.isMulti ||
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(s.pleaseConfirm),
                  content: SingleChildScrollView(
                      child: Text(s.sendingAzecCointickerToAddress(
                          aZEC, active.coinDef.ticker, _address))),
                  actions: confirmButtons(
                      context, () => Navigator.of(context).pop(true),
                      okLabel: s.approve, cancelValue: false)));
      if (approved) {
        int maxAmountPerNote = (_maxAmountPerNote * ZECUNIT_DECIMAL).toBigInt().toInt();
        final memo = _memoController.text;
        final subject = _subjectController.text;
        final recipient = Recipient(
          _address,
          amount,
          _replyTo,
          subject,
          memo,
          maxAmountPerNote,
        );
        active.setDraftRecipient(recipient);

        if (!widget.isMulti)
          // send closes the page
          await send(context, [recipient], _useTransparent);
        else
          Navigator.of(context).pop(recipient);
      }
    }
  }


  int amountInZAT(Decimal v) => (v * ZECUNIT_DECIMAL).toBigInt().toInt();

  String amountFromZAT(int v) =>
      (Decimal.fromInt(v) / ZECUNIT_DECIMAL).toString();

  get spendable => math.max(
      (_useTransparent ? _tBalance : 0) +
          _sBalance -
          _excludedBalance -
          _underConfirmedBalance -
          _usedBalance -
          _fee,
      0);

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
  final int used;
  final int fee;

  BalanceTable(this.sBalance, this.tBalance, this.useTBalance,
      this.excludedBalance, this.underConfirmedBalance, this.change, this.used, this.fee);

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
        decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor, width: 1),
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

  get totalBalance => sBalance + tBalance + change - used - fee;

  get underConfirmed => -underConfirmedBalance - change;

  get spendable => math.max(
      sBalance +
          (useTBalance ? tBalance : 0) -
          excludedBalance -
          underConfirmedBalance -
          used -
          fee,
      0);
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
        trailing: Text(amountToString(amount, MAX_PRECISION),
            style: TextStyle(fontFeatures: [FontFeature.tabularFigures()])
                .merge(style)),
        visualDensity: VisualDensity(horizontal: 0, vertical: -4));
  }
}

Future<void> send(BuildContext context, List<Recipient> recipients, bool useTransparent) async {

  final s = S.of(context);

  String address = "";
  for (var r in recipients) {
    if (address.isEmpty)
      address = r.address;
    else
      address = '*';
  }

  showSnackBar(s.preparingTransaction, autoClose: true);

  if (settings.protectSend &&
      !await authenticate(context, s.pleaseAuthenticateToSend)) return;

  final player = AudioPlayer();

  bool needClose = true;
  active.setDraftRecipient(null);
  try {
    if (active.canPay) {
      needClose = false;
      Navigator.of(context).pop();
      active.setBanner(s.paymentInProgress);
      final txId = await WarpApi.sendPayment(active.coin, active.id, recipients,
          useTransparent, settings.anchorOffset, (progress) {
            progressPort.sendPort.send(progress);
          });
      progressPort.sendPort.send(0);
      await player.play(AssetSource("success.mp3"));
      showSnackBar(s.txId(txId));
      await active.update();
    } else {
      final txjson = WarpApi.prepareTx(
          recipients, useTransparent, settings.anchorOffset);

      if (settings.qrOffline) {
        needClose = false;
        Navigator.pushReplacementNamed(context, '/qroffline', arguments: txjson);
      }
      else {
        await saveFile(txjson, "tx.json", s.unsignedTransactionFile);
        showSnackBar(s.fileSaved);
      }
    }
  }
  on String catch (message) {
    showSnackBar(message);
    await player.play(AssetSource("fail.mp3"));
    if (recipients.length == 1)
      active.setDraftRecipient(recipients[0]);
  }
  finally {
    if (needClose)
      Navigator.of(context).pop();
    active.setBanner("");
  }
}

abstract class Suggestion {
  String get name;
  String get address;
}

class ContactSuggestion extends Suggestion {
  final Contact contact;

  ContactSuggestion(this.contact);

  String get name => contact.name;
  String get address => contact.address;
}

class AccountSuggestion extends Suggestion {
  final Account account;

  AccountSuggestion(this.account);

  String get name => account.name;
  String get address => account.address;
}


