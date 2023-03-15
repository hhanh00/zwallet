import 'package:YWallet/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:warp_api/warp_api.dart';

import 'coin/coin.dart';
import 'main.dart';
import 'generated/l10n.dart';

List<DropdownMenuItem<int>> getPrivacyOptions(BuildContext context) {
  final s = S.of(context);
  final privacyLevels = [s.veryLow, s.low, s.medium, s.high];
  return privacyLevels
      .asMap()
      .entries
      .map((kv) => DropdownMenuItem(child: Text(kv.value), value: kv.key))
      .toList();
}

String getPrivacyLevel(BuildContext context, int level) {
  final s = S.of(context);
  final privacyLevels = [s.veryLow, s.low, s.medium, s.high];
  return privacyLevels[level];
}

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsState();
}

final _settingsFormKey = GlobalKey<FormBuilderState>();

class SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  var _anchorController =
      TextEditingController(text: "${settings.anchorOffset}");
  var _memoController = TextEditingController();
  var _currency = settings.currency;
  var _needAuth = false;
  var _messageView = settings.messageView;
  var _noteView = settings.noteView;
  var _txView = settings.txView;
  var _minPrivacy = settings.minPrivacyLevel;
  var _explorer = BlockExplorerSelection.create();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final simpleMode = settings.simpleMode;
    _memoController.text = settings.memoSignature ?? s.sendFrom(APP_NAME);

    final hasUA = active.coinDef.supportsUA;
    final uaType = settings.uaType;
    List<String> uaList = [];
    if (uaType & 1 != 0) uaList.add('T');
    if (uaType & 2 != 0) uaList.add('S');
    if (uaType & 4 != 0) uaList.add('O');

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
                              decoration: InputDecoration(labelText: s.mode),
                              initialValue:
                                  settings.simpleMode ? 'simple' : 'advanced',
                              onSaved: _onMode,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.simple), value: 'simple'),
                                FormBuilderFieldOption(
                                    child: Text(s.advanced), value: 'advanced'),
                              ]),
                          ServerSelect(active.coin),
                          FormBuilderRadioGroup(
                              orientation: OptionsOrientation.horizontal,
                              name: 'themes',
                              decoration: InputDecoration(labelText: s.theme),
                              initialValue: settings.theme,
                              onChanged: _onTheme,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.gold), value: 'gold'),
                                FormBuilderFieldOption(
                                    child: Text(s.blue), value: 'blue'),
                                FormBuilderFieldOption(
                                    child: Text(s.pink), value: 'pink'),
                                FormBuilderFieldOption(
                                    child: Text(s.purple), value: 'purple'),
                                FormBuilderFieldOption(
                                    child: Text(s.custom), value: 'custom'),
                              ]),
                          Row(children: [
                            Expanded(
                                child: FormBuilderRadioGroup(
                                    orientation: OptionsOrientation.horizontal,
                                    name: 'brightness',
                                    initialValue: settings.themeBrightness,
                                    onChanged: _onThemeBrightness,
                                    options: [
                                  FormBuilderFieldOption(
                                      child: Text(s.light), value: 'light'),
                                  FormBuilderFieldOption(
                                      child: Text(s.dark), value: 'dark'),
                                ])),
                            IconButton(
                                onPressed: _editTheme, icon: Icon(Icons.edit))
                          ]),
                          Row(children: [
                            SizedBox(
                                width: 100,
                                child: DropdownButtonFormField<String>(
                                    decoration:
                                        InputDecoration(labelText: s.currency),
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
                            Expanded(
                                child: FormBuilderCheckbox(
                                    name: 'protect_open',
                                    title: Text(s.protectOpen),
                                    initialValue: settings.protectOpen,
                                    onChanged: (_) {
                                      _needAuth = true;
                                    },
                                    onSaved: _onProtectOpen)),
                          ]),
                          if (!simpleMode)
                            FormBuilderCheckbox(
                                name: 'use_millis',
                                title: Text(s.roundToMillis),
                                initialValue: settings.useMillis,
                                onSaved: _onUseMillis),
                          if (!simpleMode)
                            FormBuilderTextField(
                                decoration: InputDecoration(
                                    labelText: s
                                        .numberOfConfirmationsNeededBeforeSpending),
                                name: 'anchor',
                                keyboardType: TextInputType.number,
                                controller: _anchorController,
                                onSaved: _onAnchorOffset),
                          if (!simpleMode)
                            FormBuilderRadioGroup(
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
                          if (!simpleMode && hasUA)
                            FormBuilderCheckboxGroup<String>(
                                orientation: OptionsOrientation.horizontal,
                                name: 'ua',
                                decoration: InputDecoration(
                                    labelText: 'Main Address Type'),
                                initialValue: uaList,
                                onSaved: _onUAType,
                                validator: _checkUA,
                                options: [
                                  FormBuilderFieldOption(value: 'T'),
                                  FormBuilderFieldOption(value: 'S'),
                                  FormBuilderFieldOption(value: 'O'),
                                ]),
                          if (!simpleMode)
                            FormBuilderCheckbox(
                                name: 'get_tx',
                                title: Text(s.retrieveTransactionDetails),
                                initialValue: settings.getTx,
                                onSaved: _onGetTx),
                          FormBuilderRadioGroup<int>(
                              orientation: OptionsOrientation.horizontal,
                              name: 'auto_hide',
                              decoration:
                                  InputDecoration(labelText: s.autoHideBalance),
                              initialValue: settings.autoHide,
                              onSaved: _onAutoHide,
                              options: [
                                FormBuilderFieldOption(
                                    child: Text(s.never), value: 0),
                                FormBuilderFieldOption(
                                    child: Text(s.auto), value: 1),
                                FormBuilderFieldOption(
                                    child: Text(s.always), value: 2),
                              ]),
                          DropdownButtonFormField<int>(
                              decoration:
                                  InputDecoration(labelText: s.minPrivacy),
                              value: _minPrivacy,
                              items: getPrivacyOptions(context),
                              onChanged: (v) {
                                setState(() {
                                  _minPrivacy = v!;
                                });
                              },
                              onSaved: (_) {
                                settings.setMinPrivacy(_minPrivacy);
                              }),
                          FormBuilderCheckbox(
                              name: 'include_reply_to',
                              title: Text(s.includeReplyTo),
                              initialValue: settings.includeReplyTo,
                              onSaved: _onIncludeReplyTo),
                          if (!simpleMode)
                            Row(children: [
                              Expanded(
                                  child: DropdownButtonFormField<ViewStyle>(
                                      decoration: InputDecoration(
                                          labelText: s.messages),
                                      value: _messageView,
                                      items: ViewStyle.values
                                          .map((v) => DropdownMenuItem(
                                              child: Text(v.name), value: v))
                                          .toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          _messageView = v!;
                                        });
                                      },
                                      onSaved: (_) {
                                        settings.setMessageView(_messageView);
                                      })),
                              Expanded(
                                  child: DropdownButtonFormField<ViewStyle>(
                                      decoration:
                                          InputDecoration(labelText: s.notes),
                                      value: _noteView,
                                      items: ViewStyle.values
                                          .map((v) => DropdownMenuItem(
                                              child: Text(v.name), value: v))
                                          .toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          _noteView = v!;
                                        });
                                      },
                                      onSaved: (_) {
                                        settings.setNoteView(_noteView);
                                      })),
                              Expanded(
                                  child: DropdownButtonFormField<ViewStyle>(
                                      decoration: InputDecoration(
                                          labelText: s.transactions),
                                      value: _txView,
                                      items: ViewStyle.values
                                          .map((v) => DropdownMenuItem(
                                              child: Text(v.name), value: v))
                                          .toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          _txView = v!;
                                        });
                                      },
                                      onSaved: (_) {
                                        settings.setTxView(_txView);
                                      })),
                            ]),
                          if (!simpleMode)
                            FormBuilderCheckbox(
                                name: 'use_cold_qr',
                                title: Text(s.useQrForOfflineSigning),
                                initialValue: settings.qrOffline,
                                onSaved: _qrOffline),
                          if (!simpleMode)
                            FormBuilderCheckbox(
                                name: 'antispam',
                                title: Text(s.antispamFilter),
                                initialValue: settings.antispam,
                                onSaved: _antispam),
                          if (!simpleMode && WarpApi.hasGPU())
                            FormBuilderCheckbox(
                                name: 'gpu',
                                title: Text(s.useGpu),
                                initialValue: settings.useGPU,
                                onSaved: _useGPU),
                          if (!simpleMode)
                            FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: s.defaultMemo),
                                name: 'memo',
                                controller: _memoController,
                                onSaved: _onMemo),
                          Row(children: [
                            Expanded(
                                child: TextField(
                              controller:
                                  TextEditingController(text: _explorer.url),
                              decoration:
                                  InputDecoration(labelText: s.blockExplorer),
                              readOnly: true,
                            )),
                            IconButton(
                                onPressed: _editBlockExplorer,
                                icon: Icon(Icons.edit))
                          ]),
                          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                          ButtonBar(children: confirmButtons(context, _onSave))
                        ]))))));
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

  _qrOffline(v) {
    settings.setQrOffline(v);
  }

  _onUAType(List<String>? vs) {
    if (vs == null) return;
    final type = _unpackUAType(vs);
    settings.setUAType(type);
  }

  String? _checkUA(List<String>? vs) {
    if (vs == null) return null;
    final type = _unpackUAType(vs);
    if (type < 2) return "Invalid Address Type";
    return null;
  }

  int _unpackUAType(List<String> vs) {
    int r = 0;
    for (var v in vs) {
      switch (v) {
        case 'T':
          r |= 1;
          break;
        case 'S':
          r |= 2;
          break;
        case 'O':
          r |= 4;
          break;
      }
    }
    return r;
  }

  _onAutoHide(v) {
    settings.setAutoHide(v);
  }

  _onIncludeReplyTo(v) {
    settings.setIncludeReplyTo(v);
  }

  _onProtectSend(v) {
    settings.setProtectSend(v);
  }

  _onProtectOpen(v) {
    settings.setProtectOpen(v);
  }

  _antispam(v) {
    settings.setAntiSpam(v);
  }

  _useGPU(v) {
    settings.setUseGPU(v);
  }

  _onSave() async {
    final form = _settingsFormKey.currentState!;
    if (form.validate()) {
      if (_needAuth &&
          !await authenticate(context, S.of(context).protectSendSettingChanged))
        return;
      form.save();
      settings.updateLWD();
      _explorer.save();
      Navigator.of(context).pop();
    }
  }

  _onAnchorOffset(v) {
    settings.setAnchorOffset(int.parse(v));
  }

  _onGetTx(v) {
    settings.updateGetTx(v);
  }

  _onUseMillis(v) {
    settings.setUseMillis(v);
  }

  _onMemo(v) {
    settings.setMemoSignature(v);
  }

  _editTheme() {
    Navigator.of(context).pushNamed('/edit_theme');
  }

  _editBlockExplorer() async {
    final s = S.of(context);
    final customController = TextEditingController(text: _explorer.custom);

    List<FormBuilderFieldOption<String>> options = active.coinDef.blockExplorers
        .map((explorer) => FormBuilderFieldOption<String>(
            child: Text(explorer), value: explorer))
        .toList();

    options.add(
      FormBuilderFieldOption(value: 'custom', child: Text(s.custom)),
    );

    final formKey = GlobalKey<FormBuilderState>();

    final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(s.blockExplorer),
                content: FormBuilder(
                    key: formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      FormBuilderRadioGroup(
                          orientation: OptionsOrientation.vertical,
                          name: 'block_explorers',
                          initialValue: _explorer.selectedOption,
                          options: options),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: s.custom),
                        name: 'custom',
                        controller: customController,
                      ),
                    ])),
                actions: confirmButtons(context, () {
                  Navigator.of(context).pop(true);
                }))) ??
        false;
    if (confirmed) {
      final state = formKey.currentState!;
      final selection = state.fields['block_explorers']!.value;
      final custom = state.fields['custom']!.value;
      final url = selection == 'custom' ? custom : selection;
      _explorer.custom = custom;
      _explorer.selectedOption = selection;
      _explorer.url = url;
      setState(() {});
    }
  }
}

