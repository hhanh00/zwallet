import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  ReactionDisposer? _newBlockAutorunDispose;
  final _fee = DEFAULT_FEE;
  var _usedBalance = 0;
  var _replyTo = settings.includeReplyTo;

  void clear() {
    final s = S.of(context);
    setState(() {
      _memoController.text = settings.memoSignature ?? s.sendFrom(APP_NAME);
      _addressController.clear();
      _replyTo = false;
      _subjectController.clear();
      _amountKey.currentState?.clear();
    });
  }

  @override
  initState() {
    super.initState();

    final draftRecipient = active.draftRecipient;
    if (draftRecipient != null) {
      _addressController.text = draftRecipient.address;
      _initialAmount = draftRecipient.amount;
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
      final balances = active.balances;
      final sBalance = balances.shieldedBalance;
      final tBalance = active.tbalance;
      final excludedBalance = balances.excludedBalance;
      final underConfirmedBalance = balances.underConfirmedBalance;
      int? unconfirmedBalance = unconfirmedBalanceStream.value;
      setState(() {
        _sBalance = sBalance;
        _tBalance = tBalance;
        _excludedBalance = excludedBalance;
        _underConfirmedBalance = underConfirmedBalance;
        _unconfirmedBalance = unconfirmedBalance ?? 0;
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
    final t = Theme.of(context);
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
                          max: true,
                          initialValue: _initialAmount,
                          spendable: spendable),
                      if (!simpleMode) BalanceTable(_sBalance, _tBalance,
                          _excludedBalance, _underConfirmedBalance, change, _usedBalance, _fee),
                      Container(child: InputDecorator(
                        decoration: InputDecoration(labelText: s.memo),
                        child: Column(children: [
                      FormBuilderCheckbox(
                        key: UniqueKey(),
                        name: 'reply-to',
                        title: Text(s.includeReplyTo),
                        initialValue: _replyTo,
                        onChanged: (v) {
                          setState(() {
                            _replyTo = v ?? false;
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
                      Padding(padding: EdgeInsets.all(8)),
                      ButtonBar(
                          children: [
                            ElevatedButton.icon(onPressed: clear, icon: Icon(Icons.clear), label: Text(s.reset), style: ElevatedButton.styleFrom(backgroundColor: t.colorScheme.secondary)),
                            ElevatedButton.icon(onPressed: _onSend, icon: Icon(MdiIcons.send), label: Text(widget.isMulti ? s.add : s.send))
                    ])
        ])))));
  }

  Suggestion? getSuggestion(String v) {
    final c = contacts.contacts.where((c) => c.name == v);
    if (c.isNotEmpty) return ContactSuggestion(c.first);
    final a = accounts.list.where((a) => a.name == v);
    if (a.isNotEmpty) return AccountSuggestion(a.first);
    return null;
  }

  String? _checkAddress(String? v) {
    final s = S.of(context);
    if (v == null || v.isEmpty) return s.addressIsEmpty;
    final suggestion = getSuggestion(v);
    if (suggestion != null) return null;
    if (!WarpApi.validAddress(active.coin, v)) return s.invalidAddress;
    return null;
  }

  void _onScan() async {
    final code = await scanCode(context);
    if (code != null) {
      _setPaymentURI(code);
    }
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

  void _onSend() async {
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final amount = amountInput?.amount ?? 0;
      final feeIncluded = amountInput?.feeIncluded ?? false;
      final memo = _memoController.text;
      final subject = _subjectController.text;
      final recipient = Recipient(
        _address,
        amount,
        feeIncluded,
        _replyTo,
        subject,
        memo,
        0,
      );
      active.setDraftRecipient(recipient);

      if (!widget.isMulti)
        // send closes the page
        await send(context, [recipient]);
      else
        Navigator.of(context).pop(recipient);
    }
  }

  int amountInZAT(Decimal v) => (v * ZECUNIT_DECIMAL).toBigInt().toInt();

  String amountFromZAT(int v) =>
      (Decimal.fromInt(v) / ZECUNIT_DECIMAL).toString();

  get spendable => math.max(
      _tBalance +
      _sBalance -
      _excludedBalance -
      _underConfirmedBalance -
      _usedBalance,
      0);

  get change => _unconfirmedSpentBalance + _unconfirmedBalance;

  DualMoneyInputState? get amountInput => _amountKey.currentState;
}

class BalanceTable extends StatelessWidget {
  final int sBalance;
  final int tBalance;
  final int excludedBalance;
  final int underConfirmedBalance;
  final int change;
  final int used;
  final int fee;

  BalanceTable(this.sBalance, this.tBalance,
      this.excludedBalance, this.underConfirmedBalance, this.change, this.used, this.fee);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor, width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          BalanceRow(Text(s.totalBalance), totalBalance),
          BalanceRow(Text(s.underConfirmed), -underConfirmed),
          BalanceRow(Text(s.excludedNotes), -excludedBalance),
          BalanceRow(Text(s.spendableBalance), spendable,
              style: TextStyle(color: theme.primaryColor)),
        ]));
  }

  get totalBalance => sBalance + tBalance + change - used;

  get underConfirmed => -underConfirmedBalance - change;

  get spendable => math.max(
      sBalance +
          tBalance -
          excludedBalance -
          underConfirmedBalance -
          used,
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

Future<void> send(BuildContext context, List<Recipient> recipients) async {
  final s = S.of(context);

  showSnackBar(s.preparingTransaction, autoClose: true);

  if (settings.protectSend &&
      !await authenticate(context, s.pleaseAuthenticateToSend)) return;

  if (recipients.length == 1)
    active.setDraftRecipient(recipients[0]);
  try {
    final txPlan = await WarpApi.prepareTx(active.coin, active.id, recipients,
        settings.anchorOffset);
    Navigator.pushReplacementNamed(context, '/txplan', arguments: txPlan);
  }
  on String catch (message) {
    showSnackBar(message);
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


