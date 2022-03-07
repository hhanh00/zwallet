import 'dart:convert';
import 'dart:isolate';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp/store.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/l10n.dart';
import 'package:convert/convert.dart';

import 'main.dart';

const PORT = 4000;

class MultisigAggregatorPage extends StatefulWidget {
  final TxSummary txSummary;

  MultisigAggregatorPage(this.txSummary);

  @override
  MultisigAggregatorState createState() => MultisigAggregatorState();
}

class MultisigAggregatorState extends State<MultisigAggregatorPage> {
  String _wifiIP = '';
  ShareInfo? _shareInfo;
  int _peerCount = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var peerPort = ReceivePort();
      var peerStream = peerPort.asBroadcastStream();
      peerStream.listen((_) {
        print("Received a new peer");
        _peerCount += 1;
      });

      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP() ?? '';
      final shareInfo = await accountManager.getShareInfo(accountManager.active.id);
      _runAggregator(peerPort.sendPort);
      setState(() {
        _wifiIP = wifiIP;
        _shareInfo = shareInfo;
      });
    });
  }

  @override
  void dispose() {
    _stopAggregator();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrSize = getScreenSize(context) / 2.5;
    final shareInfo = _shareInfo;
    return Scaffold(
            appBar: AppBar(
              title: Text('Sign Multisig Transaction'),
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  QrImage(
                      data: txSummaryString,
                      size: qrSize,
                      backgroundColor: Colors.white),
                  Padding(padding: EdgeInsets.all(8)),
                  Text('Scan this code on your other devices'),
                ]),
                if (shareInfo != null)
                  SignerPie(qrSize.toInt(), _peerCount + 1,
                      shareInfo.threshold, shareInfo.participants),
              ],
        )));
  }

  void _runAggregator(SendPort port) async {
    final s = S.of(context);
    await WarpApi.runAggregator(accountManager.active.share!.value, PORT, port);
    // Need to wait a bit for the service to spin up
    await Future.delayed(Duration(seconds: 3));
    final tx = await WarpApi.submitTx(widget.txSummary.txJson, PORT);
    SnackBar snackBar;
    if (tx.startsWith("00")) { // first byte is success/error
      final txId = WarpApi.broadcastHex(accountManager.coin, tx.substring(2));
      snackBar = SnackBar(content: Text("${s.txId}: $txId"));
    }
    else {
      final msgHex = tx.substring(2);
      final s = hex.decode(msgHex);
      final dec = Utf8Decoder();
      final msg = dec.convert(s);
      snackBar = SnackBar(content: Text(msg));
    }
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    Navigator.of(context).pop();
  }

  void _stopAggregator() {
    WarpApi.stopAggregator();
  }

  String get txSummaryString =>
      "http://$_wifiIP:$PORT|${widget.txSummary.address}|${widget.txSummary.amount}";
}

class SignerPie extends StatelessWidget {
  final int size;
  final int available;
  final int threshold;
  final int participants;

  SignerPie(this.size, this.available, this.threshold, this.participants);

  @override
  Widget build(BuildContext context) {
    final remaining = threshold - available;
    return Column(children: [
      SizedBox(
          width: 150,
          height: 150,
          child: PieChart(PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 0,
              startDegreeOffset: -90,
              sections: showingSections()))),
      Text(S.of(context).numMoreSignersNeeded(remaining)),
    ]);
  }

  List<PieChartSectionData> showingSections() {
    final value = 100 / participants;
    final size = this.size / 3;
    return List.generate(
      participants,
      (i) {
        if (i < available) {
          return PieChartSectionData(
              color: Colors.green, title: '', value: value, radius: size);
        } else if (i < threshold) {
          return PieChartSectionData(
              color: Colors.red, title: '', value: value, radius: size);
        }
        return PieChartSectionData(
            color: Colors.green, title: '', value: value, radius: size);
      },
    );
  }
}

const SIGNER_PORT = 4001;

class MultisigPage extends StatefulWidget {
  @override
  MultisigState createState() => MultisigState();
}

