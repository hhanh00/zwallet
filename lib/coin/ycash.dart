import 'package:flutter/material.dart';

import "coin.dart";

class YcashCoin extends CoinBase {
  int coin = 1;
  String name = "Ycash";
  String app = "YWallet";
  String symbol = "\u24E8";
  String currency = "ycash";
  int coinIndex = 347;
  String ticker = "YEC";
  String dbName = "yec.db";
  AssetImage image = AssetImage('assets/ycash.png');
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://lite.ycash.xyz:9067"),
  ];
  bool supportsUA = false;
  bool supportsMultisig = true;
  bool supportsLedger = true;
  List<double> weights = [5, 25, 250];
  List<String> blockExplorers = ["https://yecblockexplorer.com/tx"];
}
