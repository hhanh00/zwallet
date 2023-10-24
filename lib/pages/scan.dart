import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:go_router/go_router.dart';

import '../generated/intl/messages.dart';

class ScanQRCodePage extends StatefulWidget {
  final bool Function(String code) onCode;
  final String? Function(String? code)? validator;
  ScanQRCodePage(ScanQRContext context): onCode = context.onCode,
    validator = context.validator;
  @override
  State<StatefulWidget> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCodePage> {
  final formKey = GlobalKey<FormBuilderState>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.scanQrCode)),
      body: 
        FormBuilder(key: formKey,
        child: Column(children: [
          Expanded(child: ReaderWidget(onScan: _onScan)),
          SizedBox(height: 16),
          FormBuilderTextField(name: 'qr',
            readOnly: true,
            controller: controller,
            validator: widget.validator),
        ])
    ));
  }

  _onScan(Code code) {
    final text = code.text;
    if (text == null) return;
    controller.text = text;
    final form = formKey.currentState!;
    if (form.validate()) {
      if (widget.onCode(text)) GoRouter.of(context).pop();
    }
  }
}

Future<String> scanQRCode(
  BuildContext context, {
  bool multi = false,
  String? Function(String? code)? validator,
}) {
  final completer = Completer<String>();
  bool onCode(String c) {
    completer.complete(c);
    return true;
  }

  GoRouter.of(context)
      .push('/scan', extra: ScanQRContext(onCode, validator: validator));
  return completer.future;
}

class ScanQRContext {
  final bool Function(String) onCode;
  final String? Function(String? code)? validator;
  ScanQRContext(this.onCode, {this.validator});
}
