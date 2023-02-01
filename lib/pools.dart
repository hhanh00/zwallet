import 'package:YWallet/chart.dart';
import 'package:YWallet/dualmoneyinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/l10n.dart';
import 'main.dart';

class PoolsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PoolsState();
}

class PoolsState extends State<PoolsPage> {
  final _formKey = GlobalKey<FormState>();
  int _fromPool = 0;
  int _toPool = 1;
  final _amountKey = GlobalKey<DualMoneyInputState>();
  var _maxAmountController = TextEditingController(text: amountToString(0, precision(settings.useMillis)));
  var _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    active.poolBalances.update();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    var pools = ['Transparent', 'Sapling', 'Orchard'];

    final b = active.poolBalances;
    final balances = [b.transparent, b.sapling, b.orchard].map((v) => v / ZECUNIT).toList();
    if (!active.coinDef.supportsUA) {
      pools.removeAt(2);
      balances.removeAt(2);
    }
    return Scaffold(
      appBar: AppBar(title: Text(s.pools)),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(16),
          child: Form(key: _formKey, child: Column(children: [
            HorizontalBarChart(balances, height: 40),
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            DropdownButtonFormField<int>(
              decoration:
              InputDecoration(labelText: s.fromPool),
              value: _fromPool,
              items: pools.asMap().entries
                  .map((e) => DropdownMenuItem(
                  child: Text(e.value), value: e.key))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _fromPool = v!;
                });
              }
            ),
            DropdownButtonFormField<int>(
                decoration:
                InputDecoration(labelText: s.toPool),
                value: _toPool,
                items: pools.asMap().entries
                    .map((e) => DropdownMenuItem(
                    child: Text(e.value), value: e.key))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _toPool = v!;
                  });
                }
            ),
            DualMoneyInputWidget(key: _amountKey, initialValue: 0, spendable: _spendable, max: true),
            Text(s.maxSpendableAmount(amountToString(_spendable, MAX_PRECISION), active.coinDef.ticker)),
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            TextFormField(
                decoration:
                InputDecoration(labelText: s.memo),
                minLines: 4,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _memoController),
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            TextFormField(
              decoration: InputDecoration(
              labelText: s.maxAmountPerNote),
              keyboardType: TextInputType.number,
              controller: _maxAmountController,
              inputFormatters: [
                makeInputFormatter(settings.useMillis)
              ],
              validator: _checkMaxAmountPerNote),
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            ElevatedButton.icon(onPressed: _transfer, icon: Icon(Icons.currency_exchange), label: Text(s.transfer))
          ]))),
    ));
  }

  int get _spendable {
    final b = active.poolBalances;
    switch (_fromPool) {
      case 0: return b.transparent;
      case 1: return b.sapling;
      case 2: return b.orchard;
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
        final txPlan = await WarpApi.transferPools(active.coin, active.id, 1 << _fromPool, 1 << _toPool, amount,
            includeFee, _memoController.text, stringToAmount(_maxAmountController.text), settings.anchorOffset);
        Navigator.of(context).pushReplacementNamed('/txplan', arguments: txPlan);
      }
      on String catch (message) {
        showSnackBar(message);
      }
    }
  }
}

String? _checkMaxAmountPerNote(String? vs) {
  final s = S.current;
  if (vs == null) return s.amountMustBeANumber;
  if (!checkNumber(vs)) return s.amountMustBeANumber;
  final v = parseNumber(vs);
  if (v < 0.0) return s.amountMustBePositive;
  return null;
}
