import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:warp/data_fb_generated.dart';

import '../appsettings.dart';
import '../accounts.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import 'scan.dart';
import 'utils.dart';

typedef QRValueSetter = void Function(FormFieldState<String>, String);
typedef Widget QRValueButtonBuilder(
  BuildContext context,
  String? Function(String?)? validator,
  FormFieldState<String> field,
  QRValueSetter setter,
);

class TextQRPicker extends StatefulWidget {
  final String name;
  final String value;
  final Widget? label;
  final List<QRValueButtonBuilder>? extraButtons;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  TextQRPicker(this.value,
      {super.key,
      required this.name,
      this.label,
      this.extraButtons,
      this.onChanged,
      this.onSaved,
      this.validator});

  @override
  State<StatefulWidget> createState() => TextQRPickerState();
}

class TextQRPickerState extends State<TextQRPicker> {
  late final valueController = TextEditingController(text: widget.value);
  FormFieldState<String>? _field;
  late final listener = () {
    _field?.didChange(valueController.text);
  };

  @override
  void initState() {
    super.initState();
    valueController.addListener(listener);
  }

  @override
  void dispose() {
    valueController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.value,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
      builder: (field) {
        _field = field;
        final buttons = [QRButton, ...?widget.extraButtons]
            .map((b) => b(context, widget.validator, field, _setValue))
            .toList();
        return Row(children: [
          Expanded(
            child: FormBuilderTextField(
              name: '_value',
              decoration: InputDecoration(
                  label: widget.label, errorText: field.errorText),
              minLines: 8,
              maxLines: 8,
              controller: valueController,
              onChanged: field.didChange,
            ),
          ),
          Container(
              width: 44,
              child: Column(children: [
                ...buttons,
              ])),
        ]);
      },
    );
  }

  _setValue(FormFieldState<String> field, String text) {
    valueController.text = text;
    field.didChange(text);
  }
}

Widget QRButton(
  BuildContext context,
  String? Function(String?)? validator,
  FormFieldState<String> field,
  QRValueSetter setter,
) {
  return IconButton(
    onPressed: () async {
      final text = await scanQRCode(context, validator: validator);
      setter(field, text);
    },
    icon: Icon(Icons.qr_code),
  );
}

class SegmentedPicker extends StatefulWidget {
  final String name;
  final List<Text> labels;
  final InputDecoration? decoration;
  final int initialValue;
  final int available;
  final bool multiSelectionEnabled;
  final Function(int?)? onChanged;
  final Function(int?)? onSaved;
  final bool show;

  SegmentedPicker(this.initialValue,
      {super.key,
      required this.name,
      required this.available,
      required this.labels,
      this.decoration,
      this.onChanged,
      this.onSaved,
      required this.multiSelectionEnabled,
      this.show = true});

  @override
  State<StatefulWidget> createState() => SegmentedPickerState();
}

class SegmentedPickerState extends State<SegmentedPicker> {
  late Set<int> _selected;
  @override
  void initState() {
    super.initState();
    _selected = PoolBitSet.toSet(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return SizedBox.shrink();

    final f = FormBuilderField(
      name: widget.name,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      builder: (field) {
        return SegmentedButton<int>(
          segments: [
            if (widget.available & 1 != 0)
              ButtonSegment(value: 0, label: widget.labels[0]),
            if (widget.available & 2 != 0)
              ButtonSegment(value: 1, label: widget.labels[1]),
            if (widget.available & 4 != 0)
              ButtonSegment(value: 2, label: widget.labels[2]),
          ],
          selected: _selected,
          onSelectionChanged: (values) {
            field.didChange(PoolBitSet.fromSet(values));
            setState(() {
              _selected = values;
            });
          },
          multiSelectionEnabled: widget.multiSelectionEnabled,
          showSelectedIcon: false,
        );
      },
    );

    return widget.decoration != null ?
      InputDecorator(decoration: widget.decoration!, child: f) : f;
  }
}

class AmountPicker extends StatefulWidget {
  final String name;
  final int initialAmount;
  final int? maxAmount;
  final Function(int?)? onSaved;
  final Function(int?)? onChanged;
  final bool showFiat;
  final bool showSlider;

  AmountPicker(
    this.initialAmount, {
    super.key,
    required this.name,
    this.maxAmount,
    this.onSaved,
    this.onChanged,
    this.showFiat = true,
    this.showSlider = true,
  });

  @override
  State<StatefulWidget> createState() => AmountPickerState();
}

class AmountPickerState extends State<AmountPicker> {
  late final zController =
      TextEditingController(text: amountToString(widget.initialAmount));
  final fController = TextEditingController();
  int disabledListeners = 0;
  double amountPercent = 0.0;
  double? fx;
  FormFieldState<int>? _field;

