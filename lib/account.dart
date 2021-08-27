import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp/store.dart';
import 'package:warp_api/warp_api.dart';
import 'package:grouped_list/grouped_list.dart';

import 'about.dart';
import 'chart.dart';
import 'main.dart';
import 'generated/l10n.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  Timer _timerSync;
  int _progress = 0;
  bool _useSnapAddress = false;
  String _snapAddress = "";
  TabController _tabController;
  bool _accountTab = true;
  bool _syncing = false;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _accountTab = _tabController.index == 0;
      });
    });
    Future.microtask(() async {
      await accountManager.updateUnconfirmedBalance();
      await accountManager.fetchAccountData();
      await _setupTimer();
    });
    WidgetsBinding.instance.addObserver(this);
    progressStream.listen((percent) {
      setState(() {
        _progress = percent;
      });
    });
  }

  @override
  void dispose() {
    _timerSync?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _timerSync?.cancel();
        break;
      case AppLifecycleState.resumed:
        _setupTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!syncStatus.isSynced() && !_syncing) _trySync();
    if (accountManager.active == null) return CircularProgressIndicator();
    final theme = Theme.of(this.context);
    final hasTAddr = accountManager.taddress.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Observer(
            builder: (context) =>
                Text("${coin.symbol} Wallet - ${accountManager.active.name}")),
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
              Observer(
                  builder: (context) => syncStatus.syncedHeight <= 0
                      ? Text(S.of(context).synching)
                      : syncStatus.isSynced()
                          ? Text('${syncStatus.syncedHeight}',
                              style: theme.textTheme.caption)
                          : Text(
                              '${syncStatus.syncedHeight} / ${syncStatus.latestHeight}',
                              style: theme.textTheme.caption
                                  .apply(color: theme.primaryColor))),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Observer(builder: (context) {
                final _ = accountManager.active.address;
                final address = _address();
                final showTAddr = accountManager.showTAddr;
                return Column(children: [
                  if (hasTAddr)
                    Text(showTAddr
                        ? S.of(context).tapQrCodeForShieldedAddress
                        : S.of(context).tapQrCodeForTransparentAddress),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                      onTap: hasTAddr ? _onQRTap : null,
                      child: QrImage(
                          data: address,
                          size: 200,
                          backgroundColor: Colors.white)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '$address ', style: theme.textTheme.bodyText2),
                    WidgetSpan(
                        child: GestureDetector(
                            child: Icon(Icons.content_copy),
                            onTap: _onAddressCopy)),
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
                final balance = accountManager.showTAddr
                    ? accountManager.tbalance
                    : accountManager.balance;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: <Widget>[
                      Text('${coin.symbol} ${_getBalance_hi(balance)}',
                          style: theme.textTheme.headline2),
                      Text('${_getBalance_lo(balance)}'),
                    ]);
              }),
              Observer(builder: (context) {
                final balance = accountManager.showTAddr
                    ? accountManager.tbalance
                    : accountManager.balance;
                final fx = _fx();
                final balanceFX = balance * fx / ZECUNIT;
                return Column(children: [
                  if (fx != 0.0)
                    Text("${balanceFX.toStringAsFixed(2)} ${settings.currency}",
                        style: theme.textTheme.headline6),
                  if (fx != 0.0)
                    Text(
                        "1 ${coin.ticker} = ${fx.toStringAsFixed(2)} ${settings.currency}"),
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
        ContactsWidget(),
      ]),
      floatingActionButton: _accountTab
          ? FloatingActionButton(
              onPressed: _onSend,
              tooltip: S.of(context).send,
              backgroundColor: Theme.of(context)
                  .accentColor
                  .withOpacity(accountManager.canPay ? 1.0 : 0.3),
              child: Icon(Icons.send),
            )
          : Container(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void tabTo(int index) {
    if (index != _tabController.index) _tabController.animateTo(index);
  }

  _address() => accountManager.showTAddr
      ? accountManager.taddress
      : (_useSnapAddress ?
          _uaAddress(_snapAddress, accountManager.taddress, settings.useUA) :
          _uaAddress(accountManager.active.address, accountManager.taddress, settings.useUA));

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
    rootScaffoldMessengerKey.currentState.showSnackBar(snackBar);
  }

  _onShieldTAddr() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(S.of(context).shieldTransparentBalance),
          content: Text(
              S.of(context).doYouWantToTransferYourEntireTransparentBalanceTo),
          actions: confirmButtons(context, () async {
            final s = S.of(context);
            Navigator.of(this.context).pop();
            final snackBar1 = SnackBar(content: Text(s.shieldingInProgress));
            rootScaffoldMessengerKey.currentState.showSnackBar(snackBar1);
            final txid = await WarpApi.shieldTAddr(accountManager.active.id);
            final snackBar2 = SnackBar(content: Text("${s.txId}: $txid"));
            rootScaffoldMessengerKey.currentState.showSnackBar(snackBar2);
          })),
    );
  }

  _unconfirmedStyle() {
    return accountManager.unconfirmedBalance > 0
        ? TextStyle(color: Colors.green)
        : TextStyle(color: Colors.red);
  }

  _getBalance_hi(int b) {
    return ((b.abs() ~/ 100000) / 1000.0).toStringAsFixed(3);
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

  _sync() async {
    _syncing = true;
    await syncStatus.update();
    WarpApi.warpSync(settings.getTx, settings.anchorOffset, (int height) async {
      setState(() {
        if (height >= 0)
          syncStatus.setSyncHeight(height);
        else {
          _syncing = false;
          WarpApi.mempoolReset(syncStatus.latestHeight);
          _trySync();
        }
      });
    });
  }

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
    await accountManager.fetchAccountData();
    await accountManager.updateBalance();
    await accountManager.updateUnconfirmedBalance();
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
    final localAuth = LocalAuthentication();
    try {
      final didAuthenticate = await localAuth.authenticate(
          localizedReason: S.of(context).pleaseAuthenticateToShowAccountSeed);
      if (didAuthenticate) {
        Navigator.of(context).pushNamed('/backup', arguments: true);
      }
    } on PlatformException catch (e) {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
              title: Text(S.of(context).noAuthenticationMethod),
              content: Text(e.message)));
    }
  }

  _rescan() {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).rescan),
            content: Text(S.of(context).rescanWalletFromTheFirstBlock),
            actions: confirmButtons(context, () {
              Navigator.of(this.context).pop();
              final snackBar =
                  SnackBar(content: Text(S.of(context).rescanRequested));
              rootScaffoldMessengerKey.currentState.showSnackBar(snackBar);
              syncStatus.setSyncHeight(0);
              WarpApi.rewindToHeight(0);
              _sync();
            })));
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
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBar);
    }
  }

  _convertToWatchOnly() {
    accountManager.convertToWatchOnly();
    Navigator.of(context).pop();
  }

  _settings() {
    Navigator.of(this.context).pushNamed('/settings');
  }
}

