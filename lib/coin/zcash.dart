import 'coin.dart';

class Coin {
  String app = "ZWallet";
  String symbol = "\u24E9";
  String currency = "zcash";
  String ticker = "ZEC";
  String explorerUrl = "https://explorer.zcha.in/transactions/";
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://mainnet.lightwalletd.com:9067"),
    LWInstance("Zecwallet", "https://lwdv3.zecwallet.co"),
  ];
  bool supportsUA = false;
}
