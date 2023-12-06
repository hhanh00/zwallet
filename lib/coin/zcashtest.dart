import 'package:flutter/material.dart';

import 'coin.dart';

class ZcashTestCoin extends CoinBase {
  int coin = 0;
  String name = "Zcash Test";
  String app = "ZWallet";
  String symbol = "\u24E9";
  String currency = "zcash";
  int coinIndex = 133;
  String ticker = "ZEC";
  String dbName = "zec-test.db";
  String? marketTicker = "ZECUSDT";
  AssetImage image = AssetImage('assets/zcash.png');
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://testnet.lightwalletd.com:9067"),
  ];
  int defaultAddrMode = 0;
  int defaultUAType = 7; // TSO
  bool supportsUA = true;
  bool supportsMultisig = false;
  bool supportsLedger = false;
  List<double> weights = [0.05, 0.25, 2.50];
  List<String> blockExplorers = ["https://explorer.zcha.in/transactions"];
}