class NoteWidget extends StatefulWidget {
  void Function(int index) tabTo;

  NoteWidget(this.tabTo);

  @override
  State<StatefulWidget> createState() => _NoteState();
}

class _NoteState extends State<NoteWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        padding: EdgeInsets.all(4),
        scrollDirection: Axis.vertical,
        child: Observer(builder: (context) {
          var amountHeader = S.of(context).amount;
          switch (accountManager.noteSortOrder) {
            case SortOrder.Ascending:
              amountHeader += ' \u2191';
              break;
            case SortOrder.Descending:
              amountHeader += ' \u2193';
              break;
            default:
          }
          return NotificationListener<OverscrollNotification>(
              onNotification: (s) {
                final os = s.overscroll;
                if (os < 0) {
                  widget.tabTo(0);
                  return true;
                }
                if (os > 0) {
                  widget.tabTo(2);
                  return true;
                }
                return false;
              },
              child: PaginatedDataTable(
                columns: [
                  DataColumn(
                      label: settings.showConfirmations
                          ? Text(S.of(context).confs)
                          : Text(S.of(context).height),
                      onSort: (_, __) {
                        setState(() {
                          settings.toggleShowConfirmations();
                        });
                      }),
                  DataColumn(label: Text(S.of(context).datetime)),
                  DataColumn(
                      label: Text(amountHeader),
                      numeric: true,
                      onSort: (_, __) {
                        setState(() {
                          accountManager.sortNoteAmount();
                        });
                      }),
                ],
                header: Text(S.of(context).selectNotesToExcludeFromPayments,
                    style: Theme.of(context).textTheme.bodyText1),
                columnSpacing: 16,
                showCheckboxColumn: false,
                availableRowsPerPage: [5, 10, 25, 100],
                onRowsPerPageChanged: (int value) {
                  settings.setRowsPerPage(value);
                },
                showFirstLastButtons: true,
                rowsPerPage: settings.rowsPerPage,
                source: NotesDataSource(context, _onRowSelected),
              ));
        }));
  }

  _onRowSelected(Note note) {
    accountManager.excludeNote(note);
  }
}

