import 'package:YWallet/appsettings.dart';
import 'package:YWallet/pages/widgets.dart';
import 'package:YWallet/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../accounts.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import 'scan.dart';
import 'utils.dart';

class SendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendPageState();
}

class SendPageState extends State<SendPage> {
  late final S s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final amountKey = GlobalKey<AmountPickerState>();
  int toRecvAvailable = 0;
  late final BalanceT balance;
  late String fromAddress;
  late int fromRecvAvailable;

  String? address;
  int? fromRecvSelected;
  int? toRecvSelected;
  int? amount;
  bool? fee_included;

  @override
  void initState() {
    super.initState();
    balance =
        warp.getBalance(aa.coin, aa.id, syncStatus.confirmHeight ?? MAXHEIGHT);
    fromAddress = warp.getAccountAddress(aa.coin, aa.id, now(), 7);
    fromRecvAvailable = warp.decodeAddress(aa.coin, fromAddress).mask;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: formKey,
        child: Column(children: [
          AddressPicker(
              'zs1j29m7zdhhyy2eqrz89l4zhk0angqjh368gqkj2vgdyqmeuultteny36n3qsm47zn8du5sw3ts7f',
              name: 'address',
              label: Text('Test Address'),
              validator: addressValidator,
              onChanged: onAddressChanged,
              onSaved: (v) => address = v),
          SegmentedPicker(toRecvAvailable,
              key: ValueKey(toRecvAvailable),
              name: 'to_receivers',
              available: toRecvAvailable,
              labels: [Text(s.transparent), Text(s.sapling), Text(s.orchard)],
              onSaved: (v) => toRecvSelected = v,
              multiSelectionEnabled: true,
              hidden: toRecvAvailable == 0),
          SegmentedPicker(fromRecvAvailable,
              name: 'from_receivers',
              available: fromRecvAvailable,
              labels: [
                Text(amountToString(balance.transparent)),
                Text(amountToString(balance.sapling)),
                Text(amountToString(balance.orchard))
              ],
              onSaved: (v) => fromRecvSelected = v,
              multiSelectionEnabled: true,
              hidden: false),
          AmountPicker(
            key: amountKey,
            enableSlider: true,
            maxAmount: balance.total,
            onSaved: (v) => amount = v,
          ),
          Row(children: [
            Expanded(
                child: FormBuilderCheckbox(
              name: 'fee_included',
              title: Text(s.deductFee),
              initialValue: fee_included,
              onSaved: (v) => fee_included = v,
            )),
            IconButton(
                onPressed: maximize, icon: FaIcon(FontAwesomeIcons.maximize))
          ]),
          IconButton(
              onPressed: () {
                print('pressed');
                formKey.currentState!.saveAndValidate();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  print(address);
                  print(fromRecvSelected ?? fromRecvAvailable);
                  print(toRecvSelected ?? toRecvAvailable);
                  print(amount);
                  print(fee_included);
                  print(formKey.currentState!.isValid);
                });
              },
              icon: Icon(Icons.check)),
        ]));
  }

  onAddressChanged(String? address) {
    if (address == null) return;
    setState(() {
      toRecvAvailable = warp.decodeAddress(aa.coin, address).mask;
    });
  }

  maximize() {
    setState(() {
      fee_included = true;
      formKey.currentState!.fields['fee_included']?.setValue(true);
      amountKey.currentState!.maximize();
    });
  }
}

typedef AddressSetter = void Function(FormFieldState<String>, String);
typedef Widget AddressButtonBuilder(
  BuildContext context,
  String? Function(String?)? validator,
  FormFieldState<String> field,
  AddressSetter setter,
);

class AddressPicker extends StatefulWidget {
  final String name;
  final String address;
  final Widget? label;
  final List<AddressButtonBuilder>? extraButtons;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  AddressPicker(this.address,
      {super.key,
      required this.name,
      this.label,
      this.extraButtons,
      this.onChanged,
      this.onSaved,
      this.validator});

  @override
  State<StatefulWidget> createState() => AddressPickerState();
}

class AddressPickerState extends State<AddressPicker> {
  late final addressController = TextEditingController(text: widget.address);
  FormFieldState<String>? _field;
  late final listener = () {
    _field?.didChange(addressController.text);
  };

  @override
  void initState() {
    super.initState();
    addressController.addListener(listener);
  }

  @override
  void dispose() {
    addressController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.address,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
      builder: (field) {
        _field = field;
        final buttons = [QRButton, ...?widget.extraButtons]
            .map((b) => b(context, widget.validator, field, _setAddress))
            .toList();
        return Row(children: [
          Expanded(
            child: FormBuilderTextField(
              name: '_address',
              decoration: InputDecoration(
                  label: widget.label, errorText: field.errorText),
              minLines: 8,
              maxLines: 8,
              controller: addressController,
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

  _setAddress(FormFieldState<String> field, String text) {
    addressController.text = text;
    field.didChange(text);
  }
}

Widget QRButton(
  BuildContext context,
  String? Function(String?)? validator,
  FormFieldState<String> field,
  AddressSetter setter,
) =>
    IconButton(
      onPressed: () async {
        final text = await scanQRCode(context, validator: validator);
        setter(field, text);
      },
      icon: Icon(Icons.qr_code),
    );

class AmountPicker extends StatefulWidget {
  final int initialAmount;
  final int? maxAmount;
  final Function(int?)? onSaved;
  final bool enableSlider;

  AmountPicker(
      {super.key,
      this.initialAmount = 0,
      this.maxAmount,
      this.onSaved,
      required this.enableSlider});

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
        name: '_amount',
        onSaved: widget.onSaved,
        builder: (field) {
          _field = field;
          return Column(children: [
            FormBuilderTextField(
              name: '_amount_crypto',
              decoration: InputDecoration(label: Text(coin.ticker)),
              controller: zController,
            ),
            FormBuilderTextField(
              name: '_amount_fiat',
              decoration: InputDecoration(label: Text(appSettings.currency)),
              controller: fController,
            ),
            if (widget.enableSlider && widget.maxAmount != null)
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
}

class MemoInput extends StatefulWidget {
  final UserMemoT memo;
  final Function(UserMemoT?)? onSaved;

  MemoInput(this.memo, {this.onSaved});

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
        name: '_memo',
        initialValue: memo,
        onSaved: widget.onSaved,
        builder: (field) {
          return FormBuilder(
              key: formKey,
              child: Column(children: [
                FormBuilderCheckbox(
                  name: 'reply',
                  title: Text(s.includeReplyTo),
                  onChanged: (v) {
                    memo.replyTo = v ?? false;
                    field.didChange(memo);
                  },
                ),
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
              ]));
        });
  }
}
