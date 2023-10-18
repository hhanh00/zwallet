import 'dart:convert';

import 'package:YWallet/settings.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';

var appSettings = AppSettings();

void loadAppSettings(SharedPreferences prefs) {
  final setting = prefs.getString('settings') ?? '';
  final settingBytes  = base64Decode(setting);
  appSettings = AppSettings.fromBuffer(settingBytes);
  appSettings.defaults();
}

extension AppSettingsExtension on AppSettings {
  void defaults() {
    if (!this.hasAnchorOffset()) appSettings.anchorOffset = 3;
    if (!this.hasRowsPerPage()) appSettings.rowsPerPage = 10;
    if (!this.hasUaType()) appSettings.uaType = 7;
    if (!this.hasDeveloperMode()) appSettings.developerMode = 5;
    if (!this.hasCurrency()) appSettings.currency = 'USD';
  }

  Future<void> save(SharedPreferences prefs) async {
    final bytes = this.writeToBuffer();
    final settings = base64Encode(bytes);
    await prefs.setString('settings', settings);
  }
}
