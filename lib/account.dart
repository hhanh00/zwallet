import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp_api/warp_api.dart';

import 'generated/l10n.dart';
import 'main.dart';
import 'store.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child: Column(children: [
      SyncStatusWidget(),
      QRAddressWidget(),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      BalanceWidget(),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      MemPoolWidget(),
      ProgressWidget(),
    ]));
  }
}

class SyncStatusWidget extends StatefulWidget {
  SyncStatusState createState() => SyncStatusState();
}

class SyncStatusState extends State<SyncStatusWidget> {
  var display = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final simpleMode = settings.simpleMode;
    final syncStyle =
        theme.textTheme.bodySmall!.apply(color: theme.primaryColor);

    dynamic createText(String text, bool animated) {
      return animated
          ? WavyAnimatedText(text, textStyle: syncStyle)
          : Text(text, style: syncStyle);
    }

    return Column(children: [
      if (simpleMode)
        Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(s.simpleMode)),
      Observer(builder: (context) {
        final time = eta.eta;
        final neverSynced = syncStatus.syncedHeight == null;
        final syncedHeight = syncStatus.syncedHeight ?? 0;
        final startHeight = syncStatus.startSyncedHeight;
        final timestamp = syncStatus.timestamp?.timeAgo() ?? s.na;
        final latestHeight = syncStatus.latestHeight;
        final remaining = max(latestHeight - syncedHeight, 0);
        final int? percent;
        if (startHeight != null) {
          final total = latestHeight - startHeight;
          percent = total > 0 ? 100 * (syncedHeight - startHeight) ~/ total : 0;
        } else
          percent = 0;
        final downloadedSize =
            NumberFormat.compact().format(syncStatus.downloadedSize);
        final trialDecryptionCount =
            NumberFormat.compact().format(syncStatus.trialDecryptionCount);
        final disconnected = latestHeight == 0;
        final synced = syncStatus.isSynced();
        final paused = syncStatus.paused;
        final syncing = !paused && !disconnected && !neverSynced && !synced;

        dynamic createSyncText(int iDisplay, bool animated) {
          switch (iDisplay) {
            case 0:
              return createText('$syncedHeight / $latestHeight', animated);
            case 1:
              final m = syncStatus.isRescan ? "RESCAN" : "CATCH UP";
              return createText('$m $percent %', animated);
            case 2:
              return createText('$remaining...', animated);
            case 3:
              return createText('$timestamp', animated);
            case 4:
              return createText('$time', animated);
            case 5:
              return createText('\u{2193} $downloadedSize', animated);
            case 6:
              return createText('\u{2192} $trialDecryptionCount', animated);
          }
        }

        dynamic createSyncStatus() {
          var d = display % 8;
          if (d == 0)
            return AnimatedTextKit(
              key: ValueKey(syncedHeight),
              repeatForever: true,
              animatedTexts: [
                for (int i = 0; i < 7; i++) createSyncText(i, true)
              ],
              onTap: () => setState(() {
                display += 1;
              }),
            );
          return createSyncText(d - 1, false);
        }

        final text;
        if (paused)
          text = Text(s.syncPaused);
        else if (disconnected)
          text = Text(s.disconnected);
        else if (neverSynced)
          text = Text(s.rescanNeeded);
        else if (synced)
          text = Text('$syncedHeight', style: theme.textTheme.bodySmall);
        else
          text = createSyncStatus();

        return TextButton(
            onPressed: () {
              syncing ? _onNextDisplay() : _onSync(context);
            },
            child: text);
      })
    ]);
  }

  _onSync(BuildContext context) {
    if (syncStatus.paused)
      syncStatus.setPause(false);
    else if (syncStatus.syncedHeight != null)
      Future.microtask(() => syncStatus.sync(false));
    else
      rescan(context);
  }

  _onNextDisplay() {
    setState(() {
      display += 1;
    });
  }
}

class QRAddressWidget extends StatefulWidget {
  @override
  QRAddressState createState() => QRAddressState();
}

class QRAddressState extends State<QRAddressWidget> {
  bool _useSnapAddress = false;
  String _snapAddress = "";
  final addrsAvailable = WarpApi.getAvailableAddrs(active.coin, active.id);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final s = S.of(context);
      final theme = Theme.of(context);
      final _ = active.taddress;
      final simpleMode = settings.simpleMode;
      final address = _address();
      final shortAddress = centerTrim(address);
      final addrMode = active.addrMode;
      final qrSize = getScreenSize(context) / 2.5;
      final coinDef = active.coinDef;
      final nextMode = _getNextMode();
      final tapMessage = nextMode != addrMode ? _getTapMessage(nextMode) : null;

