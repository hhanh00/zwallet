import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../accounts.dart';
import '../generated/intl/messages.dart';
import '../store.dart';
import 'utils.dart';

class Panel extends StatelessWidget {
  final String title;
  final String? text;
  final int? maxLines;
  final Widget? child;
  final bool save;
  Panel(this.title, {this.text, this.maxLines, this.child, this.save = false});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
        decoration:
            InputDecoration(label: Text(title), border: OutlineInputBorder()),
        child: text != null
            ? Row(children: [
                Expanded(child: SelectableText(text!, maxLines: maxLines)),
                SizedBox(
                    width: 40,
                    child: IconButton(
                        onPressed: () => _copy(context),
                        icon: Icon(Icons.copy))),
                if (save)
                  SizedBox(
                      width: 40,
                      child: IconButton(
                          onPressed: () => _save(context),
                          icon: Icon(Icons.save))),
              ])
            : child);
  }

  _copy(BuildContext context) {
    final s = S.of(context);
    Clipboard.setData(ClipboardData(text: text!));
    showSnackBar(s.copiedToClipboard);
  }

  _save(BuildContext context) {
    GoRouter.of(context).push('/showqr?title=$title', extra: text!);
  }
}

class MoreSection {
  final Widget title;
  final List<MoreTile> tiles;
  MoreSection({
    required this.title,
    required this.tiles,
  });
}

class MoreTile {
  final String url;
  final String text;
  final Widget icon;
  final bool secured;
  final Future<void> Function()? onPressed;

  MoreTile(
      {required this.url,
      required this.text,
      required this.icon,
      this.secured = false,
      this.onPressed});
}

class MediumTitle extends StatelessWidget {
  final String title;
  MediumTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: t.colorScheme.primary),
        child: Text(title,
            style: t.textTheme.bodyLarge!
                .copyWith(color: t.colorScheme.background)));
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
        Container(
            height: size.height,
            width: size.width,
            color: t.colorScheme.background),
        Opacity(opacity: 0.4, child: child),
        Container(
          height: size.height - 200,
          child: Align(
              alignment: Alignment.center,
              child: LoadingAnimationWidget.hexagonDots(
                  color: t.colorScheme.primary, size: 100)),
        )
      ],
    );
  }
}

class HeightPicker extends StatefulWidget {
  final int height;
  final Widget? label;
  final void Function(int?)? onChanged;
  HeightPicker(this.height, {super.key, this.onChanged, this.label});

  @override
  State<StatefulWidget> createState() => HeightPicketState();
}

class HeightPicketState extends State<HeightPicker> {
  late final s = S.of(context);
  final fieldKey =
      GlobalKey<FormBuilderFieldState<FormBuilderField<int>, int>>();
  final formKey = GlobalKey<FormBuilderState>();
  late final heightController =
      TextEditingController(text: widget.height.toString());

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<int>(
        key: fieldKey,
        name: 'amount_form',
        initialValue: widget.height,
        validator: (_) {
          final formState = formKey.currentState!;
          if (formState.validate()) return null;
          return 'Invalid height';
        },
        onChanged: widget.onChanged,
        builder: (field) {
          return FormBuilder(
              key: formKey,
              child: Row(children: [
                Expanded(
                    child: FormBuilderTextField(
                        name: 'height_int',
                        decoration: InputDecoration(label: widget.label),
                        validator: FormBuilderValidators.integer(),
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: heightController,
                        onChanged: (v) {
                          final h = int.tryParse(v!);
                          h?.let((h) => field.didChange(h));
                        })),
                IconButton(
                    onPressed: () => pickCalendar(field),
                    icon: Icon(Icons.calendar_today)),
              ]));
        });
  }

  pickCalendar(FormFieldState<int> field) async {
    final height = int.parse(heightController.text);
    final date = DateTime.fromMillisecondsSinceEpoch(
        await warp.getTimeByHeight(aa.coin, height) * 1000);
    final h =
        await GoRouter.of(context).push<int>('/calendar_height', extra: date);
    h?.let((h) => heightController.text = h.toString());
  }
}

class CalendarHeightPage extends StatefulWidget {
  final DateTime date;
  CalendarHeightPage(this.date);
  @override
  State<StatefulWidget> createState() => CalendarHeightState();
}

class CalendarHeightState extends State<CalendarHeightPage> {
  late S s = S.of(context);
  int? height;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final activationDate = DateTime.fromMillisecondsSinceEpoch(
        warp.getActivationDate(aa.coin) * 1000);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _2) {
        if (didPop) return;
        WidgetsBinding.instance
            .addPostFrameCallback((_) => GoRouter.of(context).pop(height));
      },
      child: Scaffold(
        appBar: AppBar(title: Text(s.birthHeight)),
        body: CalendarDatePicker(
          initialDate: widget.date,
          firstDate: activationDate,
          lastDate: today,
          onDateChanged: selectDate,
        ),
      ),
    );
  }

  selectDate(DateTime? date) async {
    final d = date!.millisecondsSinceEpoch ~/ 1000;
    height = await warp.getHeightByTime(aa.coin, d);
  }
}