class NotesDataSource extends DataTableSource {
  final BuildContext context;
  final Function(Note) onRowSelected;

  NotesDataSource(this.context, this.onRowSelected);

  @override
  DataRow getRow(int index) {
    final note = accountManager.sortedNotes[index];
    final theme = Theme.of(context);
    final confsOrHeight = settings.showConfirmations
        ? syncStatus.latestHeight - note.height + 1
        : note.height;

    var style = _confirmed(note.height)
        ? theme.textTheme.bodyText2
        : theme.textTheme.overline;
    if (note.spent)
      style = style.merge(TextStyle(decoration: TextDecoration.lineThrough));

    return DataRow.byIndex(
      index: index,
      selected: note.excluded,
      color: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? theme.primaryColor.withOpacity(0.5)
              : theme.backgroundColor),
      cells: [
        DataCell(Text("$confsOrHeight", style: style)),
        DataCell(Text("${note.timestamp}", style: style)),
        DataCell(Text("${note.value.toStringAsFixed(8)}", style: style)),
      ],
      onSelectChanged: (selected) => _noteSelected(note, selected),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => accountManager.notes.length;

  @override
  int get selectedRowCount => 0;

  bool _confirmed(int height) {
    return syncStatus.latestHeight - height >= settings.anchorOffset;
  }

  void _noteSelected(Note note, bool selected) {
    note.excluded = !note.excluded;
    notifyListeners();
    onRowSelected(note);
  }
}

class HistoryWidget extends StatefulWidget {
  void Function(int index) tabTo;

  HistoryWidget(this.tabTo);

  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<HistoryWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        padding: EdgeInsets.all(4),
        scrollDirection: Axis.vertical,
        child: Observer(builder: (context) {
          var amountHeader = S.of(context).amount;
          switch (accountManager.txSortOrder) {
            case SortOrder.Ascending:
              amountHeader += ' \u2191';
              break;
            case SortOrder.Descending:
              amountHeader += ' \u2193';
              break;
            default:
          }
          return NotificationListener<OverscrollNotification>(
              onNotification: (s) {
                if (s.overscroll < 0) {
                  widget.tabTo(1);
                  return true;
                }
                if (s.overscroll > 0) {
                  widget.tabTo(3);
                  return true;
                }
                return false;
              },
              child: PaginatedDataTable(
                  columns: [
                    DataColumn(
                        label: settings.showConfirmations
                            ? Text(S.of(context).confs)
                            : Text(S.of(context).height),
                        onSort: (_, __) {
                          setState(() {
                            settings.toggleShowConfirmations();
                          });
                        }),
                    DataColumn(label: Text(S.of(context).datetime)),
                    DataColumn(label: Text(S.of(context).txId)),
                    DataColumn(
                        label: Text(amountHeader),
                        numeric: true,
                        onSort: (_, __) {
                          setState(() {
                            accountManager.sortTxAmount();
                          });
                        }),
                  ],
                  columnSpacing: 16,
                  showCheckboxColumn: false,
                  availableRowsPerPage: [5, 10, 25, 100],
                  onRowsPerPageChanged: (int value) {
                    settings.setRowsPerPage(value);
                  },
                  showFirstLastButtons: true,
                  rowsPerPage: settings.rowsPerPage,
                  source: HistoryDataSource(context)));
        }));
  }
}

class HistoryDataSource extends DataTableSource {
  BuildContext context;

  HistoryDataSource(this.context);

