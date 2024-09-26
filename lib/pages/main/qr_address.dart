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
  final int? index;
  final void Function(String?)? onChanged;
  final void Function(int index, int mode)? onAddressModeChanged;
  final void Function()? onQRPressed;
  final int? amount;
  final String? memo;
  AddressCarousel(
      {super.key,
      this.index,
      this.amount,
      this.memo,
      this.onChanged,
      this.onAddressModeChanged,
      this.onQRPressed});

  @override
  State<StatefulWidget> createState() => AddressCarouselState();
}

class AddressCarouselState extends State<AddressCarousel> {
  late int? index = widget.index;
  final carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      aa.diversifiedAddress;

      if (aa.id == 0) return SizedBox.shrink();
      final theme = Theme.of(context);

      final accountAddress = warp.getAccountAddress(aa.coin, aa.id, 0, 7);
      final receivers = warp.decodeAddress(aa.coin, accountAddress);
      final accountMask = receivers.mask;

      final supportsUA = coins[aa.coin].supportsUA;
      final ua = coinSettings.uaType & accountMask;
      final addressAvailable = supportsUA
          ? [7 & ua, 8 | (6 & ua), 2, 4, 1] // main, div, sap, orch, trp
          : [2, 10, 1]; // pool masks, 15 = t|s|o|div
      List<Tuple3<int, Widget, String>> addressEnabled = [];
      for (var mask in addressAvailable) {
        final address = warp.getAccountAddress(aa.coin, aa.id, now(), mask);
        if (address.isNotEmpty) {
          final qr = QRAddressWidget(address, mask,
              amount: widget.amount,
              memo: widget.memo,
              onQRPressed: widget.onQRPressed);
          addressEnabled.add(Tuple3(mask, qr, qr.uri));
        }
      }
      // Remove duplicate masks
      final masks = addressEnabled.map((k) => k.item1).toSet();
      addressEnabled.retainWhere((k) => masks.remove(k.item1));
      if (index == null) {
        index = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onChanged?.call(addressEnabled.first.item3);
          widget.onAddressModeChanged?.call(0, addressEnabled.first.item1);
        });
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
                widget.onAddressModeChanged?.call(i, mask);
                widget.onChanged?.call(addressEnabled[i].item3);
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
  late final String uri;
  final void Function()? onQRPressed;

  QRAddressWidget(
    this.address,
    this.mask, {
    super.key,
    this.amount,
    this.memo,
    this.onQRPressed,
  }) {
    final a = amount ?? 0;
    if (a != 0 || memo.isNotEmptyAndNotNull) {
      final userMemo = UserMemoT(body: memo!);
      final recipient =
          RecipientT(address: address, pools: 7, amount: a, memo: userMemo);
      final payment = PaymentRequestExtension.empty()
        ..recipients!.add(recipient);
      uri = warp.makePaymentURI(aa.coin, payment);
    } else
      uri = address;
  }

  @override
  State<StatefulWidget> createState() => _QRAddressState();
}

class _QRAddressState extends State<QRAddressWidget> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final image = coins[aa.coin].image;

    return Column(children: [
      QrImage(
        data: widget.uri,
        version: QrVersions.auto,
        size: 200.0,
        backgroundColor: Colors.white,
        embeddedImage: image,
      ),
      Gap(8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(centerTrim(widget.uri)),
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
    Clipboard.setData(ClipboardData(text: widget.uri));
    showSnackBar(s.addressCopiedToClipboard);
  }

  qrCode() {
    widget.onQRPressed?.call();
  }
}
