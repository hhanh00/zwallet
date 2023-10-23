import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:collection/collection.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../accounts.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../appsettings.dart';
import '../main.dart';
import '../settings.pb.dart';

var _settings0 = AppSettings();
var _settings = AppSettings();
var _coinSettings0 = CoinSettings();
var _coinSettings = CoinSettings();
List<String>? currencies;

class SettingsPage extends StatefulWidget {
  final int coin;
  SettingsPage({required this.coin});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 4, vsync: this);
  final generalKey = GlobalKey<_GeneralState>();
  final privacyKey = GlobalKey<_PrivacyState>();
  final viewKey = GlobalKey<_ViewState>();
  final coinKey = GlobalKey<_CoinState>();

  @override
  void initState() {
    super.initState();
    _settings0 = appSettings;
    _coinSettings0 = coinSettings;
    _coinSettings.lwd = ServerURL();
    _coinSettings.explorer = ServerURL();
    if (currencies == null) {
      currencies = [];
      Future(() async {
        currencies = await fetchCurrencies();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = coins[widget.coin];
    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings),
        bottom: TabBar(controller: tabController, isScrollable: true, tabs: [
          Tab(text: s.general),
          Tab(text: s.priv),
          Tab(text: s.views),
          Tab(text: c.name),
        ]),
        actions: [
          ElevatedButton.icon(
            onPressed: _ok,
            icon: Icon(Icons.check),
            label: Text(s.ok),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TabBarView(
          controller: tabController,
          children: [
            SingleChildScrollView(child: GeneralTab(key: generalKey, currencies: currencies)),
            SingleChildScrollView(child: PrivacyTab(key: privacyKey)),
            SingleChildScrollView(child: ViewTab(key: viewKey)),
            SingleChildScrollView(child: CoinTab(key: coinKey)),
          ],
        ),
      ),
    );
  }

  _ok() async {
    if (validate()) {
      save();
      final prefs = await SharedPreferences.getInstance();
      await _settings0.save(prefs);
      _coinSettings0.save();
      appSettings = AppSettingsExtension.load(prefs);
      coinSettings = CoinSettingsExtension.load(aa.coin);
      GoRouter.of(context).pop();
    }
  }

  bool validate() {
    if (!(generalKey.currentState?.validate() ?? true)) return false;
    if (!(privacyKey.currentState?.validate() ?? true)) return false;
    if (!(viewKey.currentState?.validate() ?? true)) return false;
    if (!(coinKey.currentState?.validate() ?? true)) return false;
    return true;
  }

  void save() {
    _settings0.mergeFromMessage(_settings);
    _coinSettings0.mergeFromMessage(_coinSettings);
  }
}

class GeneralTab extends StatefulWidget {
  final List<String>? currencies;
  GeneralTab({super.key, this.currencies});

  @override
  State<StatefulWidget> createState() => _GeneralState();
}

class _GeneralState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    final currencyOptions = widget.currencies
            ?.map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList() ??
        [];

    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          FormBuilderSwitch(
            name: 'full_prec',
            title: Text(s.useZats),
            initialValue: _settings0.fullPrec,
            onChanged: (v) {
              _settings.fullPrec = v!;
            },
          ),
          FormBuilderSwitch(
            name: 'sound',
            title: Text(s.playSound),
            initialValue: _settings0.sound,
            onChanged: (v) {
              _settings.sound = v!;
            },
          ),
          FormBuilderDropdown<String>(
            name: 'currency',
            decoration: InputDecoration(label: Text(s.currency)),
            initialValue: _settings0.currency,
            items: currencyOptions,
            onChanged: (v) {
              _settings.currency = v!;
            },
          ),
          FieldUA(
            _settings0.uaType,
            label: s.mainUA,
            name: 'main_address',
            onChanged: (v) {
              _settings.uaType = v?.sum ?? 0;
            },
          ),
          FieldUA(
            _settings0.replyUa,
            label: s.replyUA,
            name: 'reply_address',
            onChanged: (v) {
              _settings.replyUa = v?.sum ?? 0;
            },
          ),
          FormBuilderTextField(
            name: 'memo',
            decoration: InputDecoration(
              label: Text(s.defaultMemo),
            ),
            maxLines: 10,
            initialValue: _settings0.memo,
            onChanged: (v) {
              _settings.memo = v!;
            },
          )
        ],
      ),
    );
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  bool get wantKeepAlive => true;
}