class Jumbotron extends StatelessWidget {
  final Severity severity;
  final String? title;
  final String message;
  Jumbotron(this.message, {this.title, this.severity = Severity.Info});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final Color color;
    switch (severity) {
      case Severity.Error:
        color = Colors.red;
        break;
      case Severity.Warning:
        color = Colors.orange;
        break;
      default:
        color = cs.primary;
        break;
    }
    return Stack(
      children: [
        Align(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsetsDirectional.all(15),
            decoration: BoxDecoration(
                color: cs.primary,
                border: Border.all(color: color, width: 4),
                borderRadius: BorderRadius.all(Radius.circular(32))),
            child: SelectableText(message,
                style:
                    t.textTheme.headlineMedium!.copyWith(color: cs.onPrimary)),
          ),
        ),
        if (title != null)
          Align(
            alignment: Alignment.topCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: color, width: 4), color: color),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(title!, style: TextStyle(color: cs.onPrimary))),
            ),
          )
      ],
    );
  }
}

enum Severity {
  Info,
  Warning,
  Error,
}

class AnimatedQR extends StatefulWidget {
  final String title;
  final String caption;
  final List<PacketT> chunks;

  AnimatedQR(this.title, this.caption, this.chunks);

  @override
  State<StatefulWidget> createState() => _AnimatedQRState();
}

class _AnimatedQRState extends State<AnimatedQR> {
  var index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        index += 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final idx = index % widget.chunks.length;
    final qrSize = getScreenSize(context) * 0.8;
    final packet = widget.chunks[idx];
    final data = base64Encode(packet.data!);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImage(
            key: ValueKey(idx),
            data: data,
            size: qrSize,
            backgroundColor: Colors.white),
        Gap(8),
        Text(widget.caption, style: theme.textTheme.titleMedium),
      ],
    ));
  }
}

class HorizontalBarChart extends StatelessWidget {
  final List<double> values;
  final double height;

  HorizontalBarChart(this.values, {this.height = 32});

  @override
  Widget build(BuildContext context) {
    final palette = getPalette(Theme.of(context).primaryColor, values.length);

    final sum = values.fold<double>(0, ((acc, v) => acc + v));
    final stacks = values.asMap().entries.map((e) {
      final i = e.key;
      final color = palette[i];
      final v = NumberFormat.compact().format(values[i]);
      final flex = sum != 0 ? max((values[i] / sum * 100).round(), 1) : 1;
      return Flexible(
          child: Container(
              child: Center(
                  child: Text(v,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white))),
              color: color,
              height: height),
          flex: flex);
    }).toList();

    return IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: stacks));
  }
}

class MessageContentWidget extends StatelessWidget {
  final String address;
  final ZMessage? message;

  MessageContentWidget(this.address, this.message);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = message;
    final addressWidget =
        Text('${centerTrim(address)}', style: theme.textTheme.labelMedium);
    return Column(children: [
      addressWidget,
      if (m != null) Text("${m.subject}", style: theme.textTheme.titleSmall),
      if (m != null && m.subject != m.body)
        Text("${m.body}", style: theme.textTheme.bodySmall),
    ]);
  }
}

class SwapAmountWidget extends StatefulWidget {
  final String name;
  final SwapAmount initialValue;
  final bool readOnly;
  final List<String>? currencies;
  final void Function(SwapAmount)? onChanged;

  const SwapAmountWidget({
    super.key,
    required this.name,
    required this.initialValue,
    this.readOnly = false,
    this.currencies,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => SwapAmountState();
}

class SwapAmountState extends State<SwapAmountWidget> {
  var formKey = GlobalKey<FormBuilderState>();
  var fieldKey = GlobalKey<
      FormBuilderFieldState<FormBuilderField<SwapAmount>, SwapAmount>>();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final items = widget.currencies
        ?.map((c) => DropdownMenuItem(value: c, child: Text(c)))
        .toList();

    logger.d('build -> ${widget.initialValue}');

    return FormBuilderField<SwapAmount>(
      key: fieldKey,
      name: widget.name,
      initialValue: widget.initialValue,
      onChanged: (v) => widget.onChanged?.call(v!),
      builder: (FormFieldState<SwapAmount> field) {
        return FormBuilder(
          key: formKey,
          child: SizedBox(
            height: 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                      width: 180,
                      child: FormBuilderTextField(
                        name: 'amount',
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorText: field.errorText,
                        ),
                        readOnly: widget.readOnly,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        initialValue: value.amount.toString(),
                        onChanged: (v) {
                          field.didChange(value.copyWith(amount: v!));
                        },
                      )),
                  items != null
                      ? SizedBox(
                          width: 140,
                          child: FormBuilderDropdown(
                            name: 'currency',
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            items: items,
                            initialValue: value.currency,
                            onChanged: (v) =>
                                field.didChange(value.copyWith(currency: v!)),
                          ))
                      : Text(value.currency, style: t.textTheme.bodyLarge),
                ]),
          ),
        );
      },
    );
  }

  void update(SwapAmount value) {
    logger.d('update $value');
    final f = formKey.currentState!;
    f.fields['amount']!.didChange(value.amount);
    f.fields['currency']!.didChange(value.currency);
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  void invalidate(String error) {
    formKey.currentState!.fields['amount']!.invalidate(error);
  }

  void resetAmount() {
    logger.d('reset amount');
    formKey.currentState!.fields['amount']!.didChange('0');
  }

  SwapAmount get value => fieldKey.currentState!.value!;
}
