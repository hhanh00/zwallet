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

class RestorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestorePageState();
}

class _RestorePageState extends State<RestorePage> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _nameController = TextEditingController();
  final _accountIndexController = TextEditingController(text: "0");
  final _shareController = TextEditingController();
  var _validKey = true;
  var _coin = 0;
  var _showIndex = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
        ),
        body: GestureDetector(
          onTap: () { FocusScope.of(context).unfocus(); },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(children: [
                  FormBuilderRadioGroup<int>(
                      orientation: OptionsOrientation.horizontal,
                      name: 'coin',
                      initialValue: _coin,
                      onChanged: (int? v) { _coin = v!; },
                      options: [
                        FormBuilderFieldOption(
                            child: Text('Zcash'), value: 0),
                        FormBuilderFieldOption(
                            child: Text('Ycash'), value: 1),
                      ]),
                  TextFormField(
                      decoration: InputDecoration(labelText: s.accountName),
                      controller: _nameController,
                      validator: (String? name) {
                        if (name == null || name.isEmpty)
                          return s.accountNameIsRequired;
                        return null;
                      },
                    ),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                            labelText: s.key,
                            hintText:
                                s.enterSeed),
                        minLines: 4,
                        maxLines: 4,
                        controller: _keyController,
                        onChanged: _checkKey,
                      )),
                      GestureDetector(onLongPress: _toggleShowAccountIndex,
                        child: IconButton(
                          icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScan))
                    ],
                  ),
                  // if (_isVK && coin.supportsMultisig) Row(
                  //   children: [
                  //     Expanded(
                  //         child: TextFormField(
                  //           decoration: InputDecoration(
                  //               labelText: s.secretShare,
                  //               hintText: s.enterSecretShareIfAccountIsMultisignature),
                  //           minLines: 4,
                  //           maxLines: 4,
                  //           controller: _shareController,
                  //           // TODO: Check share
                  //         )),
                  //     IconButton(
                  //         icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScanShare)
                  //   ],
                  // ),
                  if (_showIndex) TextFormField(
                    decoration: InputDecoration(labelText: s.accountIndex),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    controller: _accountIndexController,
                    validator: (String? name) {
                      if (name == null || name.isEmpty)
                        return s.accountNameIsRequired;
                      return null;
                    },
                  ),

                  ButtonBar(children:
                  confirmButtons(context, _validKey ? _onOK : null, okLabel: s.addnew, okIcon: Icon(Icons.add)))
                ]))))));
  }

  _onOK() async {
    final s = S.of(context);
    final form = _formKey.currentState!;
    final accountIndex = int.parse(_accountIndexController.text);
    if (form.validate()) {
      final account =
        WarpApi.newAccount(_coin, _nameController.text, _keyController.text, accountIndex);
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
      }
      else {
        // if (_shareController.text.isNotEmpty)
        //   accountManager.storeShareSecret(account, _shareController.text);
        // await accountManager.refresh();
        await accounts.refresh();
        if (_keyController.text != "") {
          syncStatus.setAccountRestored(true);
          Navigator.of(context).pop();
        }
        else {
          if (accounts.list.where((e) => e.coin == active.coin).length == 1)
            WarpApi.skipToLastHeight(0); // single new account -> quick sync
          Navigator.of(context).pushReplacementNamed('/backup', arguments: AccountId(_coin, account)); // Need coin type
        }
      }
    }
  }

  _toggleShowAccountIndex() {
    setState(() {
      _showIndex = !_showIndex;
    });
  }

  _checkKey(key) {
    setState(() {
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

  void _onScanShare() async {
    final key = await scanCode(context);
    if (key != null)
      setState(() {
        _shareController.text = key;
      });
  }
}