  @override
  void initState() {
    super.initState();
    zController.addListener(onZChanged);
    fController.addListener(onFChanged);
    Future(() async {
      final coin = coins[aa.coin];
      final _fx = await getFxRate(coin.currency, appSettings.currency);
      setState(() {
        fx = _fx;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final coin = coins[aa.coin];

    return FormBuilderField<int>(
        name: widget.name,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: validAmount,
        builder: (field) {
          _field = field;
          return Column(children: [
            FormBuilderTextField(
              name: '_amount_crypto',
              decoration: InputDecoration(label: Text(coin.ticker), errorText: field.errorText),
              controller: zController,
            ),
            if (widget.showFiat)
              FormBuilderTextField(
                name: '_amount_fiat',
                decoration: InputDecoration(label: Text(appSettings.currency)),
                controller: fController,
              ),
            if (widget.showSlider && widget.maxAmount != null)
              Slider(
                  value: amountPercent,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: onSliderChanged),
          ]);
        });
  }

  onZChanged() {
    // Prevent circular updates
    // disabledListeners is a bit flag of handlers that have already triggered
    // 0x01 -> Z currency
    // 0x02 -> Fiat

    if (disabledListeners & 1 != 0) return;
    try {
      disabledListeners |= 1;
      final zAmount = double.tryParse(zController.text);
      // Do not update a field that was handled
      if (zAmount != null) {
        if (disabledListeners & 2 == 0 && fx != null) {
          final fAmount = zAmount * fx!;
          fController.text = zecToString(fAmount);
        } else
          fController.text = '';
        _field?.didChange((zAmount * ZECUNIT).truncate());
      }
      setSlider();
    } finally {
      disabledListeners &= ~1;
    }
  }

  onFChanged() {
    if (disabledListeners & 2 != 0) return;
    try {
      disabledListeners |= 2;
      if (disabledListeners & 1 == 0 && fx != null && fx != 0) {
        final fAmount = double.tryParse(fController.text);
        if (fAmount != null) {
          final zAmount = fAmount / fx!;
          zController.text = zecToString(zAmount);
        } else
          zController.text = '';
        setSlider();
      }
    } finally {
      disabledListeners &= ~2;
    }
  }

  onSliderChanged(double v) {
    final max = widget.maxAmount!;
    setState(() {
      amountPercent = v;
      zController.text = amountToString(max * v ~/ 100);
    });
  }

  setSlider() {
    amountPercent = 0;
    final zAmount = double.tryParse(zController.text);
    if (zAmount != null) {
      final max = widget.maxAmount;
      if (max != null) {
        final p = zAmount * ZECUNIT * 100 / max;
        amountPercent = p.clamp(0, 100);
      }
    }
    setState(() {});
  }

  maximize() {
    widget.maxAmount?.let((m) => zController.text = amountToString(m));
  }

  String? validAmount(int? v) {
    final S s = S.of(context);
    if (v! <= 0) return s.amountMustBePositive;
    return null;
  }
}

class MemoInput extends StatefulWidget {
  final String name;
  final UserMemoT memo;
  final Function(UserMemoT?)? onSaved;
  final bool show;
  final bool advanced;

  MemoInput(this.memo,
      {required this.name,
      this.onSaved,
      this.show = true,
      this.advanced = true});

  @override
  State<StatefulWidget> createState() => MemoInputState();
}

class MemoInputState extends State<MemoInput> {
  late final S s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();

  late UserMemoT memo = widget.memo;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<UserMemoT>(
        name: widget.name,
        initialValue: memo,
        onSaved: widget.onSaved,
        builder: (field) {
          return widget.show
              ? FormBuilder(
                  key: formKey,
                  child: Column(children: [
                    if (widget.advanced)
                      FormBuilderSwitch(
                        name: 'reply',
                        title: Text(s.includeReplyTo),
                        onChanged: (v) {
                          memo.replyTo = v ?? false;
                          field.didChange(memo);
                        },
                      ),
                    if (widget.advanced)
                      FormBuilderTextField(
                        name: 'subject',
                        decoration: InputDecoration(label: Text(s.subject)),
                        initialValue: memo.subject,
                        onChanged: (v) {
                          memo.subject = v;
                          field.didChange(memo);
                        },
                      ),
                    FormBuilderTextField(
                      name: 'body',
                      decoration: InputDecoration(label: Text(s.body)),
                      initialValue: memo.body,
                      onChanged: (v) {
                        memo.body = v;
                        field.didChange(memo);
                      },
                      maxLines: 10,
                    ),
                  ]))
              : SizedBox.shrink();
        });
  }
}
