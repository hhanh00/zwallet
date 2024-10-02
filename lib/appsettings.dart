import 'dart:convert';
import 'dart:math' as m;
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';

import 'settings.pb.dart';
import 'coin/coins.dart';

var appSettings = AppSettings();
var coinSettings = CoinSettings();

extension AppSettingsExtension on AppSettings {
  void defaults() {
    if (!hasConfirmations()) confirmations = 3;
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
    if (!hasBackgroundSync()) backgroundSync = 1;
    if (!hasLanguage()) language = 'en';
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
  int get anchorOffset => m.max(confirmations, 1) - 1;
}

extension CoinSettingsExtension on CoinSettings {
  void defaults(int coin) {
    int defaultUAType = coins[coin].defaultUAType;
    if (!hasLwd()) lwd = ServerURL(index: 0);
    if (!hasUaType()) uaType = defaultUAType;
    if (!hasReplyUa()) replyUa = defaultUAType;
    if (!hasSpamFilter()) spamFilter = true;
    if (!hasReceipientPools()) receipientPools = 7;
    if (!hasWarpUrl()) warpUrl = coins[coin].warpUrl ?? '';
    if (!hasWarpHeight()) warpHeight = coins[coin].warpHeight;
  }

  static Future<CoinSettings> load(int coin) async {
    Uint8List p;
    try {
      p = await warp.getAccountProperty(coin, 0, 'settings');
    } on String {
      p = Uint8List(0);
    }
    final cs = CoinSettings.fromBuffer(p)..defaults(coin);
    return cs;
  }

  void save(int coin) {
    final settings = writeToBuffer();
    warp.setAccountProperty(coin, 0, 'settings', settings);
  }

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
    recipientPools = true;
    amountCurrency = true;
    amountSlider = true;
    max = true;
    deductFee = true;
    replyAddress = true;
    memoSubject = true;
    memo = true;
  }
}
