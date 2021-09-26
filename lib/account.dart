import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:warp/payment_uri.dart';
import 'package:warp/store.dart';
import 'package:warp_api/warp_api.dart';

import 'about.dart';
import 'budget.dart';
import 'chart.dart';
import 'contact.dart';
import 'history.dart';
import 'main.dart';
import 'generated/l10n.dart';
import 'note.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  Timer? _timerSync;
  int _progress = 0;
  bool _useSnapAddress = false;
  String _snapAddress = "";
  late TabController _tabController;
  bool _accountTab = true;
  bool _contactsTab = false;
  StreamSubscription? _progressDispose;
  StreamSubscription? _syncDispose;
  StreamSubscription? _accDispose;
  final contactKey = GlobalKey<ContactsState>();
  bool _flat = false;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _accountTab = _tabController.index == 0;
        _contactsTab = _tabController.index == 5;
      });
    });
    Future.microtask(() async {
      await accountManager.updateUnconfirmedBalance();
      await accountManager.fetchAccountData(false);
      await contacts.fetchContacts();
      await _setupTimer();
    });
    WidgetsBinding.instance?.addObserver(this);
    _progressDispose = progressStream.listen((percent) {
      setState(() {
        _progress = percent;
      });
    });
    _syncDispose = syncStream.listen((height) {
      setState(() {
        if (height >= 0) {
          syncStatus.setSyncHeight(height);
          eta.checkpoint(height, DateTime.now());
        } else {
          WarpApi.mempoolReset(syncStatus.latestHeight);
          _trySync();
        }
      });
    });
    _accDispose = accelerometerEvents.listen(_handleAccel);
  }

  @override
  void dispose() {
    _timerSync?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    _progressDispose?.cancel();
    _syncDispose?.cancel();
    _accDispose?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _timerSync?.cancel();
        _timerSync = null;
        _accDispose?.cancel();
        _accDispose = null;
        break;
      case AppLifecycleState.resumed:
        if (_timerSync == null) _setupTimer();
        if (_accDispose == null)
          _accDispose = accelerometerEvents.listen(_handleAccel);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!syncStatus.isSynced() && !syncStatus.syncing) _trySync();
    if (accountManager.active == null) return CircularProgressIndicator();
    final theme = Theme.of(this.context);
    final hasTAddr = accountManager.taddress.isNotEmpty;
    final qrSize = getScreenSize(context) / 2.5;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Observer(
            builder: (context) => Text("${accountManager.active.name}")),
        bottom: TabBar(controller: _tabController, isScrollable: true, tabs: [
          Tab(text: S.of(context).account),
          Tab(text: S.of(context).notes),
          Tab(text: S.of(context).history),
          Tab(text: S.of(context).budget),
          Tab(text: S.of(context).tradingPl),
          Tab(text: S.of(context).contacts),
        ]),
        actions: [
          Observer(builder: (context) {
            accountManager.canPay;
            return PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: Text(S.of(context).accounts), value: "Accounts"),
                PopupMenuItem(
                    child: Text(S.of(context).backup), value: "Backup"),
                PopupMenuItem(
                    child: Text(S.of(context).rescan), value: "Rescan"),
                if (accountManager.canPay)
                  PopupMenuItem(
                      child: Text(S.of(context).coldStorage), value: "Cold"),
                if (accountManager.canPay)
                  PopupMenuItem(
                      child: Text(S.of(context).multipay), value: "MultiPay"),
                PopupMenuItem(
                    child: Text(S.of(context).broadcast), value: "Broadcast"),
                PopupMenuItem(
                    child: Text(S.of(context).settings), value: "Settings"),
                PopupMenuItem(child: Text(S.of(context).about), value: "About"),
              ],
              onSelected: _onMenu,
            );
          })
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(children: [
              Observer(builder: (context) {
                final _1 = eta.eta;
                final _2 = syncStatus.syncedHeight;
                final _3 = syncStatus.latestHeight;
                return syncStatus.syncedHeight < 0
                    ? Text("")
                    : syncStatus.isSynced()
                        ? Text('${syncStatus.syncedHeight}',
                            style: theme.textTheme.caption)
                        : Text(
                            '${syncStatus.syncedHeight} / ${syncStatus.latestHeight} ${eta.eta}',
                            style: theme.textTheme.caption!
                                .apply(color: theme.primaryColor));
              }),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Observer(builder: (context) {
                final _ = accountManager.active.address;
                final address = _address();
                final shortAddress = addressLeftTrim(address);
                final showTAddr = accountManager.showTAddr;
                final hide = settings.autoHide && _flat;
                return Column(children: [
                  if (hasTAddr)
                    Text(showTAddr
                        ? S.of(context).tapQrCodeForShieldedAddress
                        : S.of(context).tapQrCodeForTransparentAddress),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                      onTap: hasTAddr ? _onQRTap : null,
                      child: RotatedBox(
                          quarterTurns: hide ? 2 : 0,
                          child: QrImage(
                              data: address,
                              size: qrSize,
                              embeddedImage: AssetImage('assets/icon.png'),
                              backgroundColor: Colors.white))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '$shortAddress ',
                        style: theme.textTheme.bodyText2),
                    WidgetSpan(
                        child: GestureDetector(
                            child: Icon(Icons.content_copy),
                            onTap: _onAddressCopy)),
                    WidgetSpan(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4))),
                    WidgetSpan(
                        child: GestureDetector(
                            child: Icon(MdiIcons.qrcodeScan),
                            onTap: _onReceive)),
                  ])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  if (!showTAddr)
                    OutlinedButton(
                        child: Text(S.of(context).newSnapAddress),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1, color: theme.primaryColor)),
                        onPressed: _onSnapAddress),
                  if (showTAddr)
                    OutlinedButton(
                      child: Text(S.of(context).shieldTranspBalance),
                      style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(width: 1, color: theme.primaryColor)),
                      onPressed: _onShieldTAddr,
                    )
                ]);
              }),
              Observer(builder: (context) {
                final showTAddr = accountManager.showTAddr;
                final balance = showTAddr
                    ? accountManager.tbalance
                    : accountManager.balance;
                final hide = settings.autoHide && _flat;
                final balanceColor = !showTAddr
                    ? theme.colorScheme.primaryVariant
                    : theme.colorScheme.secondaryVariant;
                final balanceHi = hide ? '-------' : _getBalance_hi(balance);
                final deviceWidth = getWidth(context);
                final digits = deviceWidth.index < DeviceWidth.sm.index ? 7 : 9;
                final balanceStyle = (balanceHi.length > digits
                        ? theme.textTheme.headline4
                        : theme.textTheme.headline2)!
                    .copyWith(color: balanceColor);
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: <Widget>[
                      if (!hide)
                        Text('${coin.symbol}',
                            style: theme.textTheme.headline5),
                      Text(' $balanceHi', style: balanceStyle),
                      if (!hide) Text('${_getBalance_lo(balance)}'),
                    ]);
              }),
              Observer(builder: (context) {
                final hide = settings.autoHide && _flat;
                final balance = accountManager.showTAddr
                    ? accountManager.tbalance
                    : accountManager.balance;
                final fx = _fx();
                final balanceFX = balance * fx / ZECUNIT;
                return hide
                    ? Text(S.of(context).tiltYourDeviceUpToRevealYourBalance)
                    : Column(children: [
                        if (fx != 0.0)
                          Text(
                              "${decimalFormat(balanceFX, 2, symbol: settings.currency)}",
                              style: theme.textTheme.headline6),
                        if (fx != 0.0)
                          Text(
                              "1 ${coin.ticker} = ${decimalFormat(fx, 2, symbol: settings.currency)}"),
                      ]);
              }),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Observer(
                  builder: (context) => (accountManager.unconfirmedBalance != 0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: <Widget>[
                              Text(
                                  '${_sign(accountManager.unconfirmedBalance)} ${_getBalance_hi(accountManager.unconfirmedBalance)}',
                                  style: theme.textTheme.headline4
                                      ?.merge(_unconfirmedStyle())),
                              Text(
                                  '${_getBalance_lo(accountManager.unconfirmedBalance)}',
                                  style: _unconfirmedStyle()),
                            ])
                      : Container()),
              if (_progress > 0)
                LinearProgressIndicator(value: _progress / 100.0),
            ]))),
        NoteWidget(tabTo),
        HistoryWidget(tabTo),
        BudgetWidget(),
        PnLWidget(),
        ContactsTab(key: contactKey),
      ]),
      floatingActionButton: _accountTab
          ? FloatingActionButton(
              onPressed: _onSend,
              backgroundColor: Theme.of(context)
                  .accentColor
                  .withOpacity(accountManager.canPay ? 1.0 : 0.3),
              child: Icon(Icons.send),
            )
          : _contactsTab
              ? FloatingActionButton(
                  onPressed: _onAddContact,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.add),
                )
              : Container(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void tabTo(int index) {
    if (index != _tabController.index) _tabController.animateTo(index);
  }

  String _address() {
    final address = accountManager.showTAddr
        ? accountManager.taddress
        : (_useSnapAddress
            ? _uaAddress(_snapAddress, accountManager.taddress, settings.useUA)
            : _uaAddress(accountManager.active.address, accountManager.taddress,
                settings.useUA));
    return address;
  }

  String _uaAddress(String zaddress, String taddress, bool useUA) =>
      useUA ? WarpApi.getUA(zaddress, taddress) : zaddress;

  _sign(int b) {
    return b < 0 ? '-' : '+';
  }

  _onQRTap() {
    accountManager.toggleShowTAddr();
  }

  _onAddressCopy() {
    Clipboard.setData(ClipboardData(text: _address()));
    final snackBar =
        SnackBar(content: Text(S.of(context).addressCopiedToClipboard));
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  _onShieldTAddr() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(S.of(context).shieldTransparentBalance),
          content: Text(S
              .of(context)
              .doYouWantToTransferYourEntireTransparentBalanceTo(coin.ticker)),
          actions: confirmButtons(context, () async {
            final s = S.of(context);
            Navigator.of(this.context).pop();
            final snackBar1 = SnackBar(content: Text(s.shieldingInProgress));
            rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar1);
            final txid = await WarpApi.shieldTAddr(accountManager.active.id);
            final snackBar2 = SnackBar(content: Text("${s.txId}: $txid"));
            rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);
          })),
    );
  }

  _onReceive() async {
    await showDialog(context: context,
        barrierColor: Colors.black,
        builder: (context) =>
        Dialog(child: PaymentURIPage(_address())));
  }

  _unconfirmedStyle() {
    return TextStyle(
        color: amountColor(context, accountManager.unconfirmedBalance));
  }

  _getBalance_hi(int b) {
    return decimalFormat((b.abs() ~/ 100000) / 1000.0, 3);
  }

  _getBalance_lo(b) {
    return (b.abs() % 100000).toString().padLeft(5, '0');
  }

  _setupTimer() async {
    await _sync();
    _timerSync = Timer.periodic(Duration(seconds: 15), (Timer t) {
      _trySync();
    });
  }

  double _fx() {
    return priceStore.zecPrice;
  }

  _sync() async {}

  _trySync() async {
    priceStore.fetchZecPrice();
    if (syncStatus.syncedHeight < 0) return;
    await syncStatus.update();
    await accountManager.updateUnconfirmedBalance();
    if (!syncStatus.isSynced()) {
      final res =
          await WarpApi.tryWarpSync(settings.getTx, settings.anchorOffset);
      if (res == 1) {
        // Reorg
        final targetHeight = syncStatus.syncedHeight - 10;
        WarpApi.rewindToHeight(targetHeight);
        syncStatus.setSyncHeight(targetHeight);
      } else if (res == 0) {
        syncStatus.update();
      }
    }
    await accountManager.fetchAccountData(false);
    await accountManager.updateBalance();
    await accountManager.updateUnconfirmedBalance();
    await contacts.fetchContacts();
    accountManager.updateTBalance();
  }

  _onSnapAddress() {
    final address = accountManager.newAddress();
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

  _onSend() {
    Navigator.of(this.context).pushNamed('/send');
  }

  _onMenu(String choice) {
    switch (choice) {
      case "Accounts":
        Navigator.of(this.context).pushNamed('/accounts');
        break;
      case "Backup":
        _backup();
        break;
      case "Rescan":
        _rescan();
        break;
      case "Cold":
        _cold();
        break;
      case "MultiPay":
        _multiPay();
        break;
      case "Broadcast":
        _broadcast();
        break;
      case "Settings":
        _settings();
        break;
      case "About":
        showAbout(this.context);
        break;
    }
  }

  _backup() async {
    final didAuthenticate = await authenticate(context, S.of(context).pleaseAuthenticateToShowAccountSeed);
    if (didAuthenticate) {
      Navigator.of(context).pushNamed('/backup');
    }
  }

  _rescan() {
    rescanDialog(context, () {
      Navigator.of(context).pop();
      syncStatus.sync(context);
    });
  }

  _cold() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).coldStorage),
            content:
                Text(S.of(context).doYouWantToDeleteTheSecretKeyAndConvert),
            actions: confirmButtons(context, _convertToWatchOnly,
                okLabel: S.of(context).delete)));
  }

  _multiPay() {
    Navigator.of(context).pushNamed('/multipay');
  }

  _broadcast() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final res = WarpApi.broadcast(result.files.single.path);
      final snackBar = SnackBar(content: Text(res));
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  _convertToWatchOnly() {
    accountManager.convertToWatchOnly();
    Navigator.of(context).pop();
  }

  _settings() {
    Navigator.of(context).pushNamed('/settings');
  }

  _onAddContact() async {
    final contact = await contactKey.currentState
        ?.showContactForm(context, Contact.empty());
    if (contact != null) {
      contacts.add(contact);
    }
  }

  _handleAccel(AccelerometerEvent event) {
    final n = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    final inclination = acos(event.z / n) / pi * 180 * event.y.sign;
    final flat = inclination < 20;
    if (flat != _flat)
      setState(() {
        _flat = flat;
      });
  }
}

class BudgetWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BudgetState();
}

class BudgetState extends State<BudgetWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
        padding: EdgeInsets.all(4),
        child: Observer(builder: (context) {
          final _ = accountManager.dataEpoch;
          return Column(
            children: [
              Card(
                  child: Column(children: [
                Text(S.of(context).largestSpendingsByAddress,
                    style: Theme.of(context).textTheme.headline6),
                Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                BudgetChart(),
              ])),
              Expanded(
                  child: Card(
                      child: Column(children: [
                Text(S.of(context).accountBalanceHistory,
                    style: Theme.of(context).textTheme.headline6),
                Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                Expanded(child: Padding(padding: EdgeInsets.only(right: 20),
                    child: LineChartTimeSeries(accountManager.accountBalances)))
              ]))),
            ],
          );
        }));
  }
}

class PnLWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PnLState();
}

class PnLState extends State<PnLWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FormBuilderRadioGroup(
          orientation: OptionsOrientation.horizontal,
          name: S.of(context).pnl,
          initialValue: accountManager.pnlSeriesIndex,
          onChanged: (int? v) {
            setState(() {
              accountManager.setPnlSeriesIndex(v!);
            });
          },
          options: [
            FormBuilderFieldOption(child: Text(S.of(context).price), value: 0),
            FormBuilderFieldOption(
                child: Text(S.of(context).realized), value: 1),
            FormBuilderFieldOption(child: Text(S.of(context).mm), value: 2),
            FormBuilderFieldOption(child: Text(S.of(context).total), value: 3),
            FormBuilderFieldOption(child: Text(S.of(context).qty), value: 4),
            FormBuilderFieldOption(child: Text(S.of(context).table), value: 5),
          ]),
      Observer(builder: (context) {
        final _ = accountManager.pnlSorted;
        return Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: accountManager.pnlSeriesIndex != 5
                    ? PnLChart(
                        accountManager.pnls, accountManager.pnlSeriesIndex)
                    : PnLTable()));
      })
    ]);
  }
}

