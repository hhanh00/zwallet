import 'dart:convert';

import 'package:YWallet/theme_editor.dart';
import 'package:fixnum/fixnum.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';
import 'package:warp_api/warp_api.dart';

import '../accounts.dart';
import '../coin/coin.dart';
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
          Tab(text: s.theme),
        ]),
        actions: [
          IconButton(
            onPressed: _ok,
            icon: Icon(Icons.check),
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
            SingleChildScrollView(child: ThemeEditorTab(appSettings)),
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
      final serverUrl = resolveURL(coins[aa.coin], app.coinSettings);
      WarpApi.updateLWD(aa.coin, serverUrl);
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
            onChanged: (v) => widget.appSettings.fullPrec = v!,
          ),
          FormBuilderSwitch(
            name: 'quick_send',
            title: Text(s.quickSend),
            initialValue: widget.appSettings.quickSend,
            onChanged: (v) => widget.appSettings.quickSend = v!,
          ),
          FormBuilderDropdown<String>(
            name: 'currency',
            decoration: InputDecoration(label: Text(s.currency)),
            initialValue: widget.appSettings.currency,
            items: currencyOptions,
            onChanged: (v) => widget.appSettings.currency = v!,
          ),
          FormBuilderTextField(
            name: 'memo',
            decoration: InputDecoration(
              label: Text(s.defaultMemo),
            ),
            maxLines: 10,
            initialValue: widget.appSettings.memo,
            onChanged: (v) => widget.appSettings.memo = v!,
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
  late final s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();

  final anchorController = TextEditingController();
  final dbPasswdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = Theme.of(context);
    final small = t.textTheme.labelMedium!;
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(children: [
          FormBuilderSwitch(
            name: 'p_open',
            title: Text(s.protectOpen),
            initialValue: widget.appSettings.protectOpen,
            onChanged: (v) => widget.appSettings.protectOpen = v!,
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          FormBuilderSwitch(
            name: 'p_send',
            title: Text(s.protectSend),
            initialValue: widget.appSettings.protectSend,
            onChanged: (v) => widget.appSettings.protectSend = v!,
            validator: validatePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          FormBuilderField<int>(
            name: 'privacy',
            initialValue: widget.appSettings.minPrivacyLevel,
            builder: (field) => InputDecorator(
                decoration: InputDecoration(
                  label: Text(s.minPrivacy),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SegmentedButton(
                    segments: [
                      ButtonSegment(
                          value: 0,
                          label: Text(s.veryLow, style: small.apply(color: Colors.red))),
                      ButtonSegment(
                          value: 1,
                          label: Text(s.low, style: small.apply(color: Colors.orange))),
                      ButtonSegment(
                          value: 2,
                          label: Text(s.medium, style: small.apply(color: Colors.yellow))),
                      ButtonSegment(
                          value: 3,
                          label: Text(s.high, style: small.apply(color: Colors.green))),
                    ],
                    selected: {field.value!},
                    onSelectionChanged: (v) => field.didChange(v.first),
                    showSelectedIcon: false,
                  ),
                )),
            onChanged: (v) => widget.appSettings.minPrivacyLevel = v!,
          ),
          FormBuilderSwitch(
            name: 'gettx',
            title: Text(s.retrieveTransactionDetails),
            initialValue: !widget.appSettings.nogetTx,
            onChanged: (v) => widget.appSettings.nogetTx = v!,
          ),
          FormBuilderField<int>(
            name: 'hide',
            initialValue: widget.appSettings.autoHide,
            builder: (field) => InputDecorator(
              decoration: InputDecoration(
                label: Text(s.autoHideBalance),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: SegmentedButton(
                  segments: [
                    ButtonSegment(value: 0, icon: Icon(Icons.visibility_off)),
                    ButtonSegment(value: 1, icon: Icon(Icons.brightness_auto)),
                    ButtonSegment(value: 2, icon: Icon(Icons.visibility)),
                  ],
                  selected: {field.value},
                  onSelectionChanged: (v) => field.didChange(v.first),
                  showSelectedIcon: false,
                ),
              ),
            ),
            onChanged: (v) => widget.appSettings.autoHide = v!,
          ),
          Divider(),
          FormBuilderTextField(
            name: 'anchor',
            decoration: InputDecoration(
                label: Text(s.confirmations, style: t.textTheme.bodyMedium)),
            initialValue: widget.appSettings.anchorOffset.toString(),
            onChanged: (v) =>
                widget.appSettings.anchorOffset = int.tryParse(v!) ?? 0,
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

  String? validatePassword(bool? v) {
    if (v! && !isMobile() && appStore.dbPassword.isEmpty) return s.noDbPassword;
    return null;
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
            onChanged: (v) => widget.appSettings.messageView = v!,
          ),
          FieldView(
            widget.appSettings.txView,
            name: 'transactions',
            label: s.transactionHistory,
            onChanged: (v) => widget.appSettings.txView = v!,
          ),
          FieldView(
            widget.appSettings.noteView,
            name: 'notes',
            label: s.notes,
            onChanged: (v) => widget.appSettings.noteView = v!,
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
    final small = t.textTheme.labelMedium!;
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
              onChanged: (v) => coinSettings.spamFilter = v!,
            ),
          FormBuilderSwitch(
            name: 'auto_fee',
            initialValue: !coinSettings.manualFee,
            title: Text(s.autoFee),
            onChanged: (v) => setState(() {
              // need rebuild
              coinSettings.manualFee = !v!;
            }),
          ),
          if (coinSettings.manualFee)
            FormBuilderTextField(
              name: 'custom_fee',
              decoration: InputDecoration(label: Text(s.fee)),
              initialValue: fee,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => coinSettings.fee = Int64(stringToAmount(v!)),
            ),
          FormBuilderRadioGroup<int>(
            name: 'server',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.server)),
            initialValue: coinSettings.lwd.index,
            onChanged: (v) => coinSettings.lwd.index = v!,
            options: [
              ...servers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'server_custom',
                    initialValue: coinSettings.lwd.customURL,
                    onChanged: (v) => coinSettings.lwd.customURL = v!,
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          FormBuilderRadioGroup<int>(
            name: 'explorer',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.blockExplorer)),
            initialValue: coinSettings.explorer.index,
            onChanged: (v) => coinSettings.explorer.index = v!,
            options: [
              ...explorers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'explorer_custom',
                    initialValue: coinSettings.explorer.customURL,
                    onChanged: (v) => coinSettings.explorer.customURL = v!,
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          if (aa.hasUA)
            FieldUA(
              coinSettings.uaType,
              label: s.mainUA,
              name: 'main_address',
              onChanged: (v) => coinSettings.uaType = v!,
            ),
          FieldUA(
            coinSettings.replyUa,
            label: s.replyUA,
            name: 'reply_address',
            onChanged: (v) => coinSettings.replyUa = v!,
          ),
          if (aa.hasUA)
            FormBuilderField(
              name: 'z_factor',
              initialValue: coinSettings.zFactor,
              builder: (field) => InputDecorator(
                  decoration: InputDecoration(label: Text(s.zFactor)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SegmentedButton(
                      segments: [
                        ButtonSegment(value: 0, label: Text(s.sapling, style: small)),
                        ButtonSegment(value: 1, label: Text(s.orchard, style: small)),
                        ButtonSegment(value: 2, label: Text(s.optimized, style: small)),
                      ],
                      selected: {field.value},
                      onSelectionChanged: (v) => field.didChange(v.first),
                      showSelectedIcon: false,
                    ),
                  )),
              onChanged: (v) => coinSettings.zFactor = v!,
            )
        ]));
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  bool get wantKeepAlive => true;
}

// class FieldUA2 extends StatelessWidget {
//   final String name;
//   final String label;
//   final int value;
//   final void Function(int?) onChanged;
//   FieldUA2(
//     this.value, {
//     required this.onChanged,
//     required this.name,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return aa.hasUA
//         ? FieldUACheckbox(value, name: name, label: label, onChanged: (v) {
//             final value = v?.sum;
//             onChanged(value);
//           })
//         : FieldUARadio(poolOf(value), name: name, label: label, onChanged: (v) {
//             final value = 1 << (v ?? 0);
//             onChanged(value);
//           });
//   }
// }

class FieldUA extends StatelessWidget {
  final String name;
  final String label;
  late final Set<int> initialValues;
  final void Function(int?)? onChanged;
  FieldUA(int initialValue,
      {required this.name, required this.label, this.onChanged}) {
    initialValues = List.generate(
            3, (index) => initialValue & (1 << index) != 0 ? index : null)
        .whereNotNull()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final small = t.textTheme.labelMedium!;
    return FormBuilderField(
      name: name,
      initialValue: initialValues,
      onChanged: (v) => onChanged?.call(v!.map((index) => 1 << index).sum),
      builder: (field) => InputDecorator(
        decoration: InputDecoration(label: Text(label)),
        child: SegmentedButton(
          segments: [
            ButtonSegment(
                value: 0,
                label: Text(s.transparent,
                    overflow: TextOverflow.ellipsis, style: small)),
            ButtonSegment(
                value: 1,
                label: Text(s.sapling,
                    overflow: TextOverflow.ellipsis, style: small)),
            if (aa.hasUA)
              ButtonSegment(
                  value: 2,
                  label: Text(s.orchard,
                      overflow: TextOverflow.ellipsis, style: small)),
          ],
          selected: field.value!,
          onSelectionChanged: (v) => field.didChange(v),
          multiSelectionEnabled: aa.hasUA,
          showSelectedIcon: false,
        ),
      ),
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
    final t = Theme.of(context);
    final small = t.textTheme.labelMedium!;

    return FormBuilderField<int>(
      name: name,
      initialValue: initialView,
      builder: (field) => InputDecorator(
        decoration: InputDecoration(label: Text(label)),
        child: Align(
          alignment: Alignment.centerRight,
          child: SegmentedButton(
            segments: [
              ButtonSegment(value: 0, label: Text(s.table, style: small)),
              ButtonSegment(value: 1, label: Text(s.list, style: small)),
              ButtonSegment(value: 2, label: Text(s.autoView, style: small)),
            ],
            selected: {field.value},
            onSelectionChanged: (index) => field.didChange(index.first),
            showSelectedIcon: false,
          ),
        ),
      ),
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

String resolveURL(CoinBase c, CoinSettings settings) {
  if (settings.lwd.index >= 0 && settings.lwd.index < c.lwd.length)
    return c.lwd[settings.lwd.index].url;
  else {
    return settings.lwd.customURL;
  }
}
