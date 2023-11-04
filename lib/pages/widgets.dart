import 'dart:convert';

import 'package:YWallet/db.dart';
import 'package:YWallet/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:warp_api/data_fb_generated.dart';

import '../accounts.dart';
import '../appsettings.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../main.dart';
import '../store.dart';
import 'scan.dart';
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

class RecipientWidget extends StatelessWidget {
  final RecipientT recipient;
  final bool? selected;
  late final ZMessage message;
  RecipientWidget(this.recipient, {this.selected}) {
    message = ZMessage(
      0,
      0,
      false,
      '',
      recipient.address!,
      recipient.subject!,
      recipient.memo!,
      DateTime.now(),
      0,
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final select = selected ?? false;
    return Card(
        color: select ? t.primaryColor : null,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              if (recipient.replyTo)
                Text(s.includeReplyTo, style: t.textTheme.labelSmall),
              MessageContentWidget(
                  recipient.address!, message, recipient.memo!),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(amountToString2(recipient.amount))),
            ],
          ),
        ));
  }
}

class MosaicWidget extends StatelessWidget {
  final List<MosaicButton> buttons;
  MosaicWidget(this.buttons);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final palette = getPalette(t.primaryColor, buttons.length);
    return GridView.count(
      primary: true,
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: 2,
      children: buttons
          .asMap()
          .entries
          .map(
            (kv) => GFButton(
              onPressed: () async {
                final onPressed = kv.value.onPressed;
                if (onPressed != null) {
                  await onPressed();
                } else {
                  if (kv.value.secured) {
                    final auth = await authenticate(context, s.secured);
                    if (!auth) return;
                  }
                  GoRouter.of(context).push(kv.value.url);
                }
              },
              icon: kv.value.icon,
              type: GFButtonType.solid,
              textStyle: t.textTheme.bodyLarge,
              child: Text(kv.value.text!,
                  maxLines: 2, overflow: TextOverflow.fade),
              color: palette.colors[kv.key].toColor(),
              borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(32),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class MosaicButton {
  final String url;
  final String? text;
  final Widget? icon;
  final bool secured;
  final Future<void> Function()? onPressed;

  MosaicButton(
      {required this.url,
      required this.text,
      required this.icon,
      this.secured = false,
      this.onPressed});
}

class Title extends StatelessWidget {
  final String title;
  Title(this.title);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: t.colorScheme.primary),
        child: Text(title, style: t.textTheme.bodyLarge));
  }
}

class InputAddress extends StatelessWidget {
  final String initialValue;
  final void Function(String?)? onSaved;
  InputAddress(this.initialValue, {this.onSaved});

  late final addressController = TextEditingController(text: initialValue);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilderField(
      name: 'address',
      validator: addressValidator,
      onSaved: onSaved,
      builder: (FormFieldState<dynamic> field) {
        return Row(children: [
          Expanded(
            child: TextField(
              controller: addressController,
              maxLines: 4,
              decoration: InputDecoration(
                label: Text(s.address),
                errorText: field.errorText,
              ),
              onChanged: (v) => field.didChange(v),
            ),
          ),
          Gap(16),
          Container(
            width: 80,
            child: IconButton.outlined(
              onPressed: () => qr(context),
              icon: Icon(Icons.qr_code),
            ),
          ),
        ]);
      },
    );
  }

  qr(BuildContext context) async {
    addressController.text =
        await scanQRCode(context, validator: addressValidator);
  }
}

class PoolSelection extends StatefulWidget {
  final PoolBalanceT balances;
  final void Function(int? pools)? onChanged;
  final int initialValue;
  PoolSelection(this.initialValue, {required this.balances, this.onChanged});
  @override
  State<StatefulWidget> createState() => _PoolSelectionState();
}

class _PoolSelectionState extends State<PoolSelection> {
  @override
  Widget build(BuildContext context) {
    List<int> initialPools = [];
    var p = widget.initialValue;
    for (var i = 0; i < 3; i++) {
      if (p & 1 != 0) initialPools.add(i);
      p ~/= 2;
    }

    return FormBuilderFilterChip<int>(
      name: 'pool_select',
      initialValue: initialPools,
      onChanged: (values) {
        int pools = 0;
        for (var v in values!) {
          pools |= 1 << v;
        }
        widget.onChanged?.call(pools);
      },
      spacing: 8,
      options: [
        FormBuilderChipOption(
            value: 0,
            child: Text(
              '${amountToString2(widget.balances.transparent)}',
              style: TextStyle(color: Colors.red),
            )),
        FormBuilderChipOption(
            value: 1,
            child: Text(
              '${amountToString2(widget.balances.sapling)}',
              style: TextStyle(color: Colors.orange),
            )),
        FormBuilderChipOption(
            value: 2,
            child: Text(
              '${amountToString2(widget.balances.orchard)}',
              style: TextStyle(color: Colors.green),
            )),
      ],
    );
  }
}

