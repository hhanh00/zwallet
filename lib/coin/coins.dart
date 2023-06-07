import 'coin.dart';
import 'ycash.dart';
import 'zcash.dart';
import 'btc.dart';

CoinBase ycash = YcashCoin();
CoinBase zcash = ZcashCoin();
CoinBase btc = BTCCoin();

final coins = [zcash, ycash, btc];
