import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../main.dart';

class QRAddressWidget extends StatefulWidget {
  final int? amount;
  final String? memo;
  final int uaType;
  final void Function(int)? onMode;
  final bool paymentURI;

  QRAddressWidget({
    required this.uaType,
    this.amount,
    this.memo,
    this.onMode,
    this.paymentURI = true,
  });

  @override
  State<StatefulWidget> createState() => _QRAddressState();
}

class _QRAddressState extends State<QRAddressWidget> {
  int addressMode = 0;
  late int availableMode;

  @override
  void initState() {
    super.initState();
    availableMode = WarpApi.getAvailableAddrs(aa.coin, aa.id);
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.amount ?? 0;
    final uri = 
      a != 0 ? WarpApi.makePaymentURI(aa.coin, address, widget.amount!, widget.memo ?? '')
      : address;

    return Column(children: [
      GestureDetector(
        onTap: _nextAddressMode,
        child: QrImage(
          data: uri,
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
        ),
      ),
      Padding(padding: EdgeInsets.all(8)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(centerTrim(uri)),
        Padding(padding: EdgeInsets.all(4)),
        IconButton.outlined(onPressed: addressCopy, icon: Icon(Icons.copy)),
        Padding(padding: EdgeInsets.all(4)),
        if (widget.paymentURI)
          IconButton.outlined(onPressed: qrCode, icon: Icon(Icons.qr_code)),
      ]),
    ]);
  }

  _nextAddressMode() {
    while (true) {
      addressMode = (addressMode - 1) % 4;
      if (addressMode == 0) break;
      if (availableMode & (1 << (addressMode - 1)) != 0) break;
    }
    widget.onMode?.call(addressMode);
    setState(() {});
  }

  String get address {
    final uaType;
    switch (addressMode) {
      case 0:
        uaType = widget.uaType;
        break;
      default:
        uaType = 1 << (addressMode - 1);
        break;
    }
    return WarpApi.getAddress(aa.coin, aa.id, uaType);
  }

  String get uri {
    final a = widget.amount ?? 0;
    final uri = 
      a != 0 ? WarpApi.makePaymentURI(aa.coin, address, widget.amount!, widget.memo ?? '')
      : address;
    return uri;
  }

  addressCopy() {
    Clipboard.setData(ClipboardData(text: uri));
  }

  qrCode() {
    GoRouter.of(context).push('/account/pay_uri');
  }
}
