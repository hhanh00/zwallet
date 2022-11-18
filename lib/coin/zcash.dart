import 'package:flutter/material.dart';

import 'coin.dart';

class ZcashCoin extends CoinBase {
  int coin = 0;
  String app = "ZWallet";
  String symbol = "\u24E9";
  String currency = "zcash";
  int coinIndex = 133;
  String ticker = "ZEC";
  String dbName = "zec.db";
  String explorerUrl = "https://explorer.zcha.in/transactions/";
  AssetImage image = AssetImage('assets/zcash.png');
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://mainnet.lightwalletd.com:9067"),
    LWInstance("Zecwallet", "https://lwdv3.zecwallet.co"),
  ];
  bool supportsUA = true;
  bool supportsMultisig = false;
  List<double> weights = [0.05, 0.25, 2.50];
}
