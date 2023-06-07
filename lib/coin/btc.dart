import 'package:flutter/material.dart';

import "coin.dart";

class BTCCoin extends CoinBase {
  int coin = 2;
  bool transparentOnly = true;
  String name = "Bitcoin";
  String symbol = "\u20BF";
  String currency = "bitcoin";
  int coinIndex = 0;
  String ticker = "BTC";
  String dbName = "btc.db";
  String image = 'assets/bitcoin.png';
  List<LWInstance> lwd = [
    LWInstance("Blockstream", "tcp://blackie.c3-soft.com:57005")
  ];
  bool supportsUA = false;
  bool supportsMultisig = false;
  List<double> weights = [0.001, 0.01, 0.1];
  List<String> blockExplorers = ["https://blockstream.info/testnet/tx"];
  bool supportsLedger = false;
}
