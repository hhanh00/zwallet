import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';
import 'package:warp/warp.dart';

import '../accounts.dart';
import '../theme_editor.dart';
import '../coin/coin.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../appsettings.dart' as app;
import '../settings.pb.dart';
import '../store.dart';
import 'utils.dart';

late List<String> currencies;

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
  final appSettings = app.appSettings.deepCopy();
  final coinSettings = app.coinSettings.deepCopy();

  @override
  void initState() {
    super.initState();
    currencies = [appSettings.currency];
    coinSettings.lwd =
        coinSettings.lwd.deepCopy(); // otherwise they cannot be edited
    coinSettings.explorer = coinSettings.explorer.deepCopy();
    Future(() async {
      final _currencies = await fetchCurrencies();
      if (_currencies != null) {
        setState(() {
          currencies = _currencies;
        });
      }
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
            SingleChildScrollView(
                child: CoinTab(widget.coin, coinSettings, key: coinKey)),
            SingleChildScrollView(child: ThemeEditorTab(appSettings)),
          ],
        ),
      ),
    );
  }

  _ok() async {
    if (validate()) {
      final prefs = GetIt.I.get<SharedPreferences>();
      await appSettings.save(prefs);
      coinKey.currentState?.let((c) => coinSettings.save(aa.coin));
      app.appSettings = app.AppSettingsExtension.load(prefs);
      app.coinSettings = await app.CoinSettingsExtension.load(aa.coin);
      final serverUrl = resolveURL(coins[aa.coin], app.coinSettings);
      warp.configure(aa.coin,
          url: serverUrl,
          warp: app.coinSettings.warpUrl,
          warpEndHeight: app.coinSettings.warpHeight);
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
    final t = Theme.of(context);
    final small = t.textTheme.labelMedium!;
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
            name: 'custom_send',
            title: Text(s.customSend),
            initialValue: widget.appSettings.customSend,
            onChanged: (v) => widget.appSettings.customSend = v!,
          ),
          if (isMobile())
            FormBuilderField(
              name: 'background_sync',
              initialValue: Set.of([widget.appSettings.backgroundSync]),
              onChanged: (v) => widget.appSettings.backgroundSync = v!.first,
              builder: (field) => InputDecorator(
                decoration: InputDecoration(
                  label: Text(s.backgroundSync),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SegmentedButton<int>(
                      selected: field.value!,
                      showSelectedIcon: false,
                      onSelectionChanged: (v) => field.didChange(v),
                      segments: [
                        ButtonSegment(
                          value: 0,
                          label: Text(s.off, style: small),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: Text(s.wifi, style: small),
                        ),
                        ButtonSegment(
                          value: 2,
                          label: Text(s.any, style: small),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
            enableSuggestions: true,
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
          if (isMobile())
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
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SegmentedButton(
                        segments: [
                          ButtonSegment(
                              value: 0,
                              label: Text(s.veryLow,
                                  style: small.apply(color: Colors.red))),
                          ButtonSegment(
                              value: 1,
                              label: Text(s.low,
                                  style: small.apply(color: Colors.orange))),
                          ButtonSegment(
                              value: 2,
                              label: Text(s.medium,
                                  style: small.apply(color: Colors.yellow))),
                          ButtonSegment(
                              value: 3,
                              label: Text(s.high,
                                  style: small.apply(color: Colors.green))),
                        ],
                        selected: {field.value!},
                        onSelectionChanged: (v) => field.didChange(v.first),
                        showSelectedIcon: false,
                      ),
                    ))),
            onChanged: (v) => widget.appSettings.minPrivacyLevel = v!,
          ),
          FormBuilderSwitch(
            name: 'gettx',
            title: Text(s.retrieveTransactionDetails),
            initialValue: !widget.appSettings.nogetTx,
            onChanged: (v) => widget.appSettings.nogetTx = !v!,
          ),
          FormBuilderField<int>(
            name: 'hide',
            initialValue: widget.appSettings.autoHide,
            builder: (field) => InputDecorator(
                decoration: InputDecoration(
                  label: Text(s.autoHideBalance),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SegmentedButton(
                      segments: [
                        ButtonSegment(
                            value: 0, icon: Icon(Icons.visibility_off)),
                        ButtonSegment(
                            value: 1, icon: Icon(Icons.brightness_auto)),
                        ButtonSegment(value: 2, icon: Icon(Icons.visibility)),
                      ],
                      selected: {field.value},
                      onSelectionChanged: (v) => field.didChange(v.first),
                      showSelectedIcon: false,
                    ),
                  ),
                )),
            onChanged: (v) => widget.appSettings.autoHide = v!,
          ),
          Divider(),
          FormBuilderTextField(
            name: 'anchor',
            decoration: InputDecoration(
                label: Text(s.confirmations, style: t.textTheme.bodyMedium)),
            initialValue: widget.appSettings.confirmations.toString(),
            onChanged: (v) =>
                widget.appSettings.confirmations = int.tryParse(v!) ?? 0,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.integer(),
              FormBuilderValidators.min(1)
            ]),
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
          Gap(16),
          InputDecorator(
              decoration: InputDecoration(label: Text(s.customSend)),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: _customSendSettings,
                      child: Text(s.configure)))),
        ]));
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  _customSendSettings() async {
    final customSendSettings = widget.appSettings.customSendSettings;
    await GoRouter.of(context)
        .push('/quick_send_settings', extra: customSendSettings);
  }

  @override
  bool get wantKeepAlive => true;
}

