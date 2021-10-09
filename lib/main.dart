import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp/payment_uri.dart';
import 'package:warp_api/warp_api.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'generated/l10n.dart';

import 'account.dart';
import 'account_manager.dart';
import 'backup.dart';
import 'coin/coindef.dart';
import 'multisend.dart';
import 'settings.dart';
import 'restore.dart';
import 'send.dart';
import 'store.dart';
import 'transaction.dart';

var coin = Coin();

const ZECUNIT = 100000000.0;
var ZECUNIT_DECIMAL = Decimal.parse('100000000');
const mZECUNIT = 100000;
const DEFAULT_FEE = 1000;
const MAXMONEY = 21000000;
const DOC_URL = "https://hhanh00.github.io/zwallet/";

var accountManager = AccountManager();
var priceStore = PriceStore();
var syncStatus = SyncStatus();
var settings = Settings();
var multipayData = MultiPayStore();
var eta = ETAStore();
var contacts = ContactStore();

Future<Database> getDatabase() async {
  var databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'zec.db');
  var db = await openDatabase(path);
  return db;
}

StreamSubscription? subUniLinks;

Future<void> initUniLinks(BuildContext context) async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null)
        Navigator.of(context).pushNamed('/send', arguments: SendPageArgs(uri: initialLink));
  } on PlatformException {
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final home = ZWalletApp();
  runApp(FutureBuilder(
      future: settings.restore(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? MaterialApp(home: Container()) :
              Observer(builder: (context) {
                final theme = settings.themeData.copyWith(
                    dataTableTheme: DataTableThemeData(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (_) => settings.themeData.highlightColor)));
                return MaterialApp(
                  title: coin.app,
                  theme: theme,
                  home: home,
                  scaffoldMessengerKey: rootScaffoldMessengerKey,
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  onGenerateRoute: (RouteSettings settings) {
                    var routes = <String, WidgetBuilder>{
                      '/account': (context) => AccountPage(),
                      '/restore': (context) => RestorePage(),
                      '/send': (context) =>
                          SendPage(settings.arguments as SendPageArgs?),
                      '/accounts': (context) => AccountManagerPage(),
                      '/settings': (context) => SettingsPage(),
                      '/tx': (context) =>
                          TransactionPage(settings.arguments as Tx),
                      '/backup': (context) => BackupPage(settings.arguments as int?),
                      '/multipay': (context) => MultiPayPage(),
                    };
                    return MaterialPageRoute(builder: routes[settings.name]!);
                  },
                );
              });
      }));
}

class ZWalletApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ZWalletAppState();
}

class ZWalletAppState extends State<ZWalletApp> {
  bool initialized = false;

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 20,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(this.context);
      }
    });
  }

  Future<bool> _init(BuildContext context) async {
    if (!initialized) {
      initialized = true;
      final dbPath = await getDatabasesPath();
      WarpApi.initWallet(dbPath + "/zec.db", settings.getLWD());
      final db = await getDatabase();
      await accountManager.init(db);
      await contacts.init(db);
      await syncStatus.init();
      await initUniLinks(context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return accountManager.accounts.isNotEmpty
              ? AccountPage()
              : AccountManagerPage();
        });
  }
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

List<ElevatedButton> confirmButtons(
    BuildContext context, VoidCallback? onPressed,
    {String? okLabel, Icon? okIcon, cancelValue}) {
  final navigator = Navigator.of(context);
  return <ElevatedButton>[
    ElevatedButton.icon(
        icon: Icon(Icons.cancel),
        label: Text(S.of(context).cancel),
        onPressed: () {
          cancelValue != null ? navigator.pop(cancelValue) : navigator.pop();
        },
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).buttonTheme.colorScheme!.secondary)),
    ElevatedButton.icon(
      icon: okIcon ?? Icon(Icons.done),
      label: Text(okLabel ?? S.of(context).ok),
      onPressed: onPressed,
    )
  ];
}

List<TimeSeriesPoint<V>> sampleDaily<T, Y, V>(
    List<T> timeseries,
    int start,
    int end,
    int Function(T) getDay,
    Y Function(T) getY,
    V Function(V, Y) accFn,
    V initial) {
  assert(start % DAY_MS == 0);
  final s = start ~/ DAY_MS;
  final e = end ~/ DAY_MS;

  var acc = initial;
  var j = 0;
  while (j < timeseries.length && getDay(timeseries[j]) < s) {
    acc = accFn(acc, getY(timeseries[j]));
    j += 1;
  }

  List<TimeSeriesPoint<V>> ts = [];

  for (var i = s; i <= e; i++) {
    while (j < timeseries.length && getDay(timeseries[j]) == i) {
      acc = accFn(acc, getY(timeseries[j]));
      j += 1;
    }
    ts.add(TimeSeriesPoint(i, acc));
  }
  return ts;
}

String unwrapUA(String address) {
  final zaddr = WarpApi.getSaplingFromUA(address);
  return zaddr.isNotEmpty ? zaddr : address;
}

