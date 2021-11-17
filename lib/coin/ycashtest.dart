import "coin.dart";

class Coin {
  String app = "YWalletTest";
  String symbol = "\u24E8";
  String currency = "ycash";
  String ticker = "YEC";
  String explorerUrl = "https://yecblockexplorer.com/tx/";
  List<LWInstance> lwd = [
    LWInstance("Lightwalletd", "https://testlite.ycash.xyz:9067"),
  ];
  bool supportsUA = false;
  bool supportsMultisig = true;
  List<int> weights = [5, 25, 250];
}
