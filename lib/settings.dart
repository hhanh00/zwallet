import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'coin/coins.dart';

import 'coin/coin.dart';
import 'main.dart';
import 'generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsState();
}

final _settingsFormKey = GlobalKey<FormBuilderState>();

class SettingsState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  var _anchorController =
      TextEditingController(text: "${settings.anchorOffset}");
  var _thresholdController = TextEditingController(
      text: decimalFormat(settings.autoShieldThreshold, 3));
  var _memoController = TextEditingController();
  var _currency = settings.currency;
  var _needAuth = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final simpleMode = settings.simpleMode;
    _memoController.text = settings.memoSignature ?? s.sendFrom(APP_NAME);

    return Scaffold(
        appBar: AppBar(title: Text(s.settings)),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: FormBuilder(
                key: _settingsFormKey,
                child: Observer(
                    builder: (context) => SingleChildScrollView(
                            child: Column(children: [
                          FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'mode',
                              decoration: InputDecoration(
                                  labelText: s.mode),
                              initialValue: settings.simpleMode ? 'simple' : 'advanced',
                              onSaved: _onMode,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.simple), value: 'simple'),
                                FormBuilderFieldOption(
                                    child: Text(s.advanced), value: 'advanced'),
                              ]),
                          if (!simpleMode) TabBar(controller: _tabController, tabs: [Tab(text: "Zcash"), Tab(text: "Ycash")]),
                          if (!simpleMode) SizedBox(height: 200, child: TabBarView(controller: _tabController, children: [ServerSelect(0), ServerSelect(1)])),
                          // if (!simpleMode) FormBuilderRadioGroup(
                          //     orientation: OptionsOrientation.vertical,
                          //     name: 'servers',
                          //     decoration: InputDecoration(
                          //         labelText: s.server),
                          //     initialValue: settings.ldUrlChoice,
                          //     onSaved: _onChoice,
                          //     options: options),
                          FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'themes',
                              decoration: InputDecoration(
                                  labelText: s.theme),
                              initialValue: settings.theme,
                              onChanged: _onTheme,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.gold), value: 'gold'),
                                FormBuilderFieldOption(
                                    child: Text(s.blue),
                                    value: 'blue'),
                                FormBuilderFieldOption(
                                    child: Text(s.pink),
                                    value: 'pink'),
                                FormBuilderFieldOption(
                                    child: Text(s.purple),
                                    value: 'purple'),
                                FormBuilderFieldOption(
                                    child: Text(s.custom),
                                    value: 'custom'),
                              ]),
                          Row(children: [Expanded(child: FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'brightness',
                              initialValue: settings.themeBrightness,
                              onChanged: _onThemeBrightness,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.light),
                                    value: 'light'),
                                FormBuilderFieldOption(
                                    child: Text(s.dark),
                                    value: 'dark'),
                              ])),
                            IconButton(onPressed: _editTheme, icon: Icon(Icons.edit))
                          ]),
                          Row(children: [
                            SizedBox(
                                width: 100,
                                child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        labelText: s.currency),
                                    value: _currency,
                                    items: settings.currencies
                                        .map((c) => DropdownMenuItem(
                                            child: Text(c), value: c))
                                        .toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        _currency = v!;
                                      });
                                    },
                                    onSaved: (_) {
                                      settings.setCurrency(_currency);
                                    })),
                            Expanded(
                                child: FormBuilderCheckbox(
                                    name: 'protect_send',
                                    title: Text(s.protectSend),
                                    initialValue: settings.protectSend,
                                    onChanged: (_) {
                                      _needAuth = true;
                                    },
                                    onSaved: _onProtectSend)),
                            // if (coin.supportsUA)
                            //   Expanded(
                            //       child: FormBuilderCheckbox(
                            //           name: 'use_ua',
                            //           title: Text(s.useUa),
                            //           initialValue: settings.useUA,
                            //           onSaved: _onUseUA)),
                          ]),
                          if (!simpleMode) FormBuilderTextField(
                              decoration: InputDecoration(
                                  labelText: s.numberOfConfirmationsNeededBeforeSpending),
                              name: 'anchor',
                              keyboardType: TextInputType.number,
                              controller: _anchorController,
                              onSaved: _onAnchorOffset),
                          if (!simpleMode) FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'pnl',
                              decoration: InputDecoration(
                                  labelText: s.tradingChartRange),
                              initialValue: settings.chartRange,
                              onSaved: _onChartRange,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.M1), value: '1M'),
                                FormBuilderFieldOption(
                                    child: Text(s.M3), value: '3M'),
                                FormBuilderFieldOption(
                                    child: Text(s.M6), value: '6M'),
                                FormBuilderFieldOption(
                                    child: Text(s.Y1), value: '1Y'),
                              ]),
                          if (!simpleMode) FormBuilderCheckbox(
                              name: 'get_tx',
                              title: Text(
                                  s.retrieveTransactionDetails),
                              initialValue: settings.getTx,
                              onSaved: _onGetTx),
                          FormBuilderCheckbox(
                              name: 'auto_hide',
                              title: Text(
                                  s.autoHideBalance),
                              initialValue: settings.autoHide,
                              onSaved: _onAutoHide),
                          if (!simpleMode) TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Auto Shield Threshold'),
                              keyboardType: TextInputType.number,
                              controller: _thresholdController,
                              inputFormatters: [makeInputFormatter(true)],
                              onSaved: _onAutoShieldThreshold,
                              validator: _checkAmount),
                          if (!simpleMode) FormBuilderCheckbox(
                              name: 'use_trp',
                              title: Text(s.useTransparentBalance),
                              initialValue: settings.shieldBalance,
                              onSaved: _shieldBalance),
                          if (!simpleMode) FormBuilderTextField(
                            decoration: InputDecoration(
                                labelText: s.defaultMemo),
                            name: 'memo',
                            keyboardType: TextInputType.number,
                            controller: _memoController,
                            onSaved: _onMemo),
                        ButtonBar(children: confirmButtons(context, _onSave))
                        ]))))));
  }

  String? _checkAmount(String? vs) {
    final s = S.of(context);
    if (vs == null) return s.amountMustBeANumber;
    if (!checkNumber(vs)) return s.amountMustBeANumber;
    final v = parseNumber(vs);
    if (v < 0.0) return s.amountMustBePositive;
    return null;
  }

  _onMode(v) {
    settings.setMode(v == 'simple');
  }

  _onTheme(v) {
    settings.setTheme(v);
  }

  _onThemeBrightness(v) {
    settings.setThemeBrightness(v);
  }

  _onChartRange(v) {
    settings.setChartRange(v);
  }

  _shieldBalance(v) {
    settings.setShieldBalance(v);
  }

  _onAutoShieldThreshold(_) {
    final v = parseNumber(_thresholdController.text);
    settings.setAutoShieldThreshold(v);
  }

  _onUseUA(v) {
    settings.setUseUA(v);
  }

  _onAutoHide(v) {
    settings.setAutoHide(v);
  }

  _onProtectSend(v) {
    settings.setProtectSend(v);
  }

  _onSave() async {
    final form = _settingsFormKey.currentState!;
    if (form.validate()) {
      if (_needAuth && !await authenticate(context, S.of(context).protectSendSettingChanged)) return;
      form.save();
      settings.updateLWD();
      Navigator.of(context).pop();
    }
  }

  _onAnchorOffset(v) {
    settings.setAnchorOffset(int.parse(v));
  }

  _onGetTx(v) {
    settings.updateGetTx(v);
  }

  _onMemo(v) {
    settings.setMemoSignature(v);
  }

  _editTheme() {
    Navigator.of(context).pushNamed('/edit_theme');
  }
}