void showQR(BuildContext context, String text) {
  showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) => AlertDialog(
            content: Container(
                width: double.maxFinite,
                child: QrImage(data: text, backgroundColor: Colors.white)),
          ));
}

Future<bool> rescanDialog(
    BuildContext context) async {
  final approved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(S.of(context).rescan),
          content: Text(S.of(context).rescanWalletFromTheFirstBlock),
          actions: confirmButtons(context, () => Navigator.of(context).pop(true), cancelValue: false))) ?? false;
  if (approved)
    return await confirmWifi(context);
  return false;
}

Future<bool> confirmWifi(BuildContext context) async {
  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity == ConnectivityResult.mobile) {
    return await showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).rescan),
            content: Text('On Mobile Data, scanning may incur additional charges. Do you want to proceed?'),
            actions: confirmButtons(context, () => Navigator.of(context).pop(true), cancelValue: false))) ?? false;
  }
  return true;
}

Future<bool> showMessageBox(
    BuildContext context, String title, String content, String label) async {
  final confirm = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: confirmButtons(context, () {
          Navigator.of(context).pop(true);
        }, okLabel: label, cancelValue: false)),
  );
  return confirm ?? false;
}

double getScreenSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return min(size.height, size.width);
}

Color amountColor(BuildContext context, num a) {
  final theme = Theme.of(context);
  if (a < 0) return Colors.red;
  if (a > 0) return Colors.green;
  return theme.textTheme.bodyText1!.color!;
}

TextStyle fontWeight(TextStyle style, num v) {
  final value = v.abs();
  final style2 = style.copyWith(fontFeatures: [FontFeature.tabularFigures()]);
  if (value >= coin.weights[2])
    return style2.copyWith(fontWeight: FontWeight.w800);
  else if (value >= coin.weights[1])
    return style2.copyWith(fontWeight: FontWeight.w600);
  else if (value >= coin.weights[0]) return style2.copyWith(fontWeight: FontWeight.w400);
  return style2.copyWith(fontWeight: FontWeight.w200);
}

CurrencyTextInputFormatter makeInputFormatter(bool mZEC) =>
    CurrencyTextInputFormatter(symbol: '', decimalDigits: precision(mZEC));

double parseNumber(String? s) {
  if (s == null || s.isEmpty) return 0;
  return NumberFormat.currency().parse(s).toDouble();
}

int stringToAmount(String? s) {
  final a = parseNumber(s);
  return (Decimal.parse(a.toString()) * ZECUNIT_DECIMAL).toInt();
}

bool checkNumber(String s) {
  try {
    NumberFormat.currency().parse(s);
  }
  on FormatException { return false; }
  return true;
}

int precision(bool mZEC) => mZEC ? 3 : 8;

Future<String?> scanCode(BuildContext context) async {
  final code = await FlutterBarcodeScanner.scanBarcode('#FF0000', S.of(context).cancel, true, ScanMode.QR);
  if (code == "-1") return null;
  return code;
}

String addressLeftTrim(String address) =>
    address != "" ? address.substring(0, 8) + "..." + address.substring(address.length - 16) : "";

void showSnackBar(String msg) {
  final snackBar = SnackBar(content: Text(msg));
  rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}

enum DeviceWidth {
  xs, sm, md, lg, xl
}

DeviceWidth getWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return DeviceWidth.xs;
  if (width < 960) return DeviceWidth.sm;
  if (width < 1280) return DeviceWidth.md;
  if (width < 1920) return DeviceWidth.lg;
  return DeviceWidth.xl;
}

String decimalFormat(double x, int decimalDigits, { String symbol = '' }) =>
    NumberFormat.currency(decimalDigits: decimalDigits, symbol: symbol).format(x).trimRight();

String amountToString(int amount) => decimalFormat(amount / ZECUNIT, 8);

Future<bool> authenticate(BuildContext context, String reason) async {
  final localAuth = LocalAuthentication();
  try {
    final didAuthenticate = await localAuth.authenticate(
        localizedReason: reason);
    if (didAuthenticate) {
      return true;
    }
  } on PlatformException catch (e) {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            AlertDialog(
                title: Text(S
                    .of(context)
                    .noAuthenticationMethod),
                content: Text(e.message ?? "")));
  }
  return false;
}

Future<void> shieldTAddr(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
        title: Text(S.of(context).shieldTransparentBalance),
        content: Text(S
            .of(context)
            .doYouWantToTransferYourEntireTransparentBalanceTo(coin.ticker)),
        actions: confirmButtons(context, () async {
          final s = S.of(context);
          Navigator.of(context).pop();
          final snackBar1 = SnackBar(content: Text(s.shieldingInProgress));
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar1);
          final txid = await WarpApi.shieldTAddr(accountManager.active.id);
          final snackBar2 = SnackBar(content: Text("${s.txId}: $txid"));
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);
        })),
  );
}

