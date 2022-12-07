import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'generated/l10n.dart';
import 'main.dart';

class DualMoneyInputWidget extends StatefulWidget {
  final int? spendable;
  final int? initialValue;
  final bool max;

  DualMoneyInputWidget({Key? key, this.initialValue, this.spendable,
    this.max = false}): super(key: key);

  @override
  DualMoneyInputState createState() => DualMoneyInputState();
}

class DualMoneyInputState extends State<DualMoneyInputWidget> {
  static final zero = decimalFormat(0, 3);
  var inputInCoin = true;
  var coinAmountController = TextEditingController(text: zero);
  var fiatAmountController = TextEditingController(text: zero);
  var amount = 0;
  var useMax = false;

  ReactionDisposer? priceAutorunDispose;

  bool get useMillis => settings.useMillis && !useMax;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.initialValue ?? 0;
    final amount = amountToString(initialValue, precision(useMillis));
    coinAmountController.text = amount;
    _updateFiatAmount();

    priceAutorunDispose = autorun((_) {
      _updateFiatAmount();
    });
  }

  @override
  void dispose() {
    priceAutorunDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(children: <Widget>[
        Row(children: [
          Expanded(
              child: TextFormField(
                style: !inputInCoin
                    ? TextStyle(fontWeight: FontWeight.w200)
                    : TextStyle(),
                decoration: InputDecoration(
                    labelText:
                    s.amountInSettingscurrency(active.coinDef.ticker)),
                controller: coinAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: [makeInputFormatter(useMillis)],
                onTap: () => setState(() {
                  inputInCoin = true;
                }),
                validator: _checkAmount,
                onChanged: (_) => _updateFiatAmount(),
                onSaved: _onAmount,
              )),
          if (widget.max) TextButton(child: Text(s.max), onPressed: _onMax),
        ]),
        Row(children: [
          Expanded(
              child: TextFormField(
                  style: inputInCoin
                      ? TextStyle(fontWeight: FontWeight.w200)
                      : TextStyle(),
                  decoration: InputDecoration(
                      labelText: s.amountInSettingscurrency(
                          settings.currency)),
                  controller: fiatAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [makeInputFormatter(useMillis)],
                  validator: (v) => _checkAmount(v, isFiat: true),
                  onTap: () => setState(() {
                    inputInCoin = false;
                  }),
                  onChanged: (_) => _updateAmount()))
        ]),
      ]);
  }

  void clear() {
    setState(() {
      useMax = false;
      coinAmountController.text = zero;
      fiatAmountController.text = zero;
    });
  }

  void setAmount(int amount) {
    setState(() {
      coinAmountController.text = amountToString(amount, MAX_PRECISION);
      _updateFiatAmount();
    });
  }

  void _onMax() {
    setState(() {
      final s = widget.spendable;
      if (s != null) {
        useMax = true;
        setAmount(s);
      }
    });
  }

  String? _checkAmount(String? vs, {bool isFiat: false}) {
    final s = S.of(context);
    if (vs == null) return s.amountMustBeANumber;
    if (!checkNumber(vs)) return s.amountMustBeANumber;
    final v = parseNumber(vs);
    if (v < 0.0) return s.amountMustBePositive;
    if (v >= MAXMONEY) return s.amountTooHigh;
    if (isFiat) return null;

    final spendable = widget.spendable;
    if (spendable != null && stringToAmount(vs) > spendable)
      return s.notEnoughBalance;
    return null;
  }

  void _updateAmount() {
    final rate = 1.0 / priceStore.coinPrice;
    final amount = parseNumber(fiatAmountController.text);
    final otherAmount = decimalFormat(amount * rate, precision(useMillis));
    setState(() {
      coinAmountController.text = otherAmount;
    });
  }

  void _updateFiatAmount() {
    final rate = priceStore.coinPrice;
    final amount = parseNumber(coinAmountController.text);
    final otherAmount = decimalFormat(amount * rate, precision(useMillis));
    setState(() {
      fiatAmountController.text = otherAmount;
    });
  }

  void _onAmount(String? vs) {
    amount = stringToAmount(vs);
  }
}
