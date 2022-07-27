import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warp_api/warp_api.dart';

import 'generated/l10n.dart';
import 'main.dart';

class KeyToolPage extends StatefulWidget {
  @override
  KeyToolState createState() => KeyToolState();
}

class KeyToolState extends State<KeyToolPage> {
  var _accountController = TextEditingController(text: '0');
  var _externalController = TextEditingController(text: '0');
  var _addressController = TextEditingController(text: '0');
  var _data = 0;

  @override
  Widget build(BuildContext context) {
    final addressIndex = _addressController.text;
    final address = addressIndex.isNotEmpty ? int.parse(addressIndex) : null;
    final kp = WarpApi.deriveZip32(active.coin, active.id,
        int.parse(_accountController.text),
        int.parse(_externalController.text),
        address);

    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.keyTool)),
      body: SingleChildScrollView(
        child: Column(children: [
          FormBuilderTextField(
          decoration: InputDecoration(
          labelText: 'Account Index'),
            name: 'account',
            keyboardType: TextInputType.number,
            controller: _accountController),
          FormBuilderTextField(
              decoration: InputDecoration(
                  labelText: 'External'),
              name: 'external',
              keyboardType: TextInputType.number,
              controller: _externalController),
          FormBuilderTextField(
              decoration: InputDecoration(
                  labelText: 'Address Index'),
              name: 'address',
              keyboardType: TextInputType.number,
              controller: _addressController),
          Card(
            elevation: 1,
            child: Column(children: [
              ListTile(subtitle: Text('Transparent')),
              TextField(
              decoration: InputDecoration(labelText: 'Key'),
                controller: TextEditingController(text: kp.t_key),
                  minLines: 1,
                  maxLines: 3,
                readOnly: true),
              TextField(
                  decoration: InputDecoration(labelText: 'Address'),
                  controller: TextEditingController(text: kp.t_addr),
                  readOnly: true),
              ])
          ),
          Card(
              elevation: 1,
              child: Column(children: [
                ListTile(subtitle: Text('Shielded')),
                TextField(
                    decoration: InputDecoration(labelText: 'Key'),
                    controller: TextEditingController(text: kp.z_key),
                    minLines: 3,
                    maxLines: 10,
                    readOnly: true),
                TextField(
                    decoration: InputDecoration(labelText: 'Address'),
                    controller: TextEditingController(text: kp.z_addr),
                    minLines: 1,
                    maxLines: 3,
                    readOnly: true),
              ])
          ),
          ButtonBar(children: [
            ElevatedButton.icon(onPressed: _onUpdate, icon: Icon(Icons.refresh), label: Text(s.update)),
            ElevatedButton.icon(onPressed: _onClose, icon: Icon(Icons.close), label: Text(s.close)),
          ])
        ])
    ));
  }

  _onUpdate() {
    setState(() {
      _data += 1;
    });
  }

  _onClose() {
    Navigator.of(context).pop();
  }
}
