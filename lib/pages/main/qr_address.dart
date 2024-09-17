import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';

class AddressCarousel extends StatefulWidget {
  final void Function(int mode)? onAddressModeChanged;
  final void Function()? onQRPressed;
  final int? amount;
  final String? memo;
  AddressCarousel(
      {this.amount, this.memo, this.onAddressModeChanged, this.onQRPressed});

  @override
  State<StatefulWidget> createState() => AddressCarouselState();
}

class AddressCarouselState extends State<AddressCarousel> {
  int index = 0;
  final carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      aa.diversifiedAddress;

      final theme = Theme.of(context);

      final supportsUA = coins[aa.coin].supportsUA;
      final ua = coinSettings.uaType;
      final addressAvailable = supportsUA
          ? [7 & ua, 8 | (6 & ua), 2, 4, 1] // main, div, sap, orch, trp
          : [2, 10, 1]; // pool masks, 15 = t|s|o|div
      List<Tuple2<int, Widget>> addressEnabled = [];
      for (var mask in addressAvailable) {
        final address = warp.getAccountAddress(aa.coin, aa.id, now(), mask);
        if (address.isNotEmpty) {
          final qr = QRAddressWidget(address, mask,
              amount: widget.amount,
              memo: widget.memo,
              onQRPressed: widget.onQRPressed);
          addressEnabled.add(Tuple2(mask, qr));
        }
      }

      final addresses = addressEnabled.map((a) => a.item2).toList();
      return Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            items: addresses,
            options: CarouselOptions(
              height: 280,
              viewportFraction: 1.0,
              onPageChanged: (i, reason) {
                final mask = addressEnabled[i].item1;
                widget.onAddressModeChanged?.call(mask);
                setState(() => index = i);
              },
            ),
          ),
          Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: addresses
                .mapIndexed(
                  (w, i) => GestureDetector(
                    onTap: () {
                      carouselController.animateToPage(i);
                    },
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor
                              .withOpacity(i == index ? 0.9 : 0.4)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}

class QRAddressWidget extends StatefulWidget {
  final String address;
  final int mask;
  final int? amount;
  final String? memo;
  final void Function()? onQRPressed;

  QRAddressWidget(
    this.address,
    this.mask, {
    super.key,
    this.amount,
    this.memo,
    this.onQRPressed,
  });

  @override
  State<StatefulWidget> createState() => _QRAddressState();
}

class _QRAddressState extends State<QRAddressWidget> {
  String uri = '';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final amount = widget.amount ?? 0;
    final image = coins[aa.coin].image;

    if (amount != 0 || widget.memo.isNotEmptyAndNotNull) {
      final memo = UserMemoT(body: widget.memo);
      final recipient =
          PaymentRequestT(address: widget.address, amount: amount, memo: memo);
      uri = warp.makePaymentURI(aa.coin, [recipient]);
    } else {
      uri = widget.address;
    }
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
  }

  String get addressType {
    final s = S.of(context);
    switch (widget.mask) {
      case 1:
        return s.transparent;
      case 2:
        return s.sapling;
      case 4:
        return s.orchard;
    }
    if (widget.mask & 8 != 0) return s.diversified;
    return s.mainAddress;
  }

  addressCopy() {
    final s = S.of(context);
    Clipboard.setData(ClipboardData(text: uri));
    showSnackBar(s.addressCopiedToClipboard);
  }

  qrCode() {
    widget.onQRPressed?.call();
  }
}
