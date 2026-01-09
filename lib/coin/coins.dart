import '../appsettings.dart';
import 'coin.dart';
import 'ycash.dart';
import 'ycashtest.dart';
import 'zcash.dart';
import 'zcashtest.dart';
import 'zcashregtest.dart';
import 'ycashregtest.dart';

CoinBase ycash = YcashCoin();
CoinBase zcash = ZcashCoin();
CoinBase zcashtest = ZcashTestCoin();
CoinBase ycashtest = YcashTestCoin();
CoinBase zcashregtest = ZcashRegtestCoin();
CoinBase ycashregtest = YcashRegtestCoin();

List<CoinBase> get coins => getAllCoins();

List<CoinBase> get selectableCoins {
  if (appSettings.developerMode == 0) return [zcash, ycash];
  return getAllCoins();
}

List<CoinBase> getAllCoins() => [zcash, ycash, zcashtest, ycashtest, zcashregtest, ycashregtest];

final activationDate = DateTime(2018, 10, 29);
