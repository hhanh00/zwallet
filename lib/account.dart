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

class _AccountState extends State<AccountPage> with AutomaticKeepAliveClientMixin {
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
          ])
        );
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
    final syncStyle = theme.textTheme.caption!.apply(color: theme.primaryColor);

    dynamic createText(String text, bool animated) {
      return animated ? WavyAnimatedText(text, textStyle: syncStyle) : Text(text, style: syncStyle);
    }

    return Column(children: [
      if (simpleMode) Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0), child: Text(s.simpleMode)),
      Observer(builder: (context) {
        final time = eta.eta;
        final neverSynced = syncStatus.syncedHeight == null;
        final syncedHeight = syncStatus.syncedHeight ?? 0;
        final startHeight = syncStatus.startSyncedHeight;
        final timestamp = syncStatus.timestamp?.timeAgo() ?? s.na;
        final latestHeight = syncStatus.latestHeight;
        final remaining = max(latestHeight-syncedHeight, 0);
        final int? percent;
        if (startHeight != null) {
          final total = latestHeight - startHeight;
          percent = total > 0 ? 100 * (syncedHeight - startHeight) ~/
              total : 0;
        }
        else percent = 0;
        final downloadedSize = NumberFormat.compact().format(syncStatus.downloadedSize);
        final trialDecryptionCount = NumberFormat.compact().format(syncStatus.trialDecryptionCount);
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
                animatedTexts: [ for (int i = 0; i < 7; i++) createSyncText(i, true) ],
                onTap: () => setState(() { display += 1; }),
            );
          return createSyncText(d-1, false);
        }

        final text;
        if (paused)
          text = Text(s.syncPaused);
        else if (disconnected)
          text = Text(s.disconnected);
        else if (neverSynced)
          text = Text(s.rescanNeeded);
        else if (synced)
          text = Text('$syncedHeight', style: theme.textTheme.caption);
        else
          text = createSyncStatus();

        return TextButton(onPressed: () { syncing ? _onNextDisplay() : _onSync(context); }, child: text);
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
    setState(() { display += 1; });
  }
}

class QRAddressWidget extends StatefulWidget {
  @override
  QRAddressState createState() => QRAddressState();
}

class QRAddressState extends State<QRAddressWidget> {
  bool _useSnapAddress = false;
  String _snapAddress = "";

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final s = S.of(context);
      final theme = Theme.of(context);
      final _ = active.taddress;
      final simpleMode = settings.simpleMode;
      final address = _address();
      final shortAddress = centerTrim(address);
      final showTAddr = active.showTAddr;
      final hasTAddr = active.taddress.isNotEmpty;
      final flat = settings.flat;
      final qrSize = getScreenSize(context) / 2.5;
      final hide = settings.autoHide && flat;
      final coinDef = active.coinDef;

