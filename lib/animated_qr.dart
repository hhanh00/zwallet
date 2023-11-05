import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/intl/messages.dart';
import 'main.dart';
import 'pages/widgets.dart';

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
