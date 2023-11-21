import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';

class QRAddressWidget extends StatefulWidget {
  final int addressMode;
  final int? amount;
  final String? memo;
  final int uaType;
  final void Function()? onMode;
  final bool paymentURI;

  QRAddressWidget(this.addressMode, {
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
          onTap: widget.onMode,
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
            IconButton.outlined(onPressed: qrCode, icon: Icon(Icons.qr_code)),
          ],
        ),
        Text(addressType, style: t.textTheme.labelSmall)
      ]);
    });
  }

  String get addressType {
    final s = S.of(context);
    switch (widget.addressMode) {
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
    if (aa.id == 0) return '';
    final uaType;
    switch (widget.addressMode) {
      case 0:
        uaType = widget.uaType;
        break;
      case 4:
        return aa.diversifiedAddress;
      default:
        uaType = 1 << (widget.addressMode - 1);
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
    if (widget.paymentURI)
      GoRouter.of(context).push('/account/pay_uri');
    else {
      final qrUri = Uri(
        path: '/showqr',
        queryParameters: {'title': widget.memo ?? ''});
      GoRouter.of(context).push(qrUri.toString(), extra: uri);
    }
  }
}
