import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsState();
}

final _settingsFormKey = GlobalKey<FormBuilderState>();

class SettingsState extends State<SettingsPage> {
  var _anchorController = MaskedTextController(mask: "00", text: "${settings.anchorOffset}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Connection Settings')),
        body: Padding(
          padding: EdgeInsets.all(16),
            child: FormBuilder(
                key: _settingsFormKey,
                child: Observer(builder: (context) => Column(children: [
                  FormBuilderRadioGroup(
                      orientation: OptionsOrientation.vertical,
                      name: 'servers',
                      decoration: InputDecoration(labelText: 'Select a server'),
                      initialValue: settings.ldUrlChoice,
                      onSaved: _onChoice,
                      options: [
                        FormBuilderFieldOption(
                            child:
                                Text('Lightwalletd'),
                            value: 'lightwalletd'),
                        FormBuilderFieldOption(
                            child:
                            Text('ZECWallet'),
                            value: 'zecwallet'),
                        FormBuilderFieldOption(
                            value: 'custom',
                        child: FormBuilderTextField(
                          decoration: InputDecoration(labelText: 'Custom'),
                          initialValue: settings.ldUrl,
                          onSaved: _onURL,
                        )),
                      ]),
                  FormBuilderTextField(
                      decoration: InputDecoration(labelText: 'Anchor Offset'),
                    name: 'anchor',
                    keyboardType: TextInputType.number,
                    controller: _anchorController,
                    onSaved: _onAnchorOffset
                  ),
                  ButtonBar(children: [
                    ElevatedButton(child: Text('Cancel'), onPressed: () {
                      Navigator.of(context).pop();
                    }),
                    ElevatedButton(child: Text('OK'), onPressed: _onSave),
                  ])
                ])))));
  }

  _onChoice(v) {
    settings.setURLChoice(v);
  }

  _onURL(v) {
    settings.setURL(v);
  }

  _onSave() {
    _settingsFormKey.currentState.save();
    Navigator.of(context).pop();
  }

  _onAnchorOffset(v) {
    settings.anchorOffset = int.parse(v);
  }
}
