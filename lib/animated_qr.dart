import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/intl/messages.dart';
import 'main.dart';

class AnimatedQR extends StatefulWidget {
  final String title;
  final String caption;
  final String data;
  final List<String> chunks;

  AnimatedQR.init(String title, String caption, String data):
      this(title, caption, data, WarpApi.splitData(DateTime.now().millisecondsSinceEpoch ~/ 1000,
          base64Encode(ZLibCodec().encode(utf8.encode(data)))));

  AnimatedQR(this.title, this.caption, this.data, this.chunks);

  @override
  AnimatedQRState createState() => AnimatedQRState();
}

class AnimatedQRState extends State<AnimatedQR> {
  var index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        index += 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final idx = index % widget.chunks.length;
    final qrSize = getScreenSize(context) / 1.2;
    return Scaffold(appBar: AppBar(title: Text(widget.title)),
      body: Padding(padding: EdgeInsets.all(16), child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImage(key: ValueKey(idx), data: widget.chunks[idx], size: qrSize, backgroundColor: Colors.white),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Text(widget.caption, style: theme.textTheme.titleMedium),
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

Future<String?> scanMultiCode(BuildContext context) async {
  if (!isMobile()) {
    showSnackBar(S.of(context).barcodeScannerIsNotAvailableOnDesktop);
    return null;
  }
  else {
    final player = AudioPlayer();
    final ding = AssetSource("ding.mp3");
    final f = Completer<String>();
    var completed = false;
    final Set<String> codes = Set();
    Navigator.of(context).pushNamed('/scanner', arguments: {
      'onScan': (String code) {
        Future(() => player.play(ding));
        if (!codes.contains(code)) {
          codes.add(code);
          final res = WarpApi.mergeData(code);
          completed = res.isNotEmpty;
          if (completed) {
            final decoded = utf8.decode(ZLibCodec().decode(base64Decode(res)));
            f.complete(decoded);
          }
        }
      },
      'completed': () => completed,
      'multi': true
    });
    return f.future;
  }
}
