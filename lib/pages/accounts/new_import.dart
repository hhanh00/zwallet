import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';

import '../../store.dart';
import '../utils.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../pages/widgets.dart';

class NewImportAccountPage extends StatefulWidget {
  final bool first;
  final SeedInfo? seedInfo;
  NewImportAccountPage({required this.first, this.seedInfo});

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
  int? _birthHeight;
  late List<FormBuilderFieldOption<int>> options;
  bool _restore = false;

  @override
  void initState() {
    super.initState();
    if (widget.first) nameController.text = 'Main';
    final si = widget.seedInfo;
    if (si != null) {
      _restore = true;
      _key = si.seed;
      accountIndexController.text = si.index.toString();
    }
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
                  enableSuggestions: true,
                  validator: FormBuilderValidators.required()
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
                    ),
                    Gap(8),
                    HeightPicker(syncStatus.syncedHeight, label: Text(s.birthHeight),
                    onChanged: (h) => _birthHeight = h,)
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
        if (_key.isEmpty)
          _key = await warp.generateSeed();
        final account = await warp.createAccount(
            coin, nameController.text, _key, index, _birthHeight ?? syncStatus.syncedHeight);
        if (account < 0)
          form.fields['name']!.invalidate(s.thisAccountAlreadyExists);
        else {
          await setActiveAccount(coin, account);
          await aa.save();
          final accounts = warp.listAccounts(coin);
          if (accounts.length == 1) {
            // First account of a coin is synced
            await warp.resetChain(coin, syncStatus.latestHeight ?? 0);
          } 
          if (widget.first) {
            if (_key.isNotEmpty)
              GoRouter.of(context).go('/account/rescan');
            else
              GoRouter.of(context).go('/account');
          }
          else
            GoRouter.of(context).pop();
        }
      });
    }
  }

  String? _checkKey(String? v) {
    if (v == null || v.isEmpty) return null;
    // if (WarpApi.isValidTransparentKey(v)) return s.cannotUseTKey;
    // final keyType = WarpApi.validKey(coin, v);
    // if (keyType < 0) return s.invalidKey;
    return null;
  }

  // _importLedger() async {
  //   try {
  //     final account =
  //         await WarpApi.importFromLedger(aa.coin, nameController.text);
  //     setActiveAccount(coin, account);
  //   } on String catch (msg) {
  //     formKey.currentState!.fields['key']!.invalidate(msg);
  //   }
  // }
}