class BlockExplorerSelection {
  static const selectedKey = 'selected_block_explorer';
  static const customKey = 'custom_block_explorer';

  String selectedOption;
  String custom;
  String url;
  BlockExplorerSelection(this.selectedOption, this.custom, this.url);

  factory BlockExplorerSelection.create() {
    var instance = BlockExplorerSelection('', '', '');
    instance.load();
    return instance;
  }

  void load() {
    selectedOption = WarpApi.getProperty(active.coin, selectedKey);
    if (selectedOption.isEmpty)
      selectedOption = active.coinDef.blockExplorers[0];
    custom = WarpApi.getProperty(active.coin, customKey);
    url = WarpApi.getProperty(active.coin, EXPLORER_KEY);
  }

  void save() {
    WarpApi.setProperty(active.coin, selectedKey, selectedOption);
    WarpApi.setProperty(active.coin, customKey, custom);
    WarpApi.setProperty(active.coin, EXPLORER_KEY, url);
  }
}

class ServerSelect extends StatefulWidget {
  final int coin;

  ServerSelect(this.coin);
  _ServerSelectState createState() => _ServerSelectState(coin);
}

class _ServerSelectState extends State<ServerSelect>
    with AutomaticKeepAliveClientMixin {
  final int coin;
  late ServerSelection server;
  bool _saved = true;

  _ServerSelectState(this.coin) {
    server = ServerSelection.load(coin);
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
    options.insert(
        0, FormBuilderFieldOption(value: 'auto', child: Text(s.auto)));

    options.add(
      FormBuilderFieldOption(
          value: 'custom',
          child: FormBuilderTextField(
            name: 'lwd_url ${coinDef.ticker}',
            decoration: InputDecoration(labelText: s.custom),
            initialValue: server.custom,
            onSaved: _save,
            onChanged: (v) {
              if (v == null) return;
              server.custom = v;
              _saved = false;
            },
          )),
    );

    return Column(children: [
      FormBuilderRadioGroup<String>(
          orientation: OptionsOrientation.vertical,
          name: 'lwd ${coinDef.ticker}',
          decoration: InputDecoration(labelText: s.server),
          initialValue: server.selected,
          onSaved: _save,
          onChanged: (v) {
            if (v == null) return;
            server.selected = v;
            _saved = false;
          },
          options: options),
      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
      Text(server.current),
    ]);
  }

  void _save(_) async {
    if (_saved) return;
    server.save();
    _saved = true;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

CoinBase activeCoin() => settings.coins[active.coin].def;
