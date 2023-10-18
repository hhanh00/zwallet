import 'package:YWallet/chart.dart';
import 'package:YWallet/dualmoneyinput.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/intl/messages.dart';
import 'main.dart';

class PoolsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PoolsState();
}

class PoolsState extends State<PoolsPage> {
  final _formKey = GlobalKey<FormState>();
  late int _fromPool;
  late int _toPool;
  late List<Tuple3<int, String, double>> _pools;
  final _amountKey = GlobalKey<DualMoneyInputState>();
  var _maxAmountController = TextEditingController(
      text: amountToString(0, precision(settings.useMillis)));
  var _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: active.poolBalances.update();

    final b = active.poolBalances;
    final availablePools = [
      Tuple3(0, 'Transparent', b.transparent / ZECUNIT),
      Tuple3(1, 'Sapling', b.sapling / ZECUNIT),
      Tuple3(2, 'Orchard', b.orchard / ZECUNIT)
    ];

    final availableAddrs = active.availabeAddrs;
    print(availableAddrs);
    _pools = availablePools
        .asMap()
        .entries
        .where((e) => (1 << e.key) & availableAddrs != 0)
        .map((e) => e.value)
        .toList();

    _fromPool = _pools.first.item1;
    _toPool = _pools.last.item1;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.pools)),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    HorizontalBarChart(_pools.map((p) => p.item3).toList(),
                        height: 40),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: s.fromPool),
                        value: _fromPool,
                        items: _pools
                            .map((v) => DropdownMenuItem<int>(
                                child: Text(v.item2), value: v.item1))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _fromPool = v!;
                          });
                        }),
                    DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: s.toPool),
                        value: _toPool,
                        items: _pools
                            .map((v) => DropdownMenuItem<int>(
                                child: Text(v.item2), value: v.item1))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _toPool = v!;
                          });
                        }),
                    DualMoneyInputWidget(
                        key: _amountKey,
                        initialValue: 0,
                        spendable: _spendable,
                        max: true),
                    Text(s.maxSpendableAmount(
                        amountToString(_spendable, MAX_PRECISION),
                        active.coinDef.ticker)),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    TextFormField(
                        decoration: InputDecoration(labelText: s.memo),
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _memoController),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    TextFormField(
                        decoration:
                            InputDecoration(labelText: s.maxAmountPerNote),
                        keyboardType: TextInputType.number,
                        controller: _maxAmountController,
                        inputFormatters: [
                          makeInputFormatter(settings.useMillis)
                        ],
                        validator: (v) => _checkMaxAmountPerNote(context, v)),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    ElevatedButton.icon(
                        onPressed: _transfer,
                        icon: Icon(Icons.currency_exchange),
                        label: Text(s.transfer))
                  ]))),
        ));
  }

  int get _spendable {
    final b = active.poolBalances;
    switch (_fromPool) {
      case 0:
        return b.transparent;
      case 1:
        return b.sapling;
      case 2:
        return b.orchard;
    }
    return 0;
  }

  _transfer() async {
    final form = _formKey.currentState;
    if (form == null) return;

    if (form.validate()) {
      form.save();
      final amount = _amountKey.currentState?.amount ?? 0;
      final includeFee = _amountKey.currentState?.feeIncluded ?? false;
      try {
        final txPlan = await WarpApi.transferPools(
            active.coin,
            active.id,
            1 << _fromPool,
            1 << _toPool,
            amount,
            includeFee,
            _memoController.text,
            stringToAmount(_maxAmountController.text),
            settings.anchorOffset,
            settings.feeConfig);
        Navigator.of(context)
            .pushReplacementNamed('/txplan', arguments: txPlan);
      } on String catch (message) {
        showSnackBar(message, error: true);
      }
    }
  }
}

String? _checkMaxAmountPerNote(BuildContext context, String? vs) {
  final s = S.of(context);
  if (vs == null) return s.amountMustBeANumber;
  if (!checkNumber(vs)) return s.amountMustBeANumber;
  final v = parseNumber(vs);
  if (v < 0.0) return s.amountMustBePositive;
  return null;
}
