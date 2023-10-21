import 'dart:convert';

import 'package:YWallet/store2.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';

import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../appsettings.dart';
import '../main.dart';
import '../settings.pb.dart';

late AppSettings settings;

class SettingsPage extends StatefulWidget {
  final int coin;
  SettingsPage({required this.coin});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormBuilderState>();
  late final tabController = TabController(length: 4, vsync: this);

  List<String>? currencies;

  @override
  void initState() {
    super.initState();
    settings = appSettings.deepCopy();
    Future(() async {
      currencies = await fetchCurrencies();
      setState(() {});
    });
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
            GeneralTab(currencies: currencies),
            PrivacyTab(),
            ViewTab(),
            CoinTab(),
          ],
        ),
      ),
    );
  }

  _ok() async {
    final prefs = await SharedPreferences.getInstance();
    await settings.save(prefs);
    loadAppSettings(prefs);
    GoRouter.of(context).pop();
  }
}

class GeneralTab extends StatefulWidget {
  final List<String>? currencies;
  GeneralTab({this.currencies});

  @override
  State<StatefulWidget> createState() => _GeneralState();
}

class _GeneralState extends State<GeneralTab> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final ap = appSettings;
    final s = S.of(context);
    final t = Theme.of(context);
    final currencyOptions = widget.currencies
            ?.map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList() ??
        [];

    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          FormBuilderSwitch(name: 'full_prec', title: Text(s.useZats)),
          FormBuilderSwitch(name: 'sound', title: Text(s.playSound)),
          FormBuilderDropdown<String>(
              name: 'currency',
              decoration: InputDecoration(label: Text(s.currency)),
              initialValue: ap.currency,
              items: currencyOptions),
          FieldUA(ap.uaType, label: s.mainUA, name: 'main_address'),
          FieldUA(ap.replyUa, label: s.replyUA, name: 'reply_address'),
        ],
      ),
    );
  }
}

class PrivacyTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PrivacyState();
}

class _PrivacyState extends State<PrivacyTab> {
  bool advanced = settings.advanced;
  final formKey = GlobalKey<FormBuilderState>();

  final anchorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final levels = [s.veryLow, s.low, s.medium, s.high];
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(children: [
          FormBuilderSwitch(name: 'p_open', title: Text(s.protectOpen)),
          FormBuilderSwitch(name: 'p_send', title: Text(s.protectSend)),
          FormBuilderField<int>(
            name: 'privacy',
            initialValue: appSettings.minPrivacyLevel,
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
          ),
          FormBuilderSwitch(
              name: 'gettx', title: Text(s.retrieveTransactionDetails)),
          FormBuilderField(
            name: 'hide',
            initialValue: appSettings.autoHide,
            builder: (field) => ListTile(
              contentPadding:
                  EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 8),
              title: Text(s.autoHideBalance, style: t.textTheme.bodyMedium),
              trailing: AnimatedToggleSwitch.size(
                current: field.value,
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
          ),
          Divider(),
          FormBuilderTextField(
            name: 'anchor',
            decoration: InputDecoration(
                label: Text(s.confirmations, style: t.textTheme.bodyMedium)),
            controller: anchorController,
          ),
        ]),
      ),
    );
  }

  _mode(bool? v) {
    if (v == null) return;
    setState(() {
      advanced = v;
      settings.advanced = v;
    });
  }
}

class ViewTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateViewState();
}

class _StateViewState extends State<ViewTab> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final ap = appSettings;
    final s = S.of(context);
    final t = Theme.of(context);
    return FormBuilder(
        key: formKey,
        child: Column(children: [
          FieldView(2, name: 'messages', label: s.messages),
          FieldView(2, name: 'transactions', label: s.transactionHistory),
          FieldView(2, name: 'notes', label: s.notes),
        ]));
  }
}

class CoinTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoinState();
}

class _CoinState extends State<CoinTab> {
  final formKey = GlobalKey<FormBuilderState>();
  late final CoinSettings coinSettings;

  @override
  void initState() {
    super.initState();
    coinSettings = getCoinSettings(active.coin);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final c = coins[active.coin];
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

    return FormBuilder(
        key: formKey,
        child: Column(children: [
          FormBuilderRadioGroup(
              name: 'server',
              orientation: OptionsOrientation.vertical,
              decoration: InputDecoration(label: Text(s.server)),
              options: [
                ...servers,
                FormBuilderFieldOption(
                    value: -1,
                    child: TextField(
                      decoration: null,
                      style: t.textTheme.bodyMedium,
                    )),
              ]),
          FormBuilderRadioGroup(
              name: 'explorer',
              orientation: OptionsOrientation.vertical,
              decoration: InputDecoration(label: Text(s.blockExplorer)),
              options: [
                ...explorers,
                FormBuilderFieldOption(
                    value: -1,
                    child: TextField(
                      decoration: null,
                      style: t.textTheme.bodyMedium,
                    )),
              ]),
        ]));
  }
}

class FieldUA extends StatelessWidget {
  final int initalType;
  final String name;
  final String label;
  final void Function(int)? onChanged;
  FieldUA(this.initalType,
      {required this.name, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilderFilterChip(
        name: name,
        decoration: InputDecoration(label: Text(label)),
        spacing: 4,
        options: [
          FormBuilderChipOption(value: 1, child: Text(s.transparent)),
          FormBuilderChipOption(value: 2, child: Text(s.sapling)),
          FormBuilderChipOption(value: 4, child: Text(s.orchard)),
        ]);
  }
}

class FieldView extends StatelessWidget {
  final int initialView;
  final String name;
  final String label;
  final void Function(int)? onChanged;
  FieldView(this.initialView,
      {required this.name, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    // return FormBuilderField(
    //     name: name,
    //     builder: (field) {
    //       return InputDecorator(
    //         decoration: InputDecoration(label: Text(label)),
    //         child: Padding(
    //           padding: EdgeInsets.all(8),
    //           child: Wrap(
    //             runSpacing: 8,
    //             children: [
    //               ChoiceChip(
    //                 label: Text(s.table),
    //                 selected: true,
    //                 onSelected: (v) {},
    //                 // labelStyle: t.chipTheme.labelStyle,
    //               ),
    //               ChoiceChip(label: Text(s.list), selected: false, onSelected: (v) {},),
    //               ChoiceChip(label: Text(s.autoView), selected: false, onSelected: (v) {},),
    //             ],
    //           ),
    //         ),
    //       );
    //     });

    return FormBuilderChoiceChip(
        name: name,
        decoration: InputDecoration(label: Text(label)),
        spacing: 4,
        options: [
          FormBuilderChipOption(value: 0, child: Text(s.table)),
          FormBuilderChipOption(value: 1, child: Text(s.list)),
          FormBuilderChipOption(value: 2, child: Text(s.autoView)),
        ]);
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
  } catch (_) {
    return null;
  }
}