      return Column(children: [
        if (hasTAddr)
          Text(showTAddr
              ? s.tapQrCodeForShieldedAddress
              : s.tapQrCodeForTransparentAddress),
        Padding(padding: EdgeInsets.symmetric(vertical: 4)),
        GestureDetector(
            onTap: hasTAddr ? _onQRTap : null,
            onLongPress: _onUpdateTAddr,
            child: RotatedBox(
                quarterTurns: hide ? 2 : 0,
                child: QrImage(
                    data: address,
                    size: qrSize,
                    embeddedImage: coinDef.image,
                    backgroundColor: Colors.white))),
        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        RichText(
            text: TextSpan(children: [
          TextSpan(text: '$shortAddress ', style: theme.textTheme.bodyText2),
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
        if (!simpleMode && !showTAddr)
          OutlinedButton(
              child: Text(s.newSnapAddress),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: theme.primaryColor)),
              onPressed: _onSnapAddress),
        if (!simpleMode && showTAddr)
          OutlinedButton(
            child: Text(s.shieldTranspBalance),
            style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1, color: theme.primaryColor)),
            onPressed: () {
              shieldTAddr(context);
            },
          )
      ]);
    });
  }

  _onQRTap() {
    active.toggleShowTAddr();
  }

  _onAddressCopy() {
    Clipboard.setData(ClipboardData(text: _address()));
    showSnackBar(S.of(context).addressCopiedToClipboard);
  }

  _onReceive() async {
    Navigator.of(context).pushNamed('/receive', arguments: _address());
  }

  _onSnapAddress() {
    final address = active.newAddress();
    setState(() {
      _useSnapAddress = true;
      _snapAddress = address;
    });
    Timer(Duration(seconds: 15), () {
      setState(() {
        _useSnapAddress = false;
      });
    });
  }

  _onUpdateTAddr() async {
    if (!active.showTAddr) return;
    final s = S.of(context);
    final coinIndex = active.coinDef.coinIndex;
    var pathController = TextEditingController();
    var keyController = TextEditingController();
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
        title: Text(S.of(context).changeTransparentKey),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                decoration: InputDecoration(label: Text(s.derivationPath), hintText: "m/44'/${coinIndex}'/0'/0/0"),
                controller: pathController),
            TextField(
                decoration: InputDecoration(label: Text(s.privateKey)),
                controller: keyController)]),
        actions: confirmButtons(context, () {
          Navigator.of(context).pop(true);
        }))) ?? false;
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
      }
      on String catch (message) {
        showSnackBar(message);
      }
    }
  }

  String _address() {
    final address = active.showTAddr
        ? active.taddress
        : _useSnapAddress
            ? _snapAddress
            : active.account.address;
    return address;
  }
}

class BalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(builder: (context) {
        final s = S.of(context);
        final theme = Theme.of(context);
        final flat = settings.flat;
        final hide = settings.autoHide && flat;
        final showTAddr = active.showTAddr;
        final balance = showTAddr ? active.tbalance : active.balances?.balance ?? 0;
        final balanceColor = !showTAddr
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary;
        final balanceHi = hide ? '-------' : _getBalanceHi(balance);
        final deviceWidth = getWidth(context);
        final digits = deviceWidth.index < DeviceWidth.sm.index ? 7 : 9;
        final balanceStyle = (balanceHi.length > digits
                ? theme.textTheme.headline4
                : theme.textTheme.headline2)!
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
                  Text('${coinDef.symbol}', style: theme.textTheme.headline5),
                Text(' $balanceHi', style: balanceStyle),
                if (!hide) Text('${_getBalanceLo(balance)}'),
              ]),
          if (hide) Text(s.tiltYourDeviceUpToRevealYourBalance),
          if (!hide && fx != 0.0)
            Text("${decimalFormat(balanceFX, 2, symbol: settings.currency)}",
                style: theme.textTheme.headline6),
          if (!hide && fx != 0.0)
            Text(
                "1 ${coinDef.ticker} = ${decimalFormat(
                    fx, 2, symbol: settings.currency)}"),
        ]);
  });
}

class MemPoolWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(builder: (context) {
    final b = active.balances;
    final theme = Theme.of(context);
    final unconfirmedBalance = b?.unconfirmedBalance ?? 0;
    if (unconfirmedBalance == 0) return Container();
    final unconfirmedStyle = TextStyle(
        color: amountColor(context, unconfirmedBalance));

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: <Widget>[
          Text(
              '${_sign(unconfirmedBalance)} ${_getBalanceHi(unconfirmedBalance)}',
              style: theme.textTheme.headline4
                  ?.merge(unconfirmedStyle)),
          Text(
              '${_getBalanceLo(unconfirmedBalance)}',
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

    return Observer(builder: (context) => Column(children: [
      if (active.banner.isNotEmpty) DefaultTextStyle(
        style: theme.textTheme.titleLarge!,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText(active.banner)]
      )),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      if (_progress != 0) LinearProgressIndicator(value: _progress / 100.0),
    ]));
  }
}

_getBalanceHi(int b) => decimalFormat((b.abs() ~/ 100000) / 1000.0, 3);

_getBalanceLo(int b) => (b.abs() % 100000).toString().padLeft(5, '0');

_sign(int b) => b < 0 ? '-' : '+';