  @override
  DataRow getRow(int index) {
    final tx = accountManager.sortedTxs[index];
    final confsOrHeight = settings.showConfirmations
        ? syncStatus.latestHeight - tx.height + 1
        : tx.height;
    return DataRow(
        cells: [
          DataCell(Text("$confsOrHeight")),
          DataCell(Text("${tx.timestamp}")),
          DataCell(Text("${tx.txid}")),
          DataCell(Text("${tx.value.toStringAsFixed(8)}",
              textAlign: TextAlign.left)),
        ],
        onSelectChanged: (_) {
          Navigator.of(this.context).pushNamed('/tx', arguments: tx);
        });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => accountManager.txs.length;

  @override
  int get selectedRowCount => 0;
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
              Expanded(
                  child: Card(
                      child: Column(children: [
                Text(S.of(context).largestSpendingsByAddress,
                    style: Theme.of(context).textTheme.headline6),
                Expanded(
                  child: PieChartSpending(accountManager.spendings),
                ),
                Text(S.of(context).tapChartToToggleBetweenAddressAndAmount,
                    style: Theme.of(context).textTheme.caption)
              ]))),
              Expanded(
                  child: Card(
                      child: Column(children: [
                Text(S.of(context).accountBalanceHistory,
                    style: Theme.of(context).textTheme.headline6),
                Expanded(
                    child: LineChartTimeSeries(accountManager.accountBalances))
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
          onChanged: (v) {
            setState(() {
              accountManager.setPnlSeriesIndex(v);
            });
          },
          options: [
            FormBuilderFieldOption(
                child: Text(S.of(context).realized), value: 0),
            FormBuilderFieldOption(child: Text(S.of(context).mm), value: 1),
            FormBuilderFieldOption(child: Text(S.of(context).total), value: 2),
            FormBuilderFieldOption(child: Text(S.of(context).price), value: 3),
            FormBuilderFieldOption(child: Text(S.of(context).qty), value: 4),
            FormBuilderFieldOption(child: Text(S.of(context).table), value: 5),
          ]),
      Observer(builder: (context) {
        final _ = accountManager.pnlSorted;
        return Expanded(
            child: accountManager.pnlSeriesIndex != 5
                ? PnLChart(accountManager.pnls, accountManager.pnlSeriesIndex)
                : PnLTable());
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
        return pnl.realized;
      case 1:
        return pnl.unrealized;
      case 2:
        return pnl.realized + pnl.unrealized;
      case 3:
        return pnl.price;
      case 4:
        return pnl.amount;
    }
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
        child: PaginatedDataTable(
            columns: [
              DataColumn(
                  label: Text(S.of(context).datetime + sortSymbol),
                  onSort: (_, __) {
                    accountManager.togglePnlDesc();
                  }),
              DataColumn(label: Text(S.of(context).qty), numeric: true),
              DataColumn(label: Text(S.of(context).price), numeric: true),
              DataColumn(label: Text(S.of(context).realized), numeric: true),
              DataColumn(label: Text(S.of(context).mm), numeric: true),
              DataColumn(label: Text(S.of(context).total), numeric: true),
            ],
            columnSpacing: 16,
            showCheckboxColumn: false,
            availableRowsPerPage: [5, 10, 25, 100],
            onRowsPerPageChanged: (int value) {
              settings.setRowsPerPage(value);
            },
            showFirstLastButtons: true,
            rowsPerPage: settings.rowsPerPage,
            source: PnLDataSource(context)));
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
      DataCell(Text("${pnl.amount.toStringAsFixed(2)}")),
      DataCell(Text("${pnl.price.toStringAsFixed(3)}")),
      DataCell(Text("${pnl.realized.toStringAsFixed(3)}")),
      DataCell(Text("${pnl.unrealized.toStringAsFixed(3)}")),
      DataCell(Text("${(pnl.realized + pnl.unrealized).toStringAsFixed(3)}")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => accountManager.pnls.length;

  @override
  int get selectedRowCount => 0;
}

class ContactsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactsState();
}

class ContactsState extends State<ContactsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final _ = accountManager.dataEpoch;
      final theme = Theme.of(context);
      return Padding(
          padding: EdgeInsets.all(12),
          child: Column(children: [
            Text(S.of(context).toMakeAContactSendThemAMemoWithContact,
                style: Theme.of(context).textTheme.caption),
            Expanded(
                child: GroupedListView<Contact, String>(
              elements: accountManager.contacts,
              groupBy: (e) => e.name.isEmpty ? "" : e.name[0],
              itemBuilder: (context, c) => ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.address),
                  trailing: accountManager.canPay
                      ? IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () {
                            _onContact(c);
                          })
                      : null),
              groupSeparatorBuilder: (String h) =>
                  Text(h, style: theme.textTheme.headline5),
            )),
          ]));
    });
  }

  _onContact(Contact contact) {
    Navigator.of(context).pushNamed('/send', arguments: contact);
  }
}
