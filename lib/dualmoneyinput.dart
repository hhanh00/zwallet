import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'generated/l10n.dart';
import 'main.dart';

class DualMoneyInputWidget extends StatefulWidget {
  final Widget? child;
  final int? spendable;

  DualMoneyInputWidget({Key? key, this.child, this.spendable}): super(key: key);

  @override
  DualMoneyInputState createState() => DualMoneyInputState();
}

class DualMoneyInputState extends State<DualMoneyInputWidget> {
  static final zero = decimalFormat(0, 3);
  var useMillis = true;
  var inputInZEC = true;
  var zecAmountController = TextEditingController(text: zero);
  var fiatAmountController = TextEditingController(text: zero);
  var amount = 0;

  ReactionDisposer? priceAutorunDispose;

  @override
  void initState() {
    super.initState();
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
    final child = widget.child;
    return Column(children: <Widget>[
        Row(children: [
          Expanded(
              child: TextFormField(
                style: !inputInZEC
                    ? TextStyle(fontWeight: FontWeight.w200)
                    : TextStyle(),
                decoration: InputDecoration(
                    labelText:
                    s.amountInSettingscurrency(coin.ticker)),
                controller: zecAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: [makeInputFormatter(useMillis)],
                onTap: () => setState(() {
                  inputInZEC = true;
                }),
                validator: _checkAmount,
                onChanged: (_) => _updateFiatAmount(),
                onSaved: _onAmount,
              )),
          if (child != null) child,
        ]),
        Row(children: [
          Expanded(
              child: TextFormField(
                  style: inputInZEC
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
                    inputInZEC = false;
                  }),
                  onChanged: (_) => _updateAmount()))
        ]),
      ]);
  }

  void clear() {
    setState(() {
      useMillis = true;
      zecAmountController.text = zero;
      fiatAmountController.text = zero;
    });
  }

  void setMillis(bool useMillis) {
    setState(() {
      this.useMillis = useMillis;
    });
  }

  void setAmount(int amount) {
    setState(() {
      useMillis = false;
      zecAmountController.text = amountToString(amount);
      _updateFiatAmount();
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
    final rate = 1.0 / priceStore.zecPrice;
    final amount = parseNumber(fiatAmountController.text);
    final otherAmount = decimalFormat(amount * rate, precision(useMillis));
    setState(() {
      zecAmountController.text = otherAmount;
    });
  }

  void _updateFiatAmount() {
    final rate = priceStore.zecPrice;
    final amount = parseNumber(zecAmountController.text);
    final otherAmount = decimalFormat(amount * rate, precision(useMillis));
    setState(() {
      fiatAmountController.text = otherAmount;
    });
  }

  void _onAmount(String? vs) {
    amount = stringToAmount(vs);
  }
}
