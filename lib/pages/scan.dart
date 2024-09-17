import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../accounts.dart';
import '../generated/intl/messages.dart';
import 'utils.dart';

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
  var scanned = false;
  StreamSubscription<BarcodeCapture>? ss;

  @override
  void dispose() {
    ss?.cancel();
    ss = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.scanQrCode), actions: [
          if (isMobile()) IconButton(onPressed: _open, icon: Icon(Icons.open_in_new)),
          IconButton(onPressed: _ok, icon: Icon(Icons.check)),
        ]),
        body: FormBuilder(
            key: formKey,
            child: Column(children: [
              Expanded(
                child: MobileScanner(
                  onDetect: _onScan,
                ),
              ),
              Gap(16),
              FormBuilderTextField(
                  name: 'qr',
                  decoration: InputDecoration(label: Text(s.qr)),
                  controller: controller,
                  validator: widget.validator),
            ])));
  }

  _onScan(BarcodeCapture capture) {
    if (scanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final text = barcode.rawValue;
      if (text != null) {
        controller.text = text;
        final form = formKey.currentState!;
        if (form.validate()) {
          scanned = true;
          if (widget.onCode(text)) GoRouter.of(context).pop();
          return;
        }
      }
    }
  }

  _open() async {
    final file = await pickFile();
    logger.d('open');
    if (file != null) {
      final path = file.files[0].path!;
      final c = MobileScannerController();
      c.analyzeImage(path);
      ss = c.barcodes.listen(_onScan);
    }
  }

  _ok() {
    if (formKey.currentState!.validate()) {
      if (widget.onCode(controller.text)) GoRouter.of(context).pop();
    }
  }
}

class MultiQRReader extends StatefulWidget {
  final void Function(List<int>)? onChanged;
  MultiQRReader({this.onChanged});
  @override
  State<StatefulWidget> createState() => _MultiQRReaderState();
}

class _MultiQRReaderState extends State<MultiQRReader> {
  final Set<PacketT> packets = {};
  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(value: value, minHeight: 40),
        Expanded(
          child: MobileScanner(
            onDetect: _onScan,
          ),
        ),
      ],
    );
  }

  _onScan(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final text = barcode.rawValue;
      if (text == null) return;
      if (!packets.contains(text)) {
        final data = base64Decode(text);
        final packet = PacketT(data: data);
        packets.add(packet);
        final res = await warp.mergeData(aa.coin, packets.toList());
        final decoded = res.data;
        if (decoded != null) {
          widget.onChanged?.call(decoded);
        }
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
