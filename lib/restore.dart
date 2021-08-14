import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:warp_api/warp_api.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'main.dart';

class RestorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestorePageState();
}

class _RestorePageState extends State<RestorePage> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _nameController = TextEditingController();
  var _validKey = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("\u24E8 Wallet"),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Account Name'),
                    controller: _nameController,
                    validator: (String name) {
                      if (name == null || name.isEmpty)
                        return "Account name is required";
                      return null;
                    },
                  ),
                  Row(
                    // padding: EdgeInsets.all(8),
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 2.0),
                    // ),
                    children: [
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Key',
                            hintText:
                                'Enter Seed, Secret Key or Viewing Key. Leave blank for a new account'),
                        minLines: 4,
                        maxLines: 4,
                        controller: _keyController,
                        onChanged: _checkKey,
                      )),
                      IconButton(
                          icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScan)
                    ],
                  ),
                  ButtonBar(children:
                  confirmButtons(context, _validKey ? _onOK : null, okLabel: 'ADD', okIcon: Icon(Icons.add)))
                ]))));
  }

  _onOK() async {
    if (_formKey.currentState.validate()) {
      final account =
          WarpApi.newAccount(_nameController.text, _keyController.text);
      await accountManager.refresh();
      await accountManager.setActiveAccountId(account);
      if (accountManager.accounts.length == 1) {
        if (_keyController.text == "")
          WarpApi.skipToLastHeight(); // single new account -> quick sync
        else {
          final snackBar = SnackBar(content: Text("Scan starting momentarily"));
          rootScaffoldMessengerKey.currentState.showSnackBar(snackBar);
          WarpApi.rewindToHeight(0);
        }
      }
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/account');
    }
  }

  _onCancel() {
    Navigator.of(context).pop();
  }

  _checkKey(key) {
    setState(() {
      _validKey = key == "" || WarpApi.validKey(key);
    });
  }

  void _onScan() async {
    var code = await BarcodeScanner.scan();
    setState(() {
      final key = code.rawContent;
      _keyController.text = key;
      _validKey = key == "" || WarpApi.validKey(key);
    });
  }
}
