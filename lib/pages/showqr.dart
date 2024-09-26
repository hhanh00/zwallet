import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../generated/intl/messages.dart';
import 'utils.dart';

class ShowQRPage extends StatelessWidget {
  final String title;
  final String text;
  ShowQRPage({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            showSnackBar(s.textCopiedToClipboard(title));
          },
          icon: Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () => saveQRImage(text, title),
          icon: Icon(Icons.save),
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final size = getScreenSize(context) * 0.8;
              return Align(
                  child: QrImage(
                      data: text, backgroundColor: Colors.white, size: size));
            }),
            const Gap(16),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}

Future<void> saveQRImage(String data, String? title) async {
  final code =
      QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.L);
  code.make();
  final painter =
      QrPainter.withQr(qr: code, emptyColor: Colors.white, gapless: true);
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final size = code.moduleCount * 32;
  final whitePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  canvas.drawRect(Rect.fromLTWH(0, 0, size + 256, size + 256), whitePaint);
  canvas.translate(128, 128);
  painter.paint(canvas, Size(size.toDouble(), size.toDouble()));
  final image = await recorder.endRecording().toImage(size + 256, size + 256);
  final ByteData? byteData =
      await image.toByteData(format: ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  await saveFileBinary(pngBytes, 'qr.png', title ?? '');
}
