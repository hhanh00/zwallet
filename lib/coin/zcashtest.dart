import 'coin.dart';

class Coin {
  String app = "ZWalletTest";
  String symbol = "\u24E9";
  String currency = "zcash";
  String ticker = "ZEC";
  String explorerUrl = "https://sochain.com/tx/ZECTEST/";
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://testnet.lightwalletd.com:9067"),
  ];
}