class PnLChart extends StatelessWidget {
  final List<PnL> pnls;
  final int seriesIndex;

  PnLChart(this.pnls, this.seriesIndex);

  @override
  Widget build(BuildContext context) {
    final series = _createSeries(pnls, seriesIndex, context);
    return LineChartTimeSeries(series);
  }

  static double _seriesData(PnL pnl, int index) {
    switch (index) {
      case 0:
        return pnl.price;
      case 1:
        return pnl.realized;
      case 2:
        return pnl.unrealized;
      case 3:
        return pnl.realized + pnl.unrealized;
      case 4:
        return pnl.amount;
    }
    return 0.0;
  }

  static List<TimeSeriesPoint<double>> _createSeries(
      List<PnL> data, int index, BuildContext context) {
    return data
        .map((pnl) => TimeSeriesPoint(
            pnl.timestamp.millisecondsSinceEpoch ~/ DAY_MS,
            _seriesData(pnl, index)))
        .toList();
  }
}

class PnLTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sortSymbol = accountManager.pnlDesc ? ' \u2193' : ' \u2191';
    return SingleChildScrollView(
        child: Observer(
            builder: (context) => PaginatedDataTable(
                columns: [
                  DataColumn(
                      label: Text(S.of(context).date + sortSymbol),
                      onSort: (_, __) {
                        accountManager.togglePnlDesc();
                      }),
                  DataColumn(label: Text(S.of(context).qty), numeric: true),
                  DataColumn(label: Text(S.of(context).price), numeric: true),
                  DataColumn(
                      label: Text(S.of(context).realized), numeric: true),
                  DataColumn(label: Text(S.of(context).mm), numeric: true),
                  DataColumn(label: Text(S.of(context).total), numeric: true),
                ],
                columnSpacing: 16,
                showCheckboxColumn: false,
                availableRowsPerPage: [5, 10, 25, 100],
                onRowsPerPageChanged: (int? value) {
                  settings.setRowsPerPage(value ?? 25);
                },
                showFirstLastButtons: true,
                rowsPerPage: settings.rowsPerPage,
                source: PnLDataSource(context))));
  }
}

class PnLDataSource extends DataTableSource {
  BuildContext context;
  final dateFormat = DateFormat("MM-dd");

  PnLDataSource(this.context);

  @override
  DataRow getRow(int index) {
    final pnl = accountManager.pnlSorted[index];
    final ts = dateFormat.format(pnl.timestamp);
    return DataRow(cells: [
      DataCell(Text("$ts")),
      DataCell(Text(decimalFormat(pnl.amount, 2))),
      DataCell(Text(decimalFormat(pnl.price, 3))),
      DataCell(Text(decimalFormat(pnl.realized, 3))),
      DataCell(Text(decimalFormat(pnl.unrealized, 3))),
      DataCell(Text(decimalFormat(pnl.realized + pnl.unrealized, 3))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => accountManager.pnls.length;

  @override
  int get selectedRowCount => 0;
}