enum AmountSource {
  Crypto,
  Fiat,
  Slider,
}

class AmountPicker extends StatefulWidget {
  final int? spendable;
  final int initialAmount;
  final void Function(int?)? onChanged;
  AmountPicker(this.initialAmount, {this.spendable, this.onChanged});
  @override
  State<StatefulWidget> createState() => _AmountPickerState();
}

class _AmountPickerState extends State<AmountPicker> {
  late final s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  double? fxRate;
  int _amount = 0;
  double _sliderValue = 0;
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
      _update(null, AmountSource.Crypto);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = coins[aa.coin];
    final spendable = widget.spendable;
    return FormBuilderField(
        name: 'amount',
        initialValue: widget.initialAmount,
        onChanged: widget.onChanged,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.min(0, inclusive: false),
          if (spendable != null)
            (int? v) => v! > spendable ? s.notEnoughBalance : null,
        ]),
        builder: (field) {
          return Column(children: [
            Gap(16),
            if (spendable != null)
              Text('${s.spendable}  ${amountToString2(spendable)}'),
            TextField(
              decoration: InputDecoration(
                  label: Text(c.ticker), errorText: field.errorText),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v0) {
                final v = v0.isEmpty ? '0' : v0;
                try {
                  final zec = nformat.parse(v).toDouble();
                  _amount = (zec * ZECUNIT).toInt();
                  _update(field, AmountSource.Crypto);
                } on FormatException {}
              },
            ),
            TextField(
                decoration: InputDecoration(label: Text(appSettings.currency)),
                controller: fiatController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                enabled: fxRate != null,
                onChanged: (v0) {
                  final v = v0.isEmpty ? '0' : v0;
                  try {
                    final fiat = nformat.parse(v).toDouble();
                    final zec = fiat / fxRate!;
                    _amount = (zec * ZECUNIT).toInt();
                    _update(field, AmountSource.Fiat);
                  } on FormatException {}
                }),
            if (spendable != null)
              Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                divisions: 10,
                onChanged: (v) {
                  _amount = spendable * v ~/ 100;
                  _sliderValue = v;
                  _update(field, AmountSource.Slider);
                },
              )
          ]);
        });
  }

  _update(FormFieldState? field, AmountSource source) {
    if (source != AmountSource.Crypto)
      amountController.text = nformat.format(_amount / ZECUNIT);
    fxRate?.let((fx) {
      if (source != AmountSource.Fiat)
        fiatController.text = nformat.format(_amount * fx / ZECUNIT);
    });
    final spendable = widget.spendable;
    if (source != AmountSource.Slider && spendable != null && spendable > 0) {
      final p = _amount / spendable * 100;
      _sliderValue = p.clamp(0.0, 100.0);
    }
    field?.didChange(_amount);
    setState(() {});
  }
}

class InputMemo extends StatefulWidget {
  final MemoData memo;
  final void Function(MemoData?)? onSaved;
  InputMemo(this.memo, {super.key, this.onSaved});

  @override
  State<StatefulWidget> createState() => _InputMemoState();
}

class _InputMemoState extends State<InputMemo> {
  late MemoData value = widget.memo.clone();
  late final subjectController =
      TextEditingController(text: widget.memo.subject);
  late final memoController = TextEditingController(text: widget.memo.memo);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FormBuilderField<MemoData>(
        name: 'memo',
        initialValue: value,
        validator: (MemoData? v) {
          if (v == null) return null;
          if (utf8.encode(v.memo).length > 511) return s.memoTooLong;
          return null;
        },
        onSaved: widget.onSaved,
        builder: (field) {
          return Column(children: [
            FormBuilderFilterChip(name: 'reply', options: [
              FormBuilderChipOption(value: 1, child: Text(s.includeReplyTo))
            ],
            initialValue: [if (value.reply) 1],
                  onChanged: (v) => setState(() => value.reply = v!.isNotEmpty),
            ),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(label: Text(s.subject)),
              onChanged: (v) => setState(() => value.subject = v),
            ),
            TextField(
              controller: memoController,
              decoration: InputDecoration(label: Text(s.memo)),
              maxLines: 10,
              onChanged: (v) => setState(() => value.memo = v),
            )
          ]);
        });
  }
}
