import 'dart:convert';

import 'package:YWallet/theme_editor.dart';
import 'package:fixnum/fixnum.dart';
import 'package:collection/collection.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';

import '../accounts.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../appsettings.dart' as app;
import '../settings.pb.dart';
import '../store2.dart';
import 'utils.dart';

List<String>? currencies;

class SettingsPage extends StatefulWidget {
  final int coin;
  SettingsPage({required this.coin});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 5, vsync: this);
  final generalKey = GlobalKey<_GeneralState>();
  final privacyKey = GlobalKey<_PrivacyState>();
  final viewKey = GlobalKey<_ViewState>();
  final coinKey = GlobalKey<_CoinState>();
  final AppSettings appSettings = app.appSettings.deepCopy();

  @override
  void initState() {
    super.initState();
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
          Tab(text: s.themeEditor),
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
            SingleChildScrollView(
                child: GeneralTab(appSettings,
                    key: generalKey, currencies: currencies)),
            SingleChildScrollView(
                child: PrivacyTab(appSettings, key: privacyKey)),
            SingleChildScrollView(child: ViewTab(appSettings, key: viewKey)),
            SingleChildScrollView(child: CoinTab(widget.coin, key: coinKey)),
            SingleChildScrollView(
                child: ThemeEditorTab(appSettings
            )),
          ],
        ),
      ),
    );
  }

  _ok() async {
    if (validate()) {
      final prefs = await SharedPreferences.getInstance();
      await appSettings.save(prefs);
      coinKey.currentState?.let((c) => c.coinSettings.save(aa.coin));
      app.appSettings = app.AppSettingsExtension.load(prefs);
      app.coinSettings = app.CoinSettingsExtension.load(aa.coin);
      aaSequence.settingsSeqno = DateTime.now().millisecondsSinceEpoch;
      Future(() async {
        await marketPrice.update();
        aa.currency = appSettings.currency;
      });
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
}

class GeneralTab extends StatefulWidget {
  final List<String>? currencies;
  final AppSettings appSettings;
  GeneralTab(this.appSettings, {super.key, this.currencies});

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
            initialValue: widget.appSettings.fullPrec,
            onChanged: (v) {
              widget.appSettings.fullPrec = v!;
            },
          ),
          FormBuilderSwitch(
            name: 'sound',
            title: Text(s.playSound),
            initialValue: widget.appSettings.sound,
            onChanged: (v) {
              widget.appSettings.sound = v!;
            },
          ),
          FormBuilderDropdown<String>(
            name: 'currency',
            decoration: InputDecoration(label: Text(s.currency)),
            initialValue: widget.appSettings.currency,
            items: currencyOptions,
            onChanged: (v) {
              widget.appSettings.currency = v!;
            },
          ),
          FormBuilderTextField(
            name: 'memo',
            decoration: InputDecoration(
              label: Text(s.defaultMemo),
            ),
            maxLines: 10,
            initialValue: widget.appSettings.memo,
            onChanged: (v) {
              widget.appSettings.memo = v!;
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
  final AppSettings appSettings;
  PrivacyTab(this.appSettings, {super.key});
  @override
  State<StatefulWidget> createState() => _PrivacyState();
}

class _PrivacyState extends State<PrivacyTab>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();

  final anchorController = TextEditingController();
  final dbPasswdController = TextEditingController();

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
            initialValue: widget.appSettings.protectOpen,
            onChanged: (v) {
              widget.appSettings.protectOpen = v!;
            },
          ),
          FormBuilderSwitch(
            name: 'p_send',
            title: Text(s.protectSend),
            initialValue: widget.appSettings.protectSend,
            onChanged: (v) {
              widget.appSettings.protectSend = v!;
            },
          ),
          FormBuilderField<int>(
            name: 'privacy',
            initialValue: widget.appSettings.minPrivacyLevel,
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
              widget.appSettings.minPrivacyLevel = v!;
            },
          ),
          FormBuilderSwitch(
            name: 'gettx',
            title: Text(s.retrieveTransactionDetails),
            initialValue: !widget.appSettings.nogetTx,
            onChanged: (v) {
              widget.appSettings.nogetTx = v!;
            },
          ),
          FormBuilderField<int>(
            name: 'hide',
            initialValue: widget.appSettings.autoHide,
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
              widget.appSettings.autoHide = v!;
            },
          ),
          Divider(),
          FormBuilderTextField(
            name: 'anchor',
            decoration: InputDecoration(
                label: Text(s.confirmations, style: t.textTheme.bodyMedium)),
            initialValue: widget.appSettings.anchorOffset.toString(),
            onChanged: (v) {
              widget.appSettings.anchorOffset = int.tryParse(v!) ?? 0;
            },
          ),
          Divider(),
          if (!isMobile())
            ElevatedButton.icon(
                onPressed: encryptDb,
                icon: Icon(Icons.enhanced_encryption),
                label: Text(s.encryptDatabase))
        ]),
      ),
    );
  }

  encryptDb() {
    GoRouter.of(context).pushReplacement('/encrypt_db');
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  bool get wantKeepAlive => true;
}

