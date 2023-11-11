import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/warp_api.dart';

import '../generated/intl/messages.dart';

class ScanQRCodePage extends StatefulWidget {
  final bool Function(String code) onCode;
  final String? Function(String? code)? validator;
  ScanQRCodePage(ScanQRContext context)
      : onCode = context.onCode,
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
        appBar: AppBar(title: Text(s.scanQrCode),
        actions: [
          IconButton(onPressed: _ok, icon: Icon(Icons.check))
        ]),
        body: FormBuilder(
            key: formKey,
            child: Column(children: [
              Expanded(child: ReaderWidget(onScan: _onScan)),
              Gap(16),
              FormBuilderTextField(
                  name: 'qr',
                  decoration: InputDecoration(label: Text(s.qr)),
                  controller: controller,
                  validator: widget.validator),
            ])));
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

  _ok() {
    if (formKey.currentState!.validate()) {
      if (widget.onCode(controller.text)) GoRouter.of(context).pop();
    }
  }
}

class MultiQRReader extends StatefulWidget {
  final void Function(String?)? onChanged;
  MultiQRReader({this.onChanged});
  @override
  State<StatefulWidget> createState() => _MultiQRReaderState();
}

class _MultiQRReaderState extends State<MultiQRReader> {
  final Set<String> fragments = {};
  @override
  Widget build(BuildContext context) {
    return ReaderWidget(onScan: _onScan);
  }

  _onScan(Code code) {
    final text = code.text;
    if (text == null) return;
    if (!fragments.contains(text)) {
      fragments.add(text);
      final res = WarpApi.mergeData(text);
      if (res.isNotEmpty) {
        final decoded = utf8.decode(ZLibCodec().decode(base64Decode(res)));
        widget.onChanged?.call(decoded);
      }
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
  final bool multi;
  ScanQRContext(this.onCode, {this.validator, this.multi = false});
}
