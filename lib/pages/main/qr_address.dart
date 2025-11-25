import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';

class AddressCarousel extends StatefulWidget {
  final void Function(int mode)? onAddressModeChanged;
  final int? amount;
  final String? memo;
  final bool paymentURI;
  AddressCarousel(
      {this.amount,
      this.memo,
      this.paymentURI = true,
      this.onAddressModeChanged});

  @override
  State<StatefulWidget> createState() => AddressCarouselState();
}

class AddressCarouselState extends State<AddressCarousel> {
  final int availableMode = WarpApi.getAvailableAddrs(aa.coin, aa.id);
  List<int> addressModes = [];
  List<Widget> addresses = [];
  int index = 0;
  final carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    updateAddresses();
  }

  void updateAddresses() {
    addresses.clear();
    addressModes.clear();

    final c = coins[aa.coin];
    for (var i = 0; i < 5; i++) {
      final am = (c.defaultAddrMode - i) % 5;
      if (am == 0 && !c.supportsUA) continue;
      if (am == c.defaultAddrMode ||
          am == 4 ||
          availableMode & (1 << (am - 1)) != 0) {
        final address = QRAddressWidget(
          am,
          uaType: coinSettings.uaType,
          amount: widget.amount,
          memo: widget.memo,
          paymentURI: widget.paymentURI,
        );
        addresses.add(address);
        addressModes.add(am);
      }
    }
  }

  @override
  void didUpdateWidget(AddressCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CarouselSlider(
          carouselController: carouselController,
          items: addresses,
          options: CarouselOptions(
            height: 280,
            viewportFraction: 1.0,
            onPageChanged: (i, reason) {
              widget.onAddressModeChanged?.call(addressModes[i]);
              setState(() => index = i);
            },
          ),
        ),
        Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: addresses
            .asMap().entries.map(
                (kv) => GestureDetector(
                  onTap: () {
                    carouselController.animateToPage(kv.key);
                  },
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primaryColor
                            .withOpacity(kv.key == index ? 0.9 : 0.4)),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class QRAddressWidget extends StatefulWidget {
  final int addressMode;
  final int? amount;
  final String? memo;
  final int uaType;
  final bool paymentURI;

  QRAddressWidget(
    this.addressMode, {
    super.key,
    required this.uaType,
    this.amount,
    this.memo,
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
    final image = coins[aa.coin].image;

    return Observer(builder: (context) {
      aa.diversifiedAddress;
      final uri = a != 0 || widget.memo?.isNotEmpty == true
          ? WarpApi.makePaymentURI(
              aa.coin, address, widget.amount!, widget.memo ?? '')
          : address;
      return Column(children: [
        QrImage(
          data: uri,
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
          embeddedImage: image,
        ),
        Gap(8),
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
        return s.mainAddress;
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
      final qrUri =
          Uri(path: '/showqr', queryParameters: {'title': widget.memo ?? ''});
      GoRouter.of(context).push(qrUri.toString(), extra: uri);
    }
  }
}
