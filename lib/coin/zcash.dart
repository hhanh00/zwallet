import 'package:flutter/material.dart';

import 'coin.dart';

class ZcashCoin extends CoinBase {
  int coin = 0;
  String name = "Zcash";
  String app = "ZWallet";
  String symbol = "\u24E9";
  String currency = "zcash";
  int coinIndex = 133;
  String ticker = "ZEC";
  String dbName = "zec.db";
  String? marketTicker = "ZECUSDT";
  AssetImage image = AssetImage('assets/zcash.png');
  List<LWInstance> lwd = [
    LWInstance("Zec.rocks (Global)", "https://zec.rocks:443"),
    LWInstance("Zcash Infra (USA)", "https://lwd1.zcash-infra.com:9067"),
    LWInstance("Zcash Infra (HK)", "https://lwd2.zcash-infra.com:9067"),
    LWInstance("Zcash Infra (USA)", "https://lwd3.zcash-infra.com:9067"),
    LWInstance("Zcash Infra (Canada)", "https://lwd4.zcash-infra.com:9067"),
    LWInstance("Zcash Infra (France)", "https://lwd5.zcash-infra.com:9067"),
    LWInstance("Zcash Infra (USA)", "https://lwd6.zcash-infra.com:9067"),
    LWInstance("Zcash Infra (Brazil)", "https://lwd7.zcash-infra.com:9067"),
    LWInstance("Zec.rocks (NA)", "https://na.zec.rocks:443"),
    LWInstance("Zec.rocks (SA)", "https://sa.zec.rocks:443"),
    LWInstance("Zec.rocks (EU)", "https://eu.zec.rocks:443"),
    LWInstance("Zec.rocks (AP)", "https://ap.zec.rocks:443"),
  ];
  int defaultAddrMode = 0;
  int defaultUAType = 7; // TSO
  bool supportsUA = true;
  bool supportsMultisig = false;
  bool supportsLedger = true;
  List<double> weights = [0.05, 0.25, 2.50];
  List<String> blockExplorers = [
    "https://blockchair.com/zcash/transaction",
    "https://zecblockexplorer.com/tx"
  ];
}