      return Column(children: [
        if (tapMessage != null) Text(tapMessage),
        Padding(padding: EdgeInsets.symmetric(vertical: 4)),
        GestureDetector(
            onTap: _onQRTap,
            onLongPress: _onUpdateTAddr,
            child: RotatedBox(
                quarterTurns: 0,
                child: QrImage(
                    data: address,
                    size: qrSize,
                    embeddedImage: coinDef.image,
                    backgroundColor: Colors.white))),
        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        RichText(
            text: TextSpan(children: [
          TextSpan(text: '$shortAddress ', style: theme.textTheme.bodyMedium),
          WidgetSpan(
              child: GestureDetector(
                  child: Icon(Icons.content_copy), onTap: _onAddressCopy)),
          WidgetSpan(
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 4))),
          WidgetSpan(
              child: GestureDetector(
                  child: Icon(MdiIcons.qrcodeScan), onTap: _onReceive)),
        ])),
        Padding(padding: EdgeInsets.symmetric(vertical: 4)),
        if (!simpleMode && addrMode != 2)
          SizedBox(
              height: 30,
              child: (_snapTimer == null)
                  ? OutlinedButton(
                      child: Text(s.newSnapAddress),
                      style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(width: 1, color: theme.primaryColor)),
                      onPressed: _onSnapAddress)
                  : LinearProgressIndicator(
                      value: _snapAddressProgress / SNAPADDRESS_LIFETIME)),
        if (!simpleMode && addrMode == 2 && hasShielded)
          SizedBox(
              height: 30,
              child: OutlinedButton(
                child: Text(s.shieldTranspBalance),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1, color: theme.primaryColor)),
                onPressed: () {
                  shieldTAddr(context);
                },
              ))
      ]);
    });
  }

  _onQRTap() {
    active.updateAddrMode(_getNextMode());
  }

  _onAddressCopy() {
    Clipboard.setData(ClipboardData(text: _address()));
    showSnackBar(S.of(context).addressCopiedToClipboard);
  }

  _onReceive() async {
    Navigator.of(context).pushNamed('/receive');
  }

  static const SNAPADDRESS_LIFETIME = 15;
  Timer? _snapTimer;
  int _snapAddressProgress = 0;

  _onSnapAddress() {
    if (_snapTimer != null) return;
    final uaType = active.addrMode == 0 ? 6 : 2; // S+O, S
    final address = active.getDiversifiedAddress(
      uaType,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    setState(() {
      _useSnapAddress = true;
      _snapAddress = address;
    });
    _snapAddressProgress = SNAPADDRESS_LIFETIME;
    final countdown = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _snapAddressProgress -= 1;
      });
    });
    _snapTimer = Timer(Duration(seconds: SNAPADDRESS_LIFETIME), () {
      setState(() {
        countdown.cancel();
        _useSnapAddress = false;
        _snapTimer = null;
      });
    });
  }

  _onUpdateTAddr() async {
    if (active.addrMode != 2) return;
    final s = S.of(context);
    final coinIndex = active.coinDef.coinIndex;
    var pathController = TextEditingController();
    var keyController = TextEditingController();
    final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(S.of(context).changeTransparentKey),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      decoration: InputDecoration(
                          label: Text(s.derivationPath),
                          hintText: "m/44'/$coinIndex'/0'/0/0"),
                      controller: pathController),
                  TextField(
                      decoration: InputDecoration(label: Text(s.privateKey)),
                      controller: keyController)
                ]),
                actions: confirmButtons(context, () {
                  Navigator.of(context).pop(true);
                }))) ??
        false;
    if (confirmed) {
      try {
        if (pathController.text.isNotEmpty)
          WarpApi.importTransparentPath(
              active.coin, active.id, pathController.text);
        if (keyController.text.isNotEmpty)
          WarpApi.importTransparentSecretKey(
              active.coin, active.id, keyController.text);
        await active.refreshTAddr();
        active.updateTBalance();
      } on String catch (message) {
        showSnackBar(message, error: true);
      }
    }
  }

  String _address() {
    switch (active.addrMode) {
      case 0:
        if (_useSnapAddress) return _snapAddress;
        return active.getAddress(settings.uaType);
      case 1:
        if (_useSnapAddress) return _snapAddress;
        return active.getAddress(2);
      default:
        return active.taddress;
    }
  }

  int _getNextMode() {
    int next = active.addrMode;
    do {
      next = (next + 1) % 3;
      switch (next) {
        case 0:
          return next;
        case 1: // we have orchard -> show zaddr
          if (addrsAvailable & 4 != 0) return next;
          break;
        case 2: // we have taddr -> show taddr
          if (addrsAvailable & 1 != 0) return next;
          break;
      }
    } while (next != active.addrMode);
    return 0; // unreachable
  }

  String? _getTapMessage(int mode) {
    final s = S.of(context);
    switch (mode) {
      case 0:
        return s.tapQrCodeForShieldedAddress;
      case 1:
        return s.tapQrCodeForSaplingAddress;
      case 2:
        return s.tapQrCodeForTransparentAddress;
    }
    return null;
  }

  bool get hasShielded => active.availabeAddrs & 6 != 0;
}

class BalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(builder: (context) {
        final s = S.of(context);
        final theme = Theme.of(context);
        final flat = settings.flat;
        final hide = () {
          switch (settings.autoHide) {
            case 0:
              return false;
            case 1:
              return flat;
            case 2:
              return true;
          }
          return true;
        }();
        final showTAddr = active.addrMode == 2;
        final balance = showTAddr ? active.tbalance : active.balances.balance;
        final balanceColor = !showTAddr
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary;
        final balanceHi = hide ? '-------' : _getBalanceHi(balance);
        final deviceWidth = getWidth(context);
        final digits = deviceWidth.index < DeviceWidth.sm.index ? 7 : 9;
        final balanceStyle = (balanceHi.length > digits
                ? theme.textTheme.headlineMedium
                : theme.textTheme.displayMedium)!
            .copyWith(color: balanceColor);

        final fx = priceStore.coinPrice;
        final balanceFX = balance * fx / ZECUNIT;
        final coinDef = active.coinDef;

        return Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: <Widget>[
                if (!hide)
                  Text('${coinDef.symbol}',
                      style: theme.textTheme.headlineSmall),
                Text(' $balanceHi', style: balanceStyle),
                if (!hide) Text('${_getBalanceLo(balance)}'),
              ]),
          SizedBox(
              height: 20,
              child: (hide && settings.autoHide == 1)
                  ? Text(s.tiltYourDeviceUpToRevealYourBalance)
                  : Container()),
          if (fx != 0.0)
            SizedBox(
                height: 30,
                child: hide
                    ? Container()
                    : Text(
                        "${decimalFormat(balanceFX, 2, symbol: settings.currency)}",
                        style: theme.textTheme.titleLarge)),
          if (fx != 0.0)
            Text(
                "1 ${coinDef.ticker} = ${decimalFormat(fx, 2, symbol: settings.currency)}"),
        ]);
      });
}

class MemPoolWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(builder: (context) {
        final theme = Theme.of(context);
        int unconfirmedBalance = unconfirmedBalanceStream.value ?? 0;
        final unconfirmedStyle =
            TextStyle(color: amountColor(context, unconfirmedBalance));
        if (unconfirmedBalance == 0) return Container();
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: <Widget>[
              Text(
                  '${_sign(unconfirmedBalance)} ${_getBalanceHi(unconfirmedBalance)}',
                  style:
                      theme.textTheme.headlineMedium?.merge(unconfirmedStyle)),
              Text('${_getBalanceLo(unconfirmedBalance)}',
                  style: unconfirmedStyle),
            ]);
      });
}

class ProgressWidget extends StatefulWidget {
  @override
  ProgressState createState() => ProgressState();
}

class ProgressState extends State<ProgressWidget> {
  int _progress = 0;
  StreamSubscription? _progressDispose;

  @override
  void initState() {
    super.initState();
    _progressDispose = progressStream.listen((percent) {
      setState(() {
        _progress = percent;
      });
    });
  }

  @override
  void dispose() {
    _progressDispose?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Observer(
        builder: (context) => Column(children: [
              if (active.banner.isNotEmpty)
                DefaultTextStyle(
                    style: theme.textTheme.titleLarge!,
                    child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                      TypewriterAnimatedText(active.banner)
                    ])),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              if (_progress != 0)
                LinearProgressIndicator(value: _progress / 100.0),
            ]));
  }
}

_getBalanceHi(int b) => decimalFormat((b.abs() ~/ 100000) / 1000.0, 3);

_getBalanceLo(int b) => (b.abs() % 100000).toString().padLeft(5, '0');

_sign(int b) => b < 0 ? '-' : '+';
