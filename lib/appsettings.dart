import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'settings.pb.dart';
import 'coin/coins.dart';

var appSettings = AppSettings();
var coinSettings = CoinSettings();

extension AppSettingsExtension on AppSettings {
  void defaults() {
    if (!hasAnchorOffset()) anchorOffset = 3;
    if (!hasRowsPerPage()) rowsPerPage = 10;
    if (!hasDeveloperMode()) developerMode = 5;
    if (!hasCurrency()) currency = 'USD';
    if (!hasAutoHide()) autoHide = 1;
    if (!hasPalette()) {
      palette = ColorPalette(
        name: 'mandyRed',
        dark: true,
      );
    }
    // memo is initialized later because we don't have S yet
    if (!hasNoteView()) noteView = 2;
    if (!hasTxView()) txView = 2;
    if (!hasMessageView()) messageView = 2;
    if (!hasCustomSendSettings())
      customSendSettings = CustomSendSettings()..defaults();
    if (!hasBackgroundSync()) backgroundSync = true;
  }

  static AppSettings load(SharedPreferences prefs) {
    final setting = prefs.getString('settings') ?? '';
    final settingBytes = base64Decode(setting);
    return AppSettings.fromBuffer(settingBytes)..defaults();
  }

  Future<void> save(SharedPreferences prefs) async {
    final bytes = this.writeToBuffer();
    final settings = base64Encode(bytes);
    await prefs.setString('settings', settings);
  }

  int chartRangeDays() => 365;
}

extension CoinSettingsExtension on CoinSettings {
  void defaults(int coin) {
    int defaultUAType = coins[coin].defaultUAType;
    if (!hasUaType()) uaType = defaultUAType;
    if (!hasReplyUa()) replyUa = defaultUAType;
    if (!hasSpamFilter()) spamFilter = true;
    if (!hasZFactor()) zFactor = 2;
  }

  static CoinSettings load(int coin) {
    final p = WarpApi.getProperty(coin, 'settings');
    return CoinSettings.fromBuffer(base64Decode(p))..defaults(coin);
  }

  void save(int coin) {
    final bytes = writeToBuffer();
    final settings = base64Encode(bytes);
    WarpApi.setProperty(coin, 'settings', settings);
  }

  FeeT get feeT => FeeT(scheme: manualFee ? 1 : 0, fee: fee.toInt());

  String resolveBlockExplorer(int coin) {
    final explorers = coins[coin].blockExplorers;
    int idx = explorer.index;
    if (idx >= 0) return explorers[idx];
    return explorer.customURL;
  }
}

extension CustomSendSettingsExtension on CustomSendSettings {
  void defaults() {
    contacts = true;
    accounts = true;
    pools = true;
    amountCurrency = true;
    amountSlider = true;
    max = true;
    deductFee = true;
    replyAddress = true;
    memoSubject = true;
    memo = true;
  }
}