class ServerSelect extends StatefulWidget {
  final int coin;

  ServerSelect(this.coin);
  _ServerSelectState createState() => _ServerSelectState(coin);
}

class _ServerSelectState extends State<ServerSelect> with
  AutomaticKeepAliveClientMixin {
  final int coin;
  late String choice;
  late String customUrl;
  bool _saved = true;

  _ServerSelectState(this.coin) {
    choice = settings.servers[coin].choice;
    customUrl = settings.servers[coin].customUrl;
  }

  CoinBase get coinDef => settings.coins[widget.coin].def;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    List<FormBuilderFieldOption<String>> options = coinDef.lwd
        .map((lwd) => FormBuilderFieldOption<String>(
        child: Text(lwd.name), value: lwd.name))
        .toList();
    options.add(
      FormBuilderFieldOption(
          value: 'custom',
          child: FormBuilderTextField(
            name: 'lwd_url ${coinDef.ticker}',
            decoration: InputDecoration(labelText: s.custom),
            initialValue: customUrl,
            onSaved: _save,
            onChanged: (v) {
              if (v == null) return;
              customUrl = v;
              _saved = false;
              },
          )),
    );

    return FormBuilderRadioGroup<String>(
        orientation: OptionsOrientation.vertical,
        name: 'lwd ${coinDef.ticker}',
        decoration: InputDecoration(
            labelText: s.server),
        initialValue: choice,
        onSaved: _save,
        onChanged: (v) {
          if (v == null) return;
          choice = v;
          _saved = false;
          },
        options: options);
  }

  void _save(_) async {
    if (_saved) return;
    await settings.servers[coin].savePrefs(choice, customUrl);
    _saved = true;
  }

  @override
  bool get wantKeepAlive => true;
}

CoinBase activeCoin() => settings.coins[active.coin].def;
