import 'package:YWallet/appsettings.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../main.dart';

class QRAddressWidget extends StatefulWidget {
  final void Function(int)? onMode;

  QRAddressWidget({this.onMode});

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
    print('_QRAddressState::BUILD');
    final uaType;
    switch (addressMode) {
      case 0:
        uaType = appSettings.uaType;
        break;
      default:
        uaType = 1 << (addressMode - 1);
        break;
    }
    final address = WarpApi.getAddress(aa.coin, aa.id, uaType);

    return Column(
      children: [
        GestureDetector(
          onTap: _nextAddressMode,
          child: QrImage(
            data: address,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(centerTrim(address)),
          Padding(padding: EdgeInsets.all(4)),
          IconButton.outlined(onPressed: _addressCopy, icon: Icon(Icons.copy)),
          Padding(padding: EdgeInsets.all(4)),
          IconButton.outlined(onPressed: _qrCode, icon: Icon(Icons.qr_code)),
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

  _addressCopy() {}
  _qrCode() {}
}
