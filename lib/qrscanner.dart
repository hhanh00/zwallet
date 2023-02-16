import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

import 'generated/l10n.dart';
import 'main.dart';

class QRScanner extends StatefulWidget {
  final dynamic Function(String) onScan;
  final bool Function()? completed;
  final bool multi;
  QRScanner(this.onScan, { this.completed, this.multi = false });

  @override
  State<StatefulWidget> createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(S.of(context).scanQrCode)),
    body: ReaderWidget(onScan: _onScan),
    floatingActionButton: (!widget.multi) ? FloatingActionButton(
      onPressed: _onPickImage,
      child: const Icon(Icons.image)
    ) : null);
  }

  _onScan(Code code) {
    final text = code.text;
    if (text != null)
      widget.onScan(text);
    final completed = widget.completed?.call() ?? true;
    if (completed)
      Navigator.of(context).pop();
  }

  _onPickImage() async {
    final code = await pickDecodeQRImage();
    if (code != null) {
      widget.onScan(code);
      Navigator.of(context).pop();
    }
  }
}

Future<String?> pickDecodeQRImage() async {
  final res = await pickFile();
  if (res != null && res.isSinglePick) {
    final file = res.files.first;
    final xfile = XFile(file.path!);
    final data = await xfile.readAsBytes();
    final image = img.decodeImage(data);
    if (image == null) return null;
    LuminanceSource source = RGBLuminanceSource(image.width, image.height,
        image.getBytes(format: img.Format.abgr).buffer.asInt32List());
    var bitmap = BinaryBitmap(HybridBinarizer(source));
    final reader = QRCodeReader();
    final result = reader.decode(bitmap);
    return result.text;
  }
  return null;
}

class QRDisplay extends StatelessWidget {
  final String label;
  final String value;
  QRDisplay(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final c = TextEditingController(text: value);
    return Row(children: [
      Expanded(child: TextFormField(decoration: InputDecoration(labelText: label), controller: c, readOnly: true)),
      IconButton(onPressed: () => _showQR(context), icon: Icon(Icons.qr_code))
    ]);
  }

  _showQR(BuildContext context) {
    showQR(context, value, label);
  }
}

class QRInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  QRInput(this.label, this.controller, { this.hint });

  @override
  State<StatefulWidget> createState() => QRInputState();
}

class QRInputState extends State<QRInput> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: TextFormField(decoration: InputDecoration(labelText: widget.label, hintText: widget.hint),
          minLines: 1,
          maxLines: 5,
          controller: widget.controller)),
      IconButton(onPressed: _scanQR, icon: Icon(Icons.qr_code))
    ]);
  }

  _scanQR() async {
    final code = await scanCode(context);
    if (code != null) {
      widget.controller.text = code;
    }
  }
}
