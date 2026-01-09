import 'package:flutter/material.dart';

import 'coin.dart';

class YcashRegtestCoin extends CoinBase {
  int coin = 5;
  String name = "Ycash Regtest";
  String app = "YWalletTest";
  String symbol = "\u24E8";
  String currency = "ycash";
  int coinIndex = 1; 
  String ticker = "YEC";
  String dbName = "yec-regtest.db";
  String? marketTicker;
  AssetImage image = AssetImage('assets/ycash.png');
  List<LWInstance> lwd = [];
  int defaultAddrMode = 2;
  int defaultUAType = 2;
  bool supportsUA = false;
  bool supportsMultisig = true;
  bool supportsLedger = false;
  List<double> weights = [5, 25, 250];
  List<String> blockExplorers = [];
}
