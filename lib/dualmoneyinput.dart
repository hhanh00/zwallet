import 'package:YWallet/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobx/mobx.dart';

import 'generated/l10n.dart';
import 'main.dart';

class DualMoneyInputWidget extends StatefulWidget {
  late final String fiat;
  final int? spendable;
  final int? initialValue;
  final bool max;
  final Function(int)? onChange;

  DualMoneyInputWidget(
      {Key? key, this.initialValue, this.spendable, String? fiat, this.max = false, this.onChange})
      : super(key: key) {
    this.fiat = fiat ?? settings.currency;
  }

  @override
  DualMoneyInputState createState() => DualMoneyInputState();
}

class DualMoneyInputState extends State<DualMoneyInputWidget> {
  var zero = "";
  var inputInCoin = true;
  var coinAmountController = TextEditingController();
  var fiatAmountController = TextEditingController();
  late String _fiat;
  var _fxRate = 0.0;
  var amount = 0;
  double sliderValue = 0;
  var _feeIncluded = false;

  ReactionDisposer? priceAutorunDispose;

  bool get isMax => sliderValue == 100.0;

  bool get useMillis => settings.useMillis && !isMax;

  bool get feeIncluded => _feeIncluded || isMax;

  @override
  void initState() {
    super.initState();
    _fiat = widget.fiat;
    zero = amountToString(0, precision(useMillis));
    final initialValue = widget.initialValue ?? 0;
    final amount = amountToString(initialValue, precision(useMillis));
    coinAmountController.text = amount;
    _updateFxRate();
    _updateSlider();
  }

  void _updateFxRate() {
    Future.microtask(() async {
      final rate = await getFxRate(active.coinDef.currency, _fiat) ?? 0.0;
      setState(() {
        _fxRate = rate;
        if (inputInCoin)
          _updateFiatAmount();
        else
          _updateAmount();
      });
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
                    labelText: s.amountInSettingscurrency(active.coinDef.ticker)),
                controller: coinAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: [makeInputFormatter(useMillis)],
                onTap: () => setState(() {
                  inputInCoin = true;
                }),
                validator: _checkAmount,
                onChanged: (_) {
                  _updateFiatAmount();
                  _updateSlider();
                  _onChanged();
                },
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
                    labelText: s.amountInSettingscurrency(_fiat)),
                controller: fiatAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: [makeInputFormatter(useMillis)],
                validator: (v) => _checkAmount(v, isFiat: true),
                onTap: () => setState(() {
                      inputInCoin = false;
                    }),
                onChanged: (_) {
                  _updateAmount();
                  _updateSlider();
                }))
      ]),
      if (widget.spendable != null)
        Slider(
            value: sliderValue,
            onChanged: _onSliderChanged,
            min: 0,
            max: 100,
            divisions: 20,
            label: "${sliderValue.toInt()} %"),
      if (widget.spendable != null)
        FormBuilderCheckbox(
            key: UniqueKey(),
            name: 'fee',
            title: Text(s.includeFeeInAmount),
            initialValue: _feeIncluded || isMax,
            onChanged: (v) {
              setState(() {
                _feeIncluded = v ?? false;
              });
            }),
    ]);
  }

  void clear() {
    setState(() {
      _fiat = settings.currency;
      _feeIncluded = false;
      coinAmountController.text = zero;
      fiatAmountController.text = zero;
      sliderValue = 0;
      _onChanged();
    });
  }

  void setAmount(int amount) {
    setState(() {
      coinAmountController.text = amountToString(amount, MAX_PRECISION);
      _updateFiatAmount();
      _updateSlider();
      _onChanged();
    });
  }

  _onSliderChanged(double v) {
    setState(() {
      sliderValue = v;
      if (sliderValue == 100) {
        _onMax();
      } else {
        final a = (widget.spendable! * v / 100).round();
        coinAmountController.text =
            amountToString(a, precision(settings.useMillis));
        _updateFiatAmount();
        _onChanged();
      }
    });
  }

  void _onMax() {
    setState(() {
      final s = widget.spendable;
      if (s != null) {
        sliderValue = 100;
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
    final rate = 1.0 / _fxRate;
    final amount = parseNumber(fiatAmountController.text);
    final otherAmount = decimalFormat(amount * rate, precision(useMillis));
    setState(() {
      coinAmountController.text = otherAmount;
      _onChanged();
    });
  }

  void _updateFiatAmount(){
    final amount = parseNumber(coinAmountController.text);
    final otherAmount = decimalFormat(amount * _fxRate, precision(useMillis));
    setState(() {
      fiatAmountController.text = otherAmount;
    });
  }

  void _updateSlider() {
    final spendable = widget.spendable;
    setState(() {
      final amount = stringToAmount(coinAmountController.text);
      if (spendable != null) {
        sliderValue = (amount / spendable * 100).clamp(0, 100);
      }
    });
  }

  void _onAmount(String? vs) {
    amount = stringToAmount(vs);
  }

  Future<void> restore(int amount, double amountInFiat, bool feeIncluded, String? fiat) async {
    final rate = await getFxRate(active.coinDef.currency, fiat ?? settings.currency) ?? 0.0;
    setState(() {
      _fxRate = rate;
      if (fiat != null) {
        _fiat = fiat;
        fiatAmountController.text = decimalFormat(amountInFiat, precision(settings.useMillis));
        inputInCoin = false;
        _updateAmount();
      }
      else {
        coinAmountController.text = amountToString(amount, precision(settings.useMillis));
        inputInCoin = true;
        _updateFiatAmount();
        _onChanged();
      }
      _feeIncluded = feeIncluded;
      _updateSlider();
    });
  }

  _onChanged() {
    final onChange = widget.onChange;
    if (onChange != null) {
      amount = stringToAmount(coinAmountController.text);
      onChange(amount);
    }
  }
}
