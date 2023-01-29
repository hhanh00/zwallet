import 'package:file_picker/file_picker.dart';
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
  QRScanner(this.onScan, { this.completed });

  @override
  State<StatefulWidget> createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(S.of(context).scanQrCode)),
    body: ReaderWidget(onScan: _onScan),
    floatingActionButton: (widget.completed != null) ? FloatingActionButton(
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
