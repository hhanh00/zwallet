import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warp_api/warp_api.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'accounts.dart';
import 'accounts_old.dart';
import 'coin/coins.dart';
import 'main.dart';
import 'generated/intl/messages.dart';
import 'rescan.dart';

class AddAccountPage extends StatefulWidget {
  final bool firstAccount;
  AddAccountPage({this.firstAccount = false});

  @override
  State<StatefulWidget> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountIndexController = TextEditingController(text: "0");
  final _keyController = TextEditingController();
  var _restore = false;
  var _coin = 0;
  var _showIndex = false;

  @override
  void initState() {
    super.initState();
    if (widget.firstAccount) _nameController.text = "Main";
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.newAccount),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(children: [
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: s.accountName),
                            controller: _nameController,
                            validator: (String? name) {
                              if (name == null || name.isEmpty)
                                return s.accountNameIsRequired;
                              return null;
                            },
                          ),
                          FormBuilderRadioGroup<int>(
                              decoration: InputDecoration(labelText: s.crypto),
                              orientation: OptionsOrientation.vertical,
                              name: 'coin',
                              initialValue: _coin,
                              onChanged: (int? v) {
                                setState(() {
                                  _coin = v!;
                                });
                              },
                              options: [
                                FormBuilderFieldOption(
                                    child: ListTile(
                                        title: Text('Ycash'),
                                        trailing: Image.asset(
                                            'assets/ycash.png',
                                            height: 32)),
                                    value: 1),
                                FormBuilderFieldOption(
                                    child: ListTile(
                                        title: Text('Zcash'),
                                        trailing: Image.asset(
                                            'assets/zcash.png',
                                            height: 32)),
                                    value: 0),
                              ]),
                          FormBuilderCheckbox(
                            name: 'restore',
                            title: Text(s.restoreAnAccount),
                            onChanged: _setRestore,
                          ),
                          if (_restore)
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: s.key, hintText: s.enterSeed),
                                  minLines: 4,
                                  maxLines: 4,
                                  controller: _keyController,
                                  validator: (String? key) {
                                    if (!_checkKey(key)) return s.invalidKey;
                                    return null;
                                  },
                                  onChanged: _checkKey,
                                )),
                                GestureDetector(
                                    onLongPress: _toggleShowAccountIndex,
                                    child: IconButton(
                                        icon: new Icon(MdiIcons.qrcodeScan),
                                        onPressed: _onScan))
                              ],
                            ),
                          if (_restore &&
                              coins[_coin].supportsLedger &&
                              !isMobile())
                            Padding(
                                padding: EdgeInsets.all(16),
                                child: ElevatedButton(
                                    onPressed: _importLedger,
                                    child: Text('Import From Ledger'))),
                          if (_restore && _showIndex)
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: s.accountIndex),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _accountIndexController,
                              validator: (String? name) {
                                if (name == null || name.isEmpty)
                                  return s.accountNameIsRequired;
                                return null;
                              },
                            ),
                          ButtonBar(children: [
                            if (!widget.firstAccount)
                              ElevatedButton.icon(
                                  icon: Icon(Icons.cancel),
                                  label: Text(s.cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text(_restore ? s.import : s.newLabel),
                              onPressed: _onOK,
                            )
                          ])
                        ]))))));
  }

  _setRestore(bool? v) {
    setState(() {
      _restore = v ?? false;
    });
  }

  _onOK() async {
    final s = S.of(context);
    final form = _formKey.currentState!;
    String key = _keyController.text;
    int accountIndex = int.parse(_accountIndexController.text);
    final index = _keyRe.firstMatch(key);
    if (index != null) {
      key = index.group(1)!;
      accountIndex = int.parse(index.group(2)!);
    }

    if (form.validate()) {
      final account =
          await WarpApi.newAccount(_coin, _nameController.text, key, accountIndex);
      if (account < 0) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                    title: Text(s.duplicateAccount),
                    content: Text(s.thisAccountAlreadyExists),
                    actions: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text(s.ok),
                          icon: Icon(Icons.done))
                    ]));
      } else {
        active.setActiveAccount(_coin, account);
        final nav = Navigator.of(context);
        if (_keyController.text != "") {
          syncStatus.setAccountRestored(true);
          if (widget.firstAccount) {
            final height = await rescanDialog(context);
            if (height != null) syncStatus.rescan(height);
            nav.pushReplacementNamed('/account');
          } else
            nav.pop();
        } else {
          nav.pushReplacementNamed('/backup',
              arguments: AccountId(_coin, account)); // Need coin type
        }
      }
    }
  }

  _checkKey(String? key) {
    if (key == null) return false;
    final index = _keyRe.firstMatch(key);
    if (index != null) {
      key = index.group(1)!;
    }
    final keyType = WarpApi.validKey(_coin, key);
    final validKey = key == "" || keyType >= 0;
    return validKey;
  }

  void _onScan() async {
    final key = await scanCode(context);
    if (key != null)
      setState(() {
        _keyController.text = key;
        _checkKey(key);
      });
  }

  _toggleShowAccountIndex() {
    setState(() {
      _showIndex = !_showIndex;
    });
  }

  _importLedger() async {
    try {
      final account =
          await WarpApi.importFromLedger(active.coin, _nameController.text);
      active.setActiveAccount(_coin, account);
      Navigator.of(context).pushReplacementNamed("/account");
    } on String catch (msg) {
      showSnackBar(msg, error: true);
    }
  }
}

final _keyRe = RegExp(r"(.*) \[(\d+)\]$");
