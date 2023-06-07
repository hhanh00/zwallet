import 'package:flutter/material.dart';

import 'coin.dart';

class ZcashCoin extends CoinBase {
  int coin = 0;
  String name = "Zcash";
  String symbol = "\u24E9";
  String currency = "zcash";
  int coinIndex = 133;
  String ticker = "ZEC";
  String dbName = "zec.db";
  String image = 'assets/zcash.png';
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://mainnet.lightwalletd.com:9067"),
    LWInstance("Zecwallet", "https://lwdv3.zecwallet.co"),
  ];
  bool supportsUA = true;
  bool supportsMultisig = false;
  bool supportsLedger = true;
  List<double> weights = [0.05, 0.25, 2.50];
  List<String> blockExplorers = [
    "https://explorer.zcha.in/transactions",
    "https://blockchair.com/zcash/transaction",
    "https://zcashblockexplorer.com/transactions",
    "https://zecblockexplorer.com/tx"
  ];
}
