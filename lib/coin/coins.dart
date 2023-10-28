import 'coin.dart';
import 'ycash.dart';
import 'zcash.dart';
import 'zcashtest.dart';

CoinBase ycash = YcashCoin();
CoinBase zcash = ZcashCoin();
CoinBase zcashtest = ZcashTestCoin();

final coins = [zcash, ycash];

final activationDate = DateTime(2018, 10, 29);
