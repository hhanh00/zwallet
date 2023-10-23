import 'package:YWallet/appsettings.dart';
import 'package:YWallet/store2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../main.dart';

class BalanceWidget extends StatefulWidget {
  BalanceWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BalanceState();
}

class BalanceState extends State<BalanceWidget> {
  int _mode = 0;

  @override
  void initState() {
    super.initState();
    Future(marketPrice.update);
  }

  String _formatFiat(double x) => decimalFormat(x, 2, symbol: appSettings.currency);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final color =
        _mode == 1 ? t.colorScheme.primaryContainer : t.colorScheme.primary;
    
    return Observer(builder: (context) {
      aa.height;
      final c = coins[aa.coin];
      final balHi = decimalFormat((balance ~/ 100000) / 1000.0, 3);
      final balLo = (balance % 100000).toString().padLeft(5, '0');
      final fiat = marketPrice.price;
      final balFiat = fiat?.let((fx) => balance * fx / ZECUNIT);
      final txtFiat = fiat?.let(_formatFiat);
      final txtBalFiat = balFiat?.let(_formatFiat);

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(c.symbol, style: t.textTheme.bodyLarge),
              Text(balHi,
                  style: t.textTheme.displayMedium?.apply(color: color)),
              Text(balLo, style: t.textTheme.bodyMedium)
            ],
          ),
          Padding(padding: EdgeInsets.all(4)),
          if (txtBalFiat != null) Text(txtBalFiat, style: t.textTheme.titleLarge),
          if (txtFiat != null) Text('1 ${c.ticker} = $txtFiat'),
        ],
      );
    });
  }

  void setMode(int mode) {
    setState(() {
      _mode = mode;
    });
  }

  int get balance {
    switch (_mode) {
      case 0:
        return aa.poolBalances.sapling + aa.poolBalances.orchard;
      case 1:
        return aa.poolBalances.transparent;
      case 2:
        return aa.poolBalances.sapling;
      case 3:
        return aa.poolBalances.orchard;
    }
    throw 'Unreachable';
  }
}
