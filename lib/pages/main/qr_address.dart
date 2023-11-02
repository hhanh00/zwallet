import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';

class QRAddressWidget extends StatefulWidget {
  final int? amount;
  final String? memo;
  final int uaType;
  final void Function(int)? onMode;
  final bool paymentURI;

  QRAddressWidget({
    super.key,
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
    addressMode = coins[aa.coin].defaultAddrMode;
    availableMode = WarpApi.getAvailableAddrs(aa.coin, aa.id);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final a = widget.amount ?? 0;

    return Observer(builder: (context) {
      aa.diversifiedAddress;
      final uri = a != 0
          ? WarpApi.makePaymentURI(
              aa.coin, address, widget.amount!, widget.memo ?? '')
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(centerTrim(uri)),
            Padding(padding: EdgeInsets.all(4)),
            IconButton.outlined(onPressed: addressCopy, icon: Icon(Icons.copy)),
            Padding(padding: EdgeInsets.all(4)),
            if (widget.paymentURI)
              IconButton.outlined(onPressed: qrCode, icon: Icon(Icons.qr_code)),
          ],
        ),
        Text(addressType, style: t.textTheme.labelSmall)
      ]);
    });
  }

  // Addr Modes
  // 0: As chosen in settings
  // 1: T
  // 2: S
  // 3: O
  _nextAddressMode() {
    final c = coins[aa.coin];
    while (true) {
      addressMode = (addressMode - 1) % 5;
      if (addressMode == 0 && !c.supportsUA) continue;
      if (addressMode == c.defaultAddrMode) break;
      if (addressMode == 4) break; // diversified address
      if (availableMode & (1 << (addressMode - 1)) != 0) break;
    }
    widget.onMode?.call(addressMode);
    setState(() {});
  }

  String get addressType {
    final s = S.of(context);
    switch (addressMode) {
      case 1:
        return s.transparent;
      case 2:
        return s.sapling;
      case 3:
        return s.orchard;
      case 4:
        return s.diversified;
      default:
        return s.ua;
    }
  }

  String get address {
    final uaType;
    switch (addressMode) {
      case 0:
        uaType = widget.uaType;
        break;
      case 4:
        return aa.diversifiedAddress;
      default:
        uaType = 1 << (addressMode - 1);
        break;
    }
    return WarpApi.getAddress(aa.coin, aa.id, uaType);
  }

  String get uri {
    final a = widget.amount ?? 0;
    final uri = a != 0
        ? WarpApi.makePaymentURI(
            aa.coin, address, widget.amount!, widget.memo ?? '')
        : address;
    return uri;
  }

  addressCopy() {
    final s = S.of(context);
    Clipboard.setData(ClipboardData(text: uri));
    showSnackBar(s.addressCopiedToClipboard);
  }

  qrCode() {
    GoRouter.of(context).push('/account/pay_uri');
  }
}
