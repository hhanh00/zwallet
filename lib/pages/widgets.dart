import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../accounts.dart';
import '../appsettings.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../main.dart';
import '../store.dart';
import 'utils.dart';

class Panel extends StatelessWidget {
  final String title;
  final String? text;
  final Widget? child;
  Panel(this.title, {this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
        decoration:
            InputDecoration(label: Text(title), border: OutlineInputBorder()),
        child: text != null ? SelectableText(text!) : child);
  }
}

enum AmountSource {
  Crypto,
  Fiat,
  Slider,
}

class AmountState {
  int amount;
  int? spendable;
  AmountState({required this.amount, this.spendable});
}

class InputAmountWidget extends StatefulWidget {
  final AmountState initialAmount;
  final void Function(int)? onChange;
  InputAmountWidget(this.initialAmount, {super.key, this.onChange});

  @override
  State<StatefulWidget> createState() => InputAmountState();
}

class InputAmountState extends State<InputAmountWidget> {
  final formKey = GlobalKey<FormBuilderState>();
  double? fxRate;
  int _amount = 0;
  final amountController = TextEditingController();
  final fiatController = TextEditingController();
  final nformat = NumberFormat.decimalPatternDigits(
      decimalDigits: decimalDigits(appSettings.fullPrec));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final c = coins[aa.coin];
      fxRate = await getFxRate(c.currency, appSettings.currency);
      _update(AmountSource.Crypto);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final c = coins[aa.coin];
    final spendable = widget.initialAmount.spendable;
    return FormBuilder(
      key: formKey,
      child: Column(children: [
        if (spendable != null)
          Text('${s.spendable}  ${amountToString2(spendable)}'),
        SizedBox(height: 16),
        FormBuilderTextField(
          name: 'amount',
          decoration: InputDecoration(label: Text(c.ticker)),
          controller: amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (v0) {
            final v = v0 == null || v0.isEmpty ? '0' : v0;
            try {
              final zec = nformat.parse(v).toDouble();
              _amount = (zec * ZECUNIT).toInt();
              _update(AmountSource.Crypto);
            } on FormatException {}
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.min(0, inclusive: false),
            if (spendable != null) FormBuilderValidators.max(spendable),
          ]),
        ),
        FormBuilderTextField(
            name: 'fiat',
            decoration: InputDecoration(label: Text(appSettings.currency)),
            controller: fiatController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            enabled: fxRate != null,
            onChanged: (v0) {
              final v = v0 == null || v0.isEmpty ? '0' : v0;
              try {
                final fiat = nformat.parse(v).toDouble();
                final zec = fiat / fxRate!;
                _amount = (zec * ZECUNIT).toInt();
                _update(AmountSource.Fiat);
              } on FormatException {}
            }),
        if (spendable != null)
          FormBuilderSlider(
            name: 'slider',
            initialValue: 0,
            min: 0,
            max: 100,
            divisions: 10,
            onChanged: (v0) {
              final v = v0 ?? 0;
              _amount = spendable * v ~/ 100;
              _update(AmountSource.Slider);
            },
          )
      ]),
    );
  }

  _update(AmountSource source) {
    if (source != AmountSource.Crypto)
      amountController.text = nformat.format(_amount / ZECUNIT);
    fxRate?.let((fx) {
      if (source != AmountSource.Fiat)
        fiatController.text = nformat.format(_amount * fx / ZECUNIT);
    });
    final spendable = widget.initialAmount.spendable;
    if (source != AmountSource.Slider && spendable != null && spendable > 0) {
      final p = _amount / spendable * 100;
      formKey.currentState!.fields['slider']!.setValue(p.clamp(0.0, 100.0));
    }
    widget.onChange?.let((onChange) => onChange.call(_amount));
    setState(() {});
  }

  int? get amount {
    if (!validate()) return null;
    return _amount;
  }

  bool validate() {
    return formKey.currentState!.validate();
  }
}

class LoadingWrapper extends StatelessWidget {
  final bool loading;
  final Widget child;

  LoadingWrapper(this.loading, {super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!loading) return child;
    final t = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Opacity(opacity: 0.4, child: child),
        Container(
          height: size.height - 200,
          child: Align(
              alignment: Alignment.center,
              child: LoadingAnimationWidget.hexagonDots(
                  color: t.primaryColor, size: 100)),
        )
      ],
    );
  }
}
