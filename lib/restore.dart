import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warp_api/warp_api.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'backup.dart';
import 'main.dart';
import 'generated/l10n.dart';

class AddAccountPage extends StatefulWidget {
  final bool dismissible;
  AddAccountPage({this.dismissible = true});

  @override
  State<StatefulWidget> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountIndexController = TextEditingController(text: "0");
  final _keyController = TextEditingController();
  var _restore = false;
  var _validKey = true;
  var _coin = 1;
  var _showIndex = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('New Account'),
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
                                _coin = v!;
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
                                  onChanged: _checkKey,
                                )),
                                GestureDetector(
                                    onLongPress: _toggleShowAccountIndex,
                                    child: IconButton(
                                        icon: new Icon(MdiIcons.qrcodeScan),
                                        onPressed: _onScan))
                              ],
                            ),
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
                            if (widget.dismissible) ElevatedButton.icon(
                                icon: Icon(Icons.cancel),
                                label: Text(s.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        t.buttonTheme.colorScheme!.secondary)),
                            ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text(_restore ? 'Import' : 'New'),
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
          WarpApi.newAccount(_coin, _nameController.text, key, accountIndex);
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
        await accounts.refresh();
        if (active.id == 0)
          active.setActiveAccount(_coin, account);
        if (_keyController.text != "") {
          syncStatus.setAccountRestored(true);
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacementNamed('/backup',
              arguments: AccountId(_coin, account)); // Need coin type
        }
      }
    }
  }

  _checkKey(key) {
    setState(() {
      final index = _keyRe.firstMatch(key);
      if (index != null) {
        key = index.group(1)!;
      }
      final keyType = WarpApi.validKey(_coin, key);
      _validKey = key == "" || keyType >= 0;
      // _isVK = keyType == 2;
    });
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
}

final _keyRe = RegExp(r"(.*) \[(\d+)\]$");