class ViewTab extends StatefulWidget {
  final AppSettings appSettings;
  ViewTab(this.appSettings, {super.key});
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
            widget.appSettings.messageView,
            name: 'messages',
            label: s.messages,
            onChanged: (v) {
              widget.appSettings.messageView = v!;
            },
          ),
          FieldView(
            widget.appSettings.txView,
            name: 'transactions',
            label: s.transactionHistory,
            onChanged: (v) {
              widget.appSettings.txView = v!;
            },
          ),
          FieldView(
            widget.appSettings.noteView,
            name: 'notes',
            label: s.notes,
            onChanged: (v) {
              widget.appSettings.noteView = v!;
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
  final int coin;
  CoinTab(this.coin, {super.key});
  @override
  State<StatefulWidget> createState() => _CoinState();
}

class _CoinState extends State<CoinTab> with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();
  late final CoinSettings coinSettings;

  @override
  void initState() {
    super.initState();
    coinSettings = app.CoinSettingsExtension.load(aa.coin);
    coinSettings.lwd =
        coinSettings.lwd.deepCopy(); // otherwise they cannot be edited
    coinSettings.explorer = coinSettings.explorer.deepCopy();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    final t = Theme.of(context);
    final c = coins[widget.coin];
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
    final fee = amountToString2(coinSettings.fee.toInt());

    return FormBuilder(
        key: formKey,
        child: Column(children: [
          if (aa.hasUA)
            FormBuilderSwitch(
              name: 'spam',
              initialValue: coinSettings.spamFilter,
              title: Text(s.antispamFilter),
              onChanged: (v) {
                coinSettings.spamFilter = v!;
              },
            ),
          FormBuilderSwitch(
            name: 'auto_fee',
            initialValue: !coinSettings.manualFee,
            title: Text(s.autoFee),
            onChanged: (v) => setState(() {
              coinSettings.manualFee = !v!;
            }),
          ),
          if (coinSettings.manualFee)
            FormBuilderTextField(
              name: 'custom_fee',
              decoration: InputDecoration(label: Text(s.fee)),
              initialValue: fee,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                coinSettings.fee = Int64(stringToAmount(v!));
              },
            ),
          FormBuilderRadioGroup<int>(
            name: 'server',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.server)),
            initialValue: coinSettings.lwd.index,
            onChanged: (v) {
              coinSettings.lwd.index = v!;
            },
            options: [
              ...servers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'server_custom',
                    initialValue: coinSettings.lwd.customURL,
                    onChanged: (v) {
                      coinSettings.lwd.customURL = v!;
                    },
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          FormBuilderRadioGroup<int>(
            name: 'explorer',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.blockExplorer)),
            initialValue: coinSettings.explorer.index,
            onChanged: (v) {
              coinSettings.explorer.index = v!;
            },
            options: [
              ...explorers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'explorer_custom',
                    initialValue: coinSettings.explorer.customURL,
                    onChanged: (v) {
                      coinSettings.explorer.customURL = v!;
                    },
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          if (aa.hasUA)
            FieldUACheckbox(
              coinSettings.uaType,
              label: s.mainUA,
              name: 'main_address',
              onChanged: (v) {
                coinSettings.uaType = v?.sum ?? 0;
              },
            ),
          FieldUA(
            coinSettings.replyUa,
            label: s.replyUA,
            name: 'reply_address',
            onChanged: (v) {
              coinSettings.replyUa = v!;
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

class FieldUA extends StatelessWidget {
  final String name;
  final String label;
  final int value;
  final void Function(int?) onChanged;
  FieldUA(
    this.value, {
    required this.onChanged,
    required this.name,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return aa.hasUA
        ? FieldUACheckbox(value, name: name, label: label, onChanged: (v) {
            final value = v?.sum;
            onChanged(value);
          })
        : FieldUARadio(poolOf(value), name: name, label: label, onChanged: (v) {
            final value = 1 << (v ?? 0);
            onChanged(value);
          });
  }
}

class FieldUACheckbox extends StatelessWidget {
  final String name;
  final String label;
  late final List<int> initialValues;
  final void Function(List<int>?)? onChanged;
  FieldUACheckbox(int initialValue,
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
        if (aa.hasUA) FormBuilderChipOption(value: 4, child: Text(s.orchard)),
      ],
      onChanged: onChanged,
    );
  }
}

class FieldUARadio extends StatelessWidget {
  final int initialValue;
  final String name;
  final String label;
  final void Function(int?)? onChanged;
  FieldUARadio(this.initialValue,
      {required this.name, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilderChoiceChip(
      name: name,
      decoration: InputDecoration(label: Text(label)),
      initialValue: initialValue,
      spacing: 4,
      options: [
        FormBuilderChipOption(value: 0, child: Text(s.transparent)),
        FormBuilderChipOption(value: 1, child: Text(s.sapling)),
        if (aa.hasUA) FormBuilderChipOption(value: 2, child: Text(s.orchard)),
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
