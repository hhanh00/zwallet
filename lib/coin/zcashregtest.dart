import 'package:flutter/material.dart';

import 'coin.dart';

class ZcashRegtestCoin extends CoinBase {
  int coin = 4;
  String name = "Zcash Regtest";
  String app = "ZWallet";
  String symbol = "\u24E9";
  String currency = "zcash";
  int coinIndex = 1; 
  String ticker = "ZEC";
  String dbName = "zec-regtest.db";
  String? marketTicker;
  AssetImage image = AssetImage('assets/zcash.png');
  List<LWInstance> lwd = [];
  int defaultAddrMode = 0;
  int defaultUAType = 7; // TSO
  bool supportsUA = true;
  bool supportsMultisig = false;
  bool supportsLedger = false;
  List<double> weights = [0.05, 0.25, 2.50];
  List<String> blockExplorers = [];
}