class CoinTab extends StatefulWidget {
  final int coin;
  final CoinSettings coinSettings;
  CoinTab(this.coin, this.coinSettings, {super.key});
  @override
  State<StatefulWidget> createState() => _CoinState();
}

class _CoinState extends State<CoinTab> with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormBuilderState>();
  late List<int?> pings =
      List.generate(coins[widget.coin].lwd.length, (i) => null);
  late final warpUrlController =
      TextEditingController(text: widget.coinSettings.warpUrl);
  late final endWarpHeightController =
      TextEditingController(text: widget.coinSettings.warpHeight.toString());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    final t = Theme.of(context);
    final c = coins[widget.coin];
    final servers = c.lwd
        .asMap()
        .entries
        .map(
          (kv) => FormBuilderFieldOption(
              value: kv.key,
              child: Text(kv.value.name +
                  (pings[kv.key]?.let((v) => ' [$v ms]') ?? ''))),
        )
        .toList();
    final explorers = c.blockExplorers
        .asMap()
        .entries
        .map((kv) => FormBuilderFieldOption(
              value: kv.key,
              child: Text(kv.value),
            ))
        .toList();
    final fee = amountToString(widget.coinSettings.fee.toInt());

    return FormBuilder(
        key: formKey,
        child: Column(children: [
          if (aa.hasUA)
            FormBuilderSwitch(
              name: 'spam',
              title: Text(s.antispamFilter),
              initialValue: widget.coinSettings.spamFilter,
              onChanged: (v) => widget.coinSettings.spamFilter = v!,
            ),
          FormBuilderSwitch(
            name: 'auto_fee',
            title: Text(s.autoFee),
            initialValue: !widget.coinSettings.manualFee,
            onChanged: (v) => setState(() {
              // need rebuild
              widget.coinSettings.manualFee = !v!;
            }),
          ),
          if (widget.coinSettings.manualFee)
            FormBuilderTextField(
              name: 'custom_fee',
              decoration: InputDecoration(label: Text(s.fee)),
              initialValue: fee,
              onChanged: (v) =>
                  widget.coinSettings.fee = Int64(stringToAmount(v!)),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          FormBuilderRadioGroup<int>(
            name: 'server',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.server)),
            initialValue: widget.coinSettings.lwd.index,
            onChanged: (v) => widget.coinSettings.lwd.index = v!,
            options: [
              ...servers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'server_custom',
                    initialValue: widget.coinSettings.lwd.customURL,
                    onChanged: (v) => widget.coinSettings.lwd.customURL = v!,
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          Gap(8),
          ElevatedButton(onPressed: ping, child: Text(s.ping)),
          Gap(8),
          FormBuilderTextField(
            name: 'warp_url',
            decoration: InputDecoration(label: Text(s.warpURL)),
            controller: warpUrlController,
            onChanged: (v) => widget.coinSettings.warpUrl = v!,
            onSaved: (v) => widget.coinSettings.warpUrl = v!,
          ),
          Gap(8),
          FormBuilderTextField(
            name: 'warp_height',
            decoration: InputDecoration(label: Text(s.endWarpHeight)),
            controller: endWarpHeightController,
            keyboardType: TextInputType.numberWithOptions(),
            validator: FormBuilderValidators.integer(),
            onChanged: (v) => widget.coinSettings.warpHeight = int.parse(v!),
            onSaved: (v) => widget.coinSettings.warpHeight = int.parse(v!),
          ),
          Gap(8),
          FormBuilderRadioGroup<int>(
            name: 'explorer',
            orientation: OptionsOrientation.vertical,
            decoration: InputDecoration(label: Text(s.blockExplorer)),
            initialValue: widget.coinSettings.explorer.index,
            onChanged: (v) => widget.coinSettings.explorer.index = v!,
            options: [
              ...explorers,
              FormBuilderFieldOption(
                  value: -1,
                  child: FormBuilderTextField(
                    name: 'explorer_custom',
                    initialValue: widget.coinSettings.explorer.customURL,
                    onChanged: (v) =>
                        widget.coinSettings.explorer.customURL = v!,
                    style: t.textTheme.bodyMedium,
                  )),
            ],
          ),
          if (aa.hasUA)
            FieldUA(
              widget.coinSettings.uaType,
              onChanged: (v) => widget.coinSettings.uaType = v!,
              label: s.mainReceivers,
              name: 'main_address',
              radio: false,
              validator: isValidUA,
            ),
          FieldUA(
            widget.coinSettings.replyUa,
            onChanged: (v) => widget.coinSettings.replyUa = v!,
            label: s.replyUA,
            name: 'reply_address',
            radio: !aa.hasUA,
          ),
          if (aa.hasUA)
            FieldUA(
              widget.coinSettings.receipientPools,
              onChanged: (v) => widget.coinSettings.receipientPools = v!,
              label: s.receivers,
              name: 'recipient_pools',
              radio: false,
            ),
        ]));
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  void ping() {
    for (var i = 0; i < pings.length; i++) {
      final c = coins[widget.coin];
      final server = c.lwd[i].url;
      Future(() async {
        final ping = await warp.pingServer(server);
        pings[i] = ping;
        setState(() {});
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class QuickSendSettingsPage extends StatefulWidget {
  final CustomSendSettings customSendSettings;
  QuickSendSettingsPage(this.customSendSettings);

  @override
  State<StatefulWidget> createState() => _QuickSendSettingsState();
}

class _QuickSendSettingsState extends State<QuickSendSettingsPage> {
  final formKey = GlobalKey<FormBuilderState>();
  late final s = S.of(context);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(s.customSendSettings)),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(s.address),
            tiles: [
              SettingsTile.switchTile(
                title: Text(s.contacts),
                initialValue: widget.customSendSettings.contacts,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.contacts = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.accounts),
                initialValue: widget.customSendSettings.accounts,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.accounts = v),
                activeSwitchColor: cs.primary,
              ),
            ],
          ),
          SettingsSection(
            title: Text(s.pools),
            tiles: [
              SettingsTile.switchTile(
                title: Text(s.source),
                initialValue: widget.customSendSettings.pools,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.pools = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.receivers),
                initialValue: widget.customSendSettings.recipientPools,
                onToggle: (v) => setState(
                    () => widget.customSendSettings.recipientPools = v),
                activeSwitchColor: cs.primary,
              ),
            ],
          ),
          SettingsSection(
            title: Text(s.amount),
            tiles: [
              SettingsTile.switchTile(
                title: Text(s.max),
                initialValue: widget.customSendSettings.max,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.max = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.amountCurrency),
                initialValue: widget.customSendSettings.amountCurrency,
                onToggle: (v) => setState(
                    () => widget.customSendSettings.amountCurrency = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.amountSlider),
                initialValue: widget.customSendSettings.amountSlider,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.amountSlider = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.deductFee),
                initialValue: widget.customSendSettings.deductFee,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.deductFee = v),
                activeSwitchColor: cs.primary,
              ),
            ],
          ),
          SettingsSection(
            title: Text(s.memo),
            tiles: [
              SettingsTile.switchTile(
                title: Text(s.includeReplyTo),
                initialValue: widget.customSendSettings.replyAddress,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.replyAddress = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.subject),
                initialValue: widget.customSendSettings.memoSubject,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.memoSubject = v),
                activeSwitchColor: cs.primary,
              ),
              SettingsTile.switchTile(
                title: Text(s.memo),
                initialValue: widget.customSendSettings.memo,
                onToggle: (v) =>
                    setState(() => widget.customSendSettings.memo = v),
                activeSwitchColor: cs.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FieldUA extends StatelessWidget {
  final String name;
  final String label;
  late final Set<int> initialValues;
  final void Function(int?)? onChanged;
  final bool radio;
  final bool emptySelectionAllowed;
  final int pools;
  final bool hidden;
  final String? Function(int)? validator;
  FieldUA(
    int initialValue, {
    required this.name,
    required this.label,
    this.onChanged,
    this.emptySelectionAllowed = false,
    required this.radio,
    this.validator,
    this.pools = 7,
    this.hidden = false,
  }) : initialValues = PoolBitSet.toSet(initialValue);

  @override
  Widget build(BuildContext context) {
    if (hidden) return SizedBox.shrink();
    final s = S.of(context);
    final t = Theme.of(context);
    final small = t.textTheme.labelMedium!;
    return FormBuilderField(
      name: name,
      initialValue: initialValues,
      onChanged: (v) => onChanged?.call(PoolBitSet.fromSet(v!)),
      validator: (v) => validator?.call(PoolBitSet.fromSet(v!)),
      builder: (field) => InputDecorator(
          decoration:
              InputDecoration(label: Text(label), errorText: field.errorText),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: SegmentedButton(
              segments: [
                if (pools & 1 != 0)
                  ButtonSegment(
                      value: 0,
                      label: Text(s.transparent,
                          overflow: TextOverflow.ellipsis, style: small)),
                if (pools & 2 != 0)
                  ButtonSegment(
                      value: 1,
                      label: Text(s.sapling,
                          overflow: TextOverflow.ellipsis, style: small)),
                if (aa.hasUA && pools & 4 != 0)
                  ButtonSegment(
                      value: 2,
                      label: Text(s.orchard,
                          overflow: TextOverflow.ellipsis, style: small)),
              ],
              selected: field.value!,
              onSelectionChanged: (v) => field.didChange(v),
              multiSelectionEnabled: !radio,
              emptySelectionAllowed: emptySelectionAllowed,
              showSelectedIcon: false,
            ),
          )),
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: SegmentedButton(
                segments: [
                  ButtonSegment(value: 0, label: Text(s.table, style: small)),
                  ButtonSegment(value: 1, label: Text(s.list, style: small)),
                  ButtonSegment(
                      value: 2, label: Text(s.autoView, style: small)),
                ],
                selected: {field.value},
                onSelectionChanged: (index) => field.didChange(index.first),
                showSelectedIcon: false,
              ),
            ),
          )),
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