class PrivacyTab extends StatefulWidget {
  PrivacyTab({super.key});
  @override
  State<StatefulWidget> createState() => _PrivacyState();
}

class _PrivacyState extends State<PrivacyTab>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();

  final anchorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    final t = Theme.of(context);
    final levels = [s.veryLow, s.low, s.medium, s.high];
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(children: [
          FormBuilderSwitch(
            name: 'p_open',
            title: Text(s.protectOpen),
            initialValue: _settings0.protectOpen,
            onChanged: (v) {
              _settings.protectOpen = v!;
            },
          ),
          FormBuilderSwitch(
            name: 'p_send',
            title: Text(s.protectSend),
            initialValue: _settings0.protectSend,
            onChanged: (v) {
              _settings.protectSend = v!;
            },
          ),
          FormBuilderField<int>(
            name: 'privacy',
            initialValue: _settings0.minPrivacyLevel,
            builder: (field) => ListTile(
              contentPadding:
                  EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 8),
              title: Text(s.minPrivacy, style: t.textTheme.bodyMedium),
              trailing: AnimatedToggleSwitch<int>.size(
                current: field.value ?? 0,
                values: [0, 1, 2, 3],
                style: ToggleStyle(
                    indicatorColor: t.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    borderColor: t.disabledColor),
                styleBuilder: (i) {
                  final colors = [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green
                  ];
                  return ToggleStyle(indicatorColor: colors[i]);
                },
                customIconBuilder: (context, local, g) {
                  return Center(
                      child: Text(levels[local.index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: t.sliderTheme.activeTrackColor)));
                },
                onChanged: (v) {
                  field.didChange(v);
                },
              ),
            ),
            onChanged: (v) {
              _settings.minPrivacyLevel = v!;
            },
          ),
          FormBuilderSwitch(
            name: 'gettx',
            title: Text(s.retrieveTransactionDetails),
            initialValue: !_settings0.nogetTx,
            onChanged: (v) {
              _settings.nogetTx = v!;
            },
          ),
          FormBuilderField<int>(
            name: 'hide',
            initialValue: _settings0.autoHide,
            builder: (field) => ListTile(
              contentPadding:
                  EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 8),
              title: Text(s.autoHideBalance, style: t.textTheme.bodyMedium),
              trailing: AnimatedToggleSwitch<int>.size(
                current: field.value!,
                values: [0, 1, 2],
                style: ToggleStyle(
                    indicatorColor: t.primaryColor,
                    borderColor: t.disabledColor),
                iconList: [
                  Icon(Icons.visibility_off),
                  Icon(Icons.brightness_auto),
                  Icon(Icons.visibility),
                ],
                onChanged: (v) {
                  field.didChange(v);
                },
              ),
            ),
            onChanged: (v) {
              _settings.autoHide = v!;
            },
          ),
          Divider(),
          FormBuilderTextField(
            name: 'anchor',
            decoration: InputDecoration(
                label: Text(s.confirmations, style: t.textTheme.bodyMedium)),
            initialValue: _settings0.anchorOffset.toString(),
            onChanged: (v) {
              _settings.anchorOffset = int.tryParse(v!) ?? 0;
            },
          ),
        ]),
      ),
    );
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  bool get wantKeepAlive => true;
}

class ViewTab extends StatefulWidget {
  ViewTab({super.key});
  @override
  State<StatefulWidget> createState() => _ViewState();
}

class _ViewState extends State<ViewTab> with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    return FormBuilder(
        key: formKey,
        child: Column(children: [
          FieldView(
            _settings0.messageView,
            name: 'messages',
            label: s.messages,
            onChanged: (v) {
              _settings.messageView = v!;
            },
          ),
          FieldView(
            _settings0.txView,
            name: 'transactions',
            label: s.transactionHistory,
            onChanged: (v) {
              _settings.txView = v!;
            },
          ),
          FieldView(
            _settings0.noteView,
            name: 'notes',
            label: s.notes,
            onChanged: (v) {
              _settings.noteView = v!;
            },
          ),
        ]));
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  bool get wantKeepAlive => true;
}

class CoinTab extends StatefulWidget {
  CoinTab({super.key});
  @override
  State<StatefulWidget> createState() => _CoinState();
}

