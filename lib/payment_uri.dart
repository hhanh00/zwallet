import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dualmoneyinput.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';
import 'settings.dart';

class PaymentURIPage extends StatefulWidget {
  @override
  PaymentURIState createState() => PaymentURIState();
}

class PaymentURIState extends State<PaymentURIPage> {
  var _memoController = TextEditingController(text: '');
  var qrText = "";
  var address = "";
  final _formKey = GlobalKey<FormState>();
  final amountKey = GlobalKey<DualMoneyInputState>();
  final hasUA = active.coinDef.supportsUA;
  var uaType = settings.uaType;
  List<String> uaList = [];

  @override
  void initState() {
    super.initState();
    if (uaType & 1 != 0) uaList.add('T');
    if (uaType & 2 != 0) uaList.add('S');
    if (uaType & 4 != 0) uaList.add('O');
    address = _decodeCheckboxes(uaList);
    qrText = address;
    Future.microtask(() {
      priceStore.fetchCoinPrice(active.coin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final qrSize = getScreenSize(context) / 1.5;

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(title: Text(S.of(context).receive(activeCoin().ticker))),
          body: SingleChildScrollView(
            child: GestureDetector(
                onTap: () { FocusScope.of(context).unfocus(); },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(onTap: _ok, child: QrImage(
                            data: qrText,
                            size: qrSize,
                            backgroundColor: Colors.white)),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(qrText, style: t.textTheme.labelSmall),
                          Padding(padding: EdgeInsets.all(4)),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Expanded(child: FormBuilderCheckboxGroup<String>(
                                orientation: OptionsOrientation.horizontal,
                                name: 'ua',
                                decoration: InputDecoration(labelText: 'Main Address Type'),
                                initialValue: uaList,
                                onChanged: _onUAType,
                                options: [
                                  FormBuilderFieldOption(value: 'T'),
                                  FormBuilderFieldOption(value: 'S'),
                                  FormBuilderFieldOption(value: 'O'),
                                ])),
                            ElevatedButton.icon(onPressed: _onAddressCopy, icon: Icon(Icons.content_copy), label: Text(S.current.copy))
                          ]),
                          Padding(padding: EdgeInsets.all(8)),
                          DualMoneyInputWidget(key: amountKey),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: S.of(context).memo),
                            minLines: 4,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: _memoController,
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          ButtonBar(children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.clear),
                              label: Text('RESET'),
                              onPressed: _reset,
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.build),
                              label: Text('MAKE QR'),
                              onPressed: _ok,
                            ),
                          ]),
                        ]))))));
  }

  String _getQR() {
    final amount = amountKey.currentState!.amount;
    final memo = _memoController.text;

    final String _qrText;
    if (amount > 0) {
      return WarpApi.makePaymentURI(address, amount, memo);
    }
    return address;
  }

  _onAddressCopy() {
    Clipboard.setData(ClipboardData(text: qrText));
    showSnackBar(S.of(context).addressCopiedToClipboard);
  }

  void _onUAType(List<String>? types) {
    if (types == null) { return; }
    setState(() {
      if (types.isEmpty) {
        address = active.getAddress(true, true, true);
      }
      else
        address = _decodeCheckboxes(types);
      qrText = _getQR();
    });
  }

  String _decodeCheckboxes(List<String> types) {
    var t = false;
    var s = false;
    var o = false;
    if (types.contains("T")) t = true;
    if (types.contains("S")) s = true;
    if (types.contains("O")) o = true;
    return active.getAddress(t, s, o);
  }

  void _reset() {
    _memoController.clear();
    amountKey.currentState?.clear();
    setState(() {
      qrText = address;
    });
  }

  void _ok() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        qrText = _getQR();
      });
      FocusScope.of(context).unfocus();
    }
  }
}
