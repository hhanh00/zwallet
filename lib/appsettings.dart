import 'dart:convert';

import 'package:YWallet/settings.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'coin/coins.dart';

var appSettings = AppSettings();
var coinSettings = CoinSettings();


extension AppSettingsExtension on AppSettings {
  void defaults() {
    if (!this.hasAnchorOffset()) appSettings.anchorOffset = 3;
    if (!this.hasRowsPerPage()) appSettings.rowsPerPage = 10;
    if (!this.hasUaType()) appSettings.uaType = 7;
    if (!this.hasDeveloperMode()) appSettings.developerMode = 5;
    if (!this.hasCurrency()) appSettings.currency = 'USD';
  }

  static AppSettings load(SharedPreferences prefs) {
    final setting = prefs.getString('settings') ?? '';
    final settingBytes  = base64Decode(setting);
    return AppSettings.fromBuffer(settingBytes);
  }

  Future<void> save(SharedPreferences prefs) async {
    final bytes = this.writeToBuffer();
    final settings = base64Encode(bytes);
    await prefs.setString('settings', settings);
  }

  int chartRangeDays() => 365;
}

extension CoinSettingsExtension on CoinSettings {
  static CoinSettings load(int coin) {
    final p = WarpApi.getProperty(coin, 'settings');
    if (p.isEmpty) return CoinSettings(coin: coin);
    return CoinSettings.fromBuffer(base64Decode(p));
  }

  void save() {
    final bytes = this.writeToBuffer();
    final settings = base64Encode(bytes);
    WarpApi.setProperty(coin, 'settings', settings);
  }

  FeeT get feeT => FeeT(scheme: manualFee ? 1 : 0, fee: fee.toInt());

  String resolveBlockExplorer() {
    final explorers = coins[coin].blockExplorers;
    int idx = explorer.index;
    if (idx >= 0) return explorers[idx];
    return explorer.customURL;
  }
}