class MultisigState extends State<MultisigPage> {
  String _aggregatorUrl = "";
  String _address = "";
  int _amount = 0;
  final _formKey = GlobalKey<FormState>();
  int _participants = 2;
  int _threshold = 2;

  @override
  Widget build(BuildContext context) {
    final canMultisign = accountManager.active.share != null;
    return Scaffold(
        appBar: AppBar(title: Text(S.of(context).multisig)),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  if (canMultisign) Card(
                      elevation: 1,
                      child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                              child: ElevatedButton.icon(
                                  onPressed: _scan,
                                  icon: Icon(MdiIcons.signatureFreehand),
                                  label: Text(S.of(context).sign))))),
                  if (accountManager.canPay) Card(
                      elevation: 1,
                      child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Column(children: [
                              Text('Number of Participants'),
                              Slider(min: 2, max: 10, divisions: 8, onChanged: _onChangedParticipants, value: _participants.toDouble()),
                              Padding(padding: EdgeInsets.all(4)),
                              Text('Threshold (Number of Signers Required)'),
                              Slider(min: 2, max: 10, divisions: 8, onChanged: _onChangedThreshold, value: _threshold.toDouble()),
                              Padding(padding: EdgeInsets.all(8)),
                              Text('$_threshold / $_participants', style: Theme.of(context).textTheme.headline5),
                              Padding(padding: EdgeInsets.all(8)),
                              ElevatedButton.icon(onPressed: _split, icon: Icon(MdiIcons.rhombusSplit), label: Text(S.of(context).splitAccount))
                            ])
                          )))
                ]))));
  }

  _onChangedParticipants(v) {
    setState(() {
      _participants = v.toInt();
      if (_threshold > _participants)
        _threshold = _participants;
    });
  }

  _onChangedThreshold(v) {
    setState(() {
      _threshold = v.toInt();
      if (_threshold > _participants)
        _threshold = _participants;
    });
  }

  _scan() async {
    final s = S.of(context);
    final txSummaryString = await scanCode(context);
    if (txSummaryString == null) return;
    final txParts = txSummaryString.split('|');
    _aggregatorUrl = txParts[0];
    _address = txParts[1];
    if (_address == '*')
      _address = s.multipleAddresses;
    _amount = int.parse(txParts[2]);
    final amount = amountToString(_amount);
    final approved = await showMessageBox(
        context,
        s.confirmSigning,
        s.confirmSignATransactionToAddressFor(_address, amount),
        s.approve);
    if (approved) await sign(txParts[1], _amount);
  }

  _split() async {
    final s = S.of(context);
    final shareString = WarpApi.splitAccount(accountManager.coin, _threshold, _participants, accountManager.active.id);
    Navigator.of(context).pushNamed('/multisig_shares', arguments: shareString);
  }

  sign(String address, int amount) async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    final myUrl = 'http://$wifiIP:$SIGNER_PORT';

    final share = accountManager.active.share;
    if (share != null && _aggregatorUrl != null) {
      final errorCode = await WarpApi.runMultiSigner(
        address, amount,
          share.value, _aggregatorUrl, myUrl, SIGNER_PORT);
      String? msg;
      switch (errorCode) {
        case 0:
          msg = "Transaction signed";
          break;
        case 1:
          msg = "Duplicate signer";
          break;
      }
      if (msg != null) {
        final snackBar = SnackBar(content: Text(msg));
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
    }
    Navigator.of(context).pop();
  }
}

class MultisigSharesPage extends StatelessWidget {
  final String shareString;
  MultisigSharesPage(this.shareString);

  @override
  Widget build(BuildContext context) {
    final shares = shareString.split('|').asMap().entries.toList();
    final account = accountManager.active;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).multisigShares)),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: ListTile.divideTiles(context: context, tiles: [
          for (var share in shares)
            ListTile(title: Text(share.value), trailing: Icon(MdiIcons.qrcode),
            onTap: () => showQR(context, share.value, "${account.name} - ms ${share.key+1}/${shares.length}"))
      ]).toList())
    );
  }
}
