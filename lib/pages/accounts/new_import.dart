import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../store2.dart';

class NewImportAccountPage extends StatefulWidget {
  final bool first;
  NewImportAccountPage({required this.first});

  @override
  State<StatefulWidget> createState() => _NewImportAccountState();
}

class _NewImportAccountState extends State<NewImportAccountPage> {
  int coin = 0;
  final formKey = GlobalKey<FormBuilderState>();
  final nameController = TextEditingController();
  final keyController = TextEditingController();
  late List<FormBuilderFieldOption<int>> options;
  bool _restore = false;

  @override
  void initState() {
    super.initState();
    if (widget.first) nameController.text = 'Main';
    options = coins.map((c) {
      return FormBuilderFieldOption(
          child: ListTile(
            title: Text(c.name),
            trailing: Image(image: c.image, height: 32),
          ),
          value: c.coin);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.newAccount),
        actions: [
          IconButton(onPressed: _settings, icon: Icon(Icons.settings)),
          IconButton(onPressed: _help, icon: Icon(Icons.help)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(labelText: s.accountName),
                  controller: nameController,
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
                  initialValue: coin,
                  onChanged: (int? v) {
                    setState(() {
                      coin = v!;
                    });
                  },
                  options: options,
                ),
                FormBuilderCheckbox(
                  name: 'restore',
                  title: Text(s.restoreAnAccount),
                  onChanged: (v) {
                    setState(() {
                      _restore = v!;
                    });
                  },
                ),
                if (_restore)
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'key',
                          decoration: InputDecoration(
                              labelText: s.key, hintText: s.enterSeed),
                          minLines: 4,
                          maxLines: 4,
                          controller: keyController,
                          validator: _checkKey,
                        ),
                      ),
                    ],
                  ),
                if (_restore && coins[coin].supportsLedger && !isMobile())
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: _importLedger,
                      child: Text('Import From Ledger'),
                    ),
                  ),
                Padding(padding: EdgeInsets.all(4)),
                ButtonBar(children: [
                  if (!widget.first)
                    ElevatedButton.icon(
                      icon: Icon(Icons.cancel),
                      label: Text(s.cancel),
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                    ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text(_restore ? s.import : s.newLabel),
                    onPressed: _onOK,
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onOK() async {
    final s = S.of(context);
    final form = formKey.currentState!;
    if (form.validate()) {
      final account =
          WarpApi.newAccount(coin, nameController.text, keyController.text, 0);
      if (account < 0)
        form.fields['name']!.invalidate(s.thisAccountAlreadyExists);
      else {
        setActiveAccount(coin, account);
        if (widget.first) {
          syncStatus2.setSyncedToLatestHeight(); // first account is synced
          if (keyController.text.isNotEmpty)
            GoRouter.of(context).go('/account/rescan');
          else
            GoRouter.of(context).go('/account');
        }
        else 
            GoRouter.of(context).pop();
      }
    }
  }

  _settings() {
    GoRouter.of(context).push('/settings?coin=$coin');
  }

  String? _checkKey(String? v) {
    final key = keyController.text;
    if (key == "") return null;
    final keyType = WarpApi.validKey(coin, key);
    if (keyType < 0) return S.of(context).invalidKey;
    return null;
  }

  _importLedger() async {
    try {
      final account =
          await WarpApi.importFromLedger(aa.coin, nameController.text);
      setActiveAccount(coin, account);
    } on String catch (msg) {
      formKey.currentState!.fields['key']!.invalidate(msg);
    }
  }

  _help() {}
}
