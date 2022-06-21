import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/l10n.dart';
import 'main.dart';

class AnimatedQR extends StatefulWidget {
  final String title;
  final String caption;
  final String data;
  final List<String> chunks;

  AnimatedQR.init(String title, String caption, String data):
      this(title, caption, data, WarpApi.splitData(DateTime.now().millisecondsSinceEpoch ~/ 1000, base64Encode(utf8.encode(data))));

  AnimatedQR(this.title, this.caption, this.data, this.chunks);

  @override
  AnimatedQRState createState() => AnimatedQRState();
}

class AnimatedQRState extends State<AnimatedQR> {
  var index = 0;
  Timer? _timer;

  @override
  void initState() {
    _timer = new Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        index += 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final idx = index % widget.chunks.length;
    final qrSize = getScreenSize(context) / 1.2;
    print(qrSize);
    return Scaffold(appBar: AppBar(title: Text(widget.title)),
      body: Padding(padding: EdgeInsets.all(16), child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImage(key: ValueKey(idx), data: widget.chunks[idx], size: qrSize, foregroundColor: Colors.white, backgroundColor: Colors.black),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Text(widget.caption, style: theme.textTheme.subtitle1),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          ElevatedButton.icon(
            icon: Icon(Icons.close),
            label: Text(S.of(context).ok),
            onPressed: () { Navigator.of(context).pop(); }
          )
        ]
      )
    )));
  }
}

class QrOffline extends StatelessWidget {
  final String txJson;

  QrOffline(this.txJson);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AnimatedQR.init(s.unsignedTx, s.signOnYourOfflineDevice, txJson);
  }
}

class ShowRawTx extends StatelessWidget {
  final String rawTx;

  ShowRawTx(this.rawTx);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AnimatedQR.init(s.signedTx, s.broadcastFromYourOnlineDevice, rawTx);
  }
}

