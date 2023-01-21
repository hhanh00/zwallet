import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:cross_file/cross_file.dart';

import 'generated/l10n.dart';

class QRScanner extends StatefulWidget {
  final dynamic Function(Code) onScan;
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
    widget.onScan(code);
    final completed = widget.completed?.call() ?? true;
    if (completed)
      Navigator.of(context).pop();
  }

  _onPickImage() async {
    final res = await FilePicker.platform.pickFiles();
    if (res != null && res.isSinglePick) {
      final file = res.files.first;
      final xfile = XFile(file.path!);
      final Code? result = await zx.readBarcodeImagePath(xfile);
      if (result != null && result.isValid)
        _onScan(result);
    }
  }
}
