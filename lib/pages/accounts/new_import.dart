import 'package:YWallet/pages/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/warp_api.dart';

import '../utils.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';

class NewImportAccountPage extends StatefulWidget {
  final bool first;
  NewImportAccountPage({required this.first});

  @override
  State<StatefulWidget> createState() => _NewImportAccountState();
}

class _NewImportAccountState extends State<NewImportAccountPage>
    with WithLoadingAnimation {
  late final s = S.of(context);
  int coin = 0;
  final formKey = GlobalKey<FormBuilderState>();
  final nameController = TextEditingController();
  String _key = '';
  final accountIndexController = TextEditingController(text: '0');
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
    return wrapWithLoading(Scaffold(
      appBar: AppBar(
        title: Text(s.newAccount),
        actions: [
          IconButton(onPressed: _settings, icon: Icon(Icons.settings)),
          IconButton(onPressed: _onOK, icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                Image.asset('assets/icon.png', height: 128),
                Gap(16),
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
                FormBuilderSwitch(
                  name: 'restore',
                  title: Text(s.restoreAnAccount),
                  onChanged: (v) {
                    setState(() {
                      _restore = v!;
                    });
                  },
                ),
                if (_restore)
                  Column(children: [
                    InputTextQR(
                      _key,
                      label: s.key,
                      lines: 4,
                      onChanged: (v) => setState(() => _key = v!),
                      validator: _checkKey,
                    ),
                    Gap(8),
                    FormBuilderTextField(
                      name: 'account_index',
                      decoration: InputDecoration(label: Text(s.accountIndex)),
                      controller: accountIndexController,
                      keyboardType: TextInputType.number,
                    )
                  ]),
                // TODO: Ledger
                // if (_restore && coins[coin].supportsLedger && !isMobile())
                //   Padding(
                //     padding: EdgeInsets.all(8),
                //     child: ElevatedButton(
                //       onPressed: _importLedger,
                //       child: Text('Import From Ledger'),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  _onOK() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      await load(() async {
        final index = int.parse(accountIndexController.text);
        final account = await WarpApi.newAccount(
            coin, nameController.text, _key, index);
        if (account < 0)
          form.fields['name']!.invalidate(s.thisAccountAlreadyExists);
        else {
          setActiveAccount(coin, account);
          final prefs = await SharedPreferences.getInstance();
          await aa.save(prefs);
          if (widget.first) {
            await WarpApi.skipToLastHeight(coin); // first account is synced
            if (_key.isNotEmpty)
              GoRouter.of(context).go('/account/rescan');
            else
              GoRouter.of(context).go('/account');
          } else
            GoRouter.of(context).pop();
        }
      });
    }
  }

  _settings() {
    GoRouter.of(context).push('/settings?coin=$coin');
  }

  String? _checkKey(String? v) {
    if (v == null || v.isEmpty) return null;
    if (WarpApi.isValidTransparentKey(v)) return s.cannotUseTKey;
    final keyType = WarpApi.validKey(coin, v);
    if (keyType < 0) return s.invalidKey;
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
}