class _CoinState extends State<CoinTab> with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();
  late final CoinSettings coinSettings;

  @override
  void initState() {
    super.initState();
    coinSettings = CoinSettingsExtension.load(aa.coin);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    final t = Theme.of(context);
    final c = coins[aa.coin];
    final servers = c.lwd
        .asMap()
        .entries
        .map((kv) =>
            FormBuilderFieldOption(value: kv.key, child: Text(kv.value.name)))
        .toList();
    final explorers = c.blockExplorers
        .asMap()
        .entries
        .map((kv) =>
            FormBuilderFieldOption(value: kv.key, child: Text(kv.value)))
        .toList();
    final fee = amountToString2(_coinSettings0.fee.toInt());

    return FormBuilder(
        key: formKey,
        child: Column(children: [
          FormBuilderSwitch(
            name: 'spam',
            initialValue: _coinSettings0.spamFilter,
            title: Text(s.antispamFilter),
            onChanged: (v) { _coinSettings.spamFilter = v!; },
          ),
          FormBuilderSwitch(
            name: 'auto_fee',
            initialValue: !_coinSettings0.manualFee,
            title: Text(s.autoFee),
            onChanged: (v) => setState(() { _coinSettings.manualFee = !v!; }),
          ),
          if (_coinSettings.manualFee) FormBuilderTextField(
            name: 'custom_fee',
            decoration: InputDecoration(label: Text(s.fee)),
            initialValue: fee,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) { _coinSettings.fee = Int64(stringToAmount(v!)); },
          ),
          FormBuilderRadioGroup<int>(
            name: 'server',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.server)),
            initialValue: _coinSettings0.lwd.index,
            onChanged: (v) { _coinSettings.lwd.index = v!; },
            options: [
              ...servers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'server_custom',
                    initialValue: _coinSettings0.lwd.customURL,
                    onChanged: (v) { _coinSettings.lwd.customURL = v!; },
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          FormBuilderRadioGroup<int>(
            name: 'explorer',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.blockExplorer)),
            initialValue: _coinSettings0.explorer.index,
            onChanged: (v) { _coinSettings.explorer.index = v!; },
            options: [
              ...explorers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'explorer_custom',
                    initialValue: _coinSettings0.explorer.customURL,
                    onChanged: (v) { _coinSettings.explorer.customURL = v!; },
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
        ]));
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  bool get wantKeepAlive => true;
}

class FieldUA extends StatelessWidget {
  final String name;
  final String label;
  late final List<int> initialValues;
  final void Function(List<int>?)? onChanged;
  FieldUA(int initialValue,
      {required this.name, required this.label, this.onChanged}) {
    List<int> fs = [];
    int v = 1;
    for (var i = 0; i < 3; i++) {
      if (initialValue & 1 != 0) fs.add(v);
      v *= 2;
      initialValue ~/= 2;
    }
    initialValues = fs;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilderFilterChip(
      name: name,
      decoration: InputDecoration(label: Text(label)),
      spacing: 4,
      initialValue: initialValues,
      options: [
        FormBuilderChipOption(value: 1, child: Text(s.transparent)),
        FormBuilderChipOption(value: 2, child: Text(s.sapling)),
        FormBuilderChipOption(value: 4, child: Text(s.orchard)),
      ],
      onChanged: onChanged,
    );
  }
}

class FieldView extends StatelessWidget {
  final int initialView;
  final String name;
  final String label;
  final void Function(int?)? onChanged;
  FieldView(this.initialView,
      {required this.name, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return FormBuilderChoiceChip(
      name: name,
      decoration: InputDecoration(label: Text(label)),
      initialValue: initialView,
      spacing: 4,
      options: [
        FormBuilderChipOption(value: 0, child: Text(s.table)),
        FormBuilderChipOption(value: 1, child: Text(s.list)),
        FormBuilderChipOption(value: 2, child: Text(s.autoView)),
      ],
      onChanged: onChanged,
    );
  }
}

Future<List<String>?> fetchCurrencies() async {
  try {
    final base = "api.coingecko.com";
    final uri = Uri.https(base, '/api/v3/simple/supported_vs_currencies');
    final rep = await http.get(uri);
    if (rep.statusCode == 200) {
      final currencies = jsonDecode(rep.body) as List<dynamic>;
      final c = currencies.map((v) => (v as String).toUpperCase()).toList();
      c.sort();
      return c;
    }
  } catch (_) {}
  return null;
}
