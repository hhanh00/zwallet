import 'dart:ui';

import 'package:YWallet/pages/utils.dart' hide showSnackBar;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobx/mobx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/data_fb_generated.dart' hide Account;
import 'account_manager.dart';
import 'accounts.dart';
import 'contact.dart';
import 'dualmoneyinput.dart';
import 'package:warp_api/warp_api.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math' as math;

import 'main.dart';
import 'store.dart';
import 'generated/intl/messages.dart';

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
  var _fiat = settings.currency;
  var _memoInitialized = false;
  ReactionDisposer? _newBlockAutorunDispose;
  final _fee = DEFAULT_FEE;
  var _usedBalance = 0;
  var _replyTo = settings.includeReplyTo;
  List<SendTemplateT> _templates = [];
  SendTemplateT? _template;
  var _accounts = AccountList();

  void clear() {
    final s = S.of(context);
    setState(() {
      _memoController.text = settings.memoSignature ?? s.sendFrom(APP_NAME);
      _addressController.clear();
      _fiat = settings.currency;
      _replyTo = false;
      _subjectController.clear();
      _amountKey.currentState?.clear();
      active.setDraftRecipient(null);
    });
  }

  @override
  initState() {
    super.initState();

    final draftRecipient = active.draftRecipient;
    if (draftRecipient != null) {
      _addressController.text = draftRecipient.address!;
      _initialAmount = draftRecipient.amount;
      _memoController.text = draftRecipient.memo ?? '';
      _replyTo = draftRecipient.replyTo;
      _subjectController.text = draftRecipient.subject ?? '';
      _memoInitialized = true;
    }

    if (widget.args?.contact != null)
      _addressController.text = widget.args!.contact!.address!;
    if (widget.args?.address != null)
      _addressController.text = widget.args!.address!;
    if (widget.args?.subject != null)
      _subjectController.text = widget.args!.subject!;
    final recipients = widget.args?.recipients ?? [];
    _usedBalance = recipients.fold(0, (acc, r) => acc + r.amount);

    _newBlockAutorunDispose = autorun((_) {
      syncStatus.latestHeight;
      setState(() {});
    });
    Future.microtask(syncStatus.update);

    final uri = widget.args?.uri;
    if (uri != null)
      Future.microtask(() {
        _setPaymentURI(uri);
      });

    final templateIds = active.dbReader.loadTemplates();
    _templates = templateIds;
  }

  @override
  void deactivate() {
    final form = _formKey.currentState;
    if (form != null) {
      form.save();
      final recipient = _getRecipient();
      active.setDraftRecipient(recipient);
    }
    super.deactivate();
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

    active.updateBalances();
    final balances = active.balances;
    final sBalance = balances.shieldedBalance;
    final tBalance = active.tbalance;
    final excludedBalance = balances.excludedBalance;
    final underConfirmedBalance = balances.underConfirmedBalance;
    int? unconfirmedBalance = unconfirmedBalanceStream.value;
    _sBalance = sBalance;
    _tBalance = tBalance;
    _excludedBalance = excludedBalance;
    _underConfirmedBalance = underConfirmedBalance;
    _unconfirmedBalance = unconfirmedBalance ?? 0;

    var templates = _templates
        .map((t) => DropdownMenuItem(child: Text(t.title!), value: t))
        .toList();
    final addReset = _template != null
        ? IconButton(onPressed: _resetTemplate, icon: Icon(Icons.close))
        : IconButton(onPressed: _addTemplate, icon: Icon(Icons.add));

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
                                labelText:
                                    s.sendCointickerTo(active.coinDef.ticker)),
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
                            final matchingContacts = contacts.contacts
                                .where((c) => c.name!
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .map((c) => ContactSuggestion(c.unpack()));
                            final matchingAccounts = _accounts.list
                                .where((a) =>
                                    a.coin == active.coin &&
                                    a.name
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                .map((a) => AccountSuggestion(a));
                            return [...matchingContacts, ...matchingAccounts];
                          },
                          itemBuilder:
                              (BuildContext context, Suggestion suggestion) =>
                                  ListTile(title: Text(suggestion.name)),
                          noItemsFoundBuilder: (_) => SizedBox(),
                        )),
                        IconButton(
                            icon: new Icon(MdiIcons.qrcodeScan),
                            onPressed: _onScan),
                        IconButton(
                            icon: new Icon(MdiIcons.contacts),
                            onPressed: _onAddContact),
                      ]),
                      DualMoneyInputWidget(
                          key: _amountKey,
                          max: true,
                          initialValue: _initialAmount,
                          spendable: spendable),
                      if (!simpleMode)
                        BalanceTable(_sBalance, _tBalance, _excludedBalance,
                            _underConfirmedBalance, change, _usedBalance, _fee),
                      Container(
                          child: InputDecorator(
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
                                )
                              ]))),
                      Padding(padding: EdgeInsets.all(8)),
                      Row(children: [
                        Expanded(
                            child: DropdownButtonFormField<SendTemplateT>(
                                hint: Text(s.template),
                                items: templates,
                                value: _template,
                                onChanged: (v) {
                                  setState(() {
                                    _template = v;
                                  });
                                })),
                        addReset,
                        IconButton(
                            onPressed: _template != null ? _openTemplate : null,
                            icon: Icon(Icons.open_in_new)),
                        IconButton(
                            onPressed: _template != null
                                ? () {
                                    _saveTemplate(
                                        _template!.id, _template!.title!, true);
                                  }
                                : null,
                            icon: Icon(Icons.save)),
                        IconButton(
                            onPressed:
                                _template != null ? _deleteTemplate : null,
                            icon: Icon(Icons.delete)),
                      ]),
                      Padding(padding: EdgeInsets.all(8)),
                      ButtonBar(children: [
                        ElevatedButton.icon(
                            onPressed: clear,
                            icon: Icon(Icons.clear),
                            label: Text(s.reset)),
                        ElevatedButton.icon(
                            onPressed: _onSend,
                            icon: Icon(MdiIcons.send),
                            label: Text(widget.isMulti ? s.add : s.send))
                      ])
                    ])))));
  }

  void _resetTemplate() {
    setState(() {
      _template = null;
    });
  }

  Future<void> _addTemplate() async {
    final s = S.of(context);
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      final titleController = TextEditingController();
      final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text(s.newTemplate),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        decoration: InputDecoration(label: Text(s.name)),
                        controller: titleController)
                  ]),
                  actions: confirmButtons(context, () {
                    Navigator.of(context).pop(true);
                  }))) ??
          false;
      if (!confirmed) return;
      final title = titleController.text;
      _saveTemplate(0, title, false);
    }
  }

  void _saveTemplate(int id, String title, bool validate) {
    final form = _formKey.currentState!;
    if (validate && !form.validate()) return null;
    form.save();
    final dualAmountController = amountInput;
    if (dualAmountController == null) return null;
    var template = SendTemplateT(
        id: id,
        title: title,
        address: _address,
        amount: stringToAmount(dualAmountController.coinAmountController.text),
        fiatAmount: parseNumber(dualAmountController.fiatAmountController.text),
        feeIncluded: dualAmountController.feeIncluded,
        fiat: dualAmountController.inputInCoin ? null : _fiat,
        includeReplyTo: _replyTo,
        subject: _subjectController.text,
        body: _memoController.text);
    final id2 = WarpApi.saveSendTemplate(active.coin, template);
    _loadTemplates(id2);
  }

  Future<void> _deleteTemplate() async {
    final s = S.of(context);
    final confirmed = await showConfirmDialog(
        context, s.deleteTemplate, s.areYouSureYouWantToDeleteThisSendTemplate);
    if (!confirmed) return;
    WarpApi.deleteSendTemplate(active.coin, _template!.id);
    _resetTemplate();
    _loadTemplates(0);
  }

  void _openTemplate() {
    final tid = _template;
    if (tid == null) return;
    final template = _template;
    if (template == null) return;
    amountInput?.restore(template.amount, template.fiatAmount,
        template.feeIncluded, template.fiat);
    setState(() {
      _addressController.text = template.address!;
      _replyTo = template.includeReplyTo;
      _subjectController.text = template.subject!;
      _memoController.text = template.body!;
    });
  }

  void _loadTemplates(int id) {
    final templates = active.dbReader.loadTemplates();
    _templates = templates;
    if (id != 0) _template = _templates.firstWhere((t) => t.id == id);
    setState(() {});
  }

  Suggestion? getSuggestion(String v) {
    final c = contacts.contacts.where((c) => c.name == v);
    if (c.isNotEmpty) return ContactSuggestion(c.first.unpack());
    final a = _accounts.list.where((a) => a.name == v);
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

  Future<void> _onAddContact() async {
    final c = ContactObjectBuilder(address: _addressController.text);
    await addContact(context, Contact(c.toBytes()));
  }

  void _setPaymentURI(String uriOrAddress) {
    try {
      final paymentURI = decodeAddress(context, uriOrAddress);
      setState(() {
        _address = paymentURI.address;
        _addressController.text = _address;
        if (paymentURI.memo.isNotEmpty) _memoController.text = paymentURI.memo;
        if (paymentURI.amount != 0) amountInput?.setAmount(paymentURI.amount);
      });
    } on String catch (e) {
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

  Recipient _getRecipient() {
    final amount = amountInput?.amount ?? 0;
    final feeIncluded = amountInput?.feeIncluded ?? false;
    final memo = _memoController.text;
    final subject = _subjectController.text;
    final recipient = RecipientObjectBuilder(
      address: _address,
      amount: amount,
      feeIncluded: feeIncluded,
      replyTo: _replyTo,
      subject: subject,
      memo: memo,
      maxAmountPerNote: 0,
    );
    return Recipient(recipient.toBytes());
  }

  void _onSend() async {
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final recipient = _getRecipient();

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

  BalanceTable(this.sBalance, this.tBalance, this.excludedBalance,
      this.underConfirmedBalance, this.change, this.used, this.fee);

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
      sBalance + tBalance - excludedBalance - underConfirmedBalance - used, 0);
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

  await showSnackBar(s.preparingTransaction, autoClose: true);

  if (settings.protectSend &&
      !await authenticate(context, s.pleaseAuthenticateToSend)) return;

  if (recipients.length == 1) active.setDraftRecipient(recipients[0]);
  try {
    final txPlan = await WarpApi.prepareTx(
        active.coin, active.id, recipients, settings.uaType,
        settings.anchorOffset, settings.feeConfig);
    Navigator.pushReplacementNamed(context, '/txplan', arguments: txPlan);
  } on String catch (message) {
    showSnackBar(message);
  }
}

abstract class Suggestion {
  String get name;
  String get address;
}

class ContactSuggestion extends Suggestion {
  final ContactT contact;

  ContactSuggestion(this.contact);

  String get name => contact.name!;
  String get address => contact.address!;
}

class AccountSuggestion extends Suggestion {
  final Account account;

  AccountSuggestion(this.account);

  String get name => account.name;
  String get address => account.address;
}
