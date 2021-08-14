import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'account.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsState();
}

final _settingsFormKey = GlobalKey<FormBuilderState>();

class SettingsState extends State<SettingsPage> {
  var _anchorController =
      MaskedTextController(mask: "00", text: "${settings.anchorOffset}");

  @override
  Widget build(BuildContext context) {
    List<FormBuilderFieldOption> options = coin.lwd.map((lwd) =>
        FormBuilderFieldOption<dynamic>(
            child: Text(lwd.name),
            value: lwd.name)
    ).toList();
    options.add(
      FormBuilderFieldOption(
          value: 'custom',
          child: FormBuilderTextField(
            decoration:
            InputDecoration(labelText: 'Custom'),
            initialValue: settings.ldUrl,
            onSaved: _onURL,
          )),
    );

    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: FormBuilder(
                key: _settingsFormKey,
                child: Observer(
                    builder: (context) => SingleChildScrollView(child: Column(children: [
                          FormBuilderRadioGroup(
                              orientation: OptionsOrientation.vertical,
                              name: 'servers',
                              decoration: InputDecoration(labelText: 'Server'),
                              initialValue: settings.ldUrlChoice,
                              onSaved: _onChoice,
                              options: options),
                          FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'themes',
                              decoration: InputDecoration(labelText: 'Theme'),
                              initialValue: settings.theme,
                              onChanged: _onTheme,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text('Zcash'), value: 'zcash'),
                                FormBuilderFieldOption(
                                    child: Text('Blue'), value: 'blue'),
                                FormBuilderFieldOption(
                                    child: Text('Pink'), value: 'pink'),
                                FormBuilderFieldOption(
                                    child: Text('Coffee'), value: 'coffee'),
                              ]),
                          FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'brightness',
                              initialValue: settings.themeBrightness,
                              onChanged: _onThemeBrightness,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text('Light'), value: 'light'),
                                FormBuilderFieldOption(
                                    child: Text('Dark'), value: 'dark'),
                              ]),
                          Row(children: [
                            SizedBox(width: 100, child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Currency'),
                              value: settings.currency,
                                items: settings.currencies.map((c) =>
                                    DropdownMenuItem(child: Text(c), value: c)).toList(),
                                onChanged: (v) { settings.setCurrency(v); }
                            )),
                          ]),
                          FormBuilderTextField(
                              decoration: InputDecoration(
                                  labelText:
                                      'Number of Confirmations Needed before Spending'),
                              name: 'anchor',
                              keyboardType: TextInputType.number,
                              controller: _anchorController,
                              onSaved: _onAnchorOffset),
                          FormBuilderCheckbox(
                              name: 'get_tx',
                              title: Text('Retrieve Transaction Details'),
                              initialValue: settings.getTx,
                              onSaved: _onGetTx),
                          ButtonBar(children:
                          confirmButtons(context, _onSave))
                        ]))))));
  }

  _onChoice(v) {
    settings.setURLChoice(v);
  }

  _onURL(v) {
    settings.setURL(v);
  }

  _onTheme(v) {
    settings.setTheme(v);
  }

  _onThemeBrightness(v) {
    settings.setThemeBrightness(v);
  }

  _onSave() {
    final form = _settingsFormKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.of(context).pop();
    }
  }

  _onAnchorOffset(v) {
    settings.anchorOffset = int.parse(v);
  }

  _onGetTx(v) {
    settings.updateGetTx(v);
  }

  String _checkFx(String vs) {
    final v = double.tryParse(vs);
    if (v == null) return 'FX rate must be a number';
    if (v <= 0.0) return 'FX rate must be positive';
    return null;
  }
}
