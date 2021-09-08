import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final home = ZWalletApp();
  runApp(FutureBuilder(
      future: settings.restore(),
      builder: (context, state) =>
      state.hasData
          ? Observer(
          builder: (context) =>
              MaterialApp(
                title: 'ZWallet',
                theme: settings.themeData,
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
                    '/send': (context) => SendPage(settings.arguments),
                    '/accounts': (context) => AccountManagerPage(),
                    '/settings': (context) => SettingsPage(),
                    '/tx': (context) => TransactionPage(settings.arguments),
                    '/backup': (context) => BackupPage(),
                    '/multipay': (context) => MultiPayPage(),
                  };
                  return MaterialPageRoute(builder: routes[settings.name]);
                },
              ))
          : Container()));
}

class ZWalletApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ZWalletAppState();
}

class ZWalletAppState extends State<ZWalletApp> {
  bool initialized = false;

  Future<Widget> _init() async {
    if (!initialized) {
      initialized = true;
      final dbPath = await getDatabasesPath();
      WarpApi.initWallet(dbPath + "/zec.db", settings.getLWD());
      final db = await getDatabase();
      await accountManager.init(db);
      await contacts.init(db);

      await syncStatus.init();
    }
    return Future.value(accountManager.accounts.isNotEmpty
        ? AccountPage()
        : AccountManagerPage());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SplashScreen(
      navigateAfterFuture: _init(),
      title: new Text(
        coin.app,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset('assets/icon.png'),
      backgroundColor: theme.backgroundColor,
      photoSize: 50.0,
      loaderColor: theme.primaryColor,
    );
  }
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

List<ElevatedButton> confirmButtons(BuildContext context,
    VoidCallback onPressed,
    {String okLabel, Icon okIcon, cancelValue}) {
  final navigator = Navigator.of(context);
  return <ElevatedButton>[
    ElevatedButton.icon(
        icon: Icon(Icons.cancel),
        label: Text(S
            .of(context)
            .cancel),
        onPressed: () {
          cancelValue != null ? navigator.pop(cancelValue) : navigator.pop();
        },
        style: ElevatedButton.styleFrom(
            primary: Theme
                .of(context)
                .buttonTheme
                .colorScheme
                .secondary)),
    ElevatedButton.icon(
      icon: okIcon ?? Icon(Icons.done),
      label: Text(okLabel ?? S
          .of(context)
          .ok),
      onPressed: onPressed,
    )
  ];
}

List<TimeSeriesPoint<V>> sampleDaily<T, Y, V>(List<T> timeseries,
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
            child: QrImage(data: text, backgroundColor: Colors.white)
        ),
      ));
}

Future<void> rescanDialog(BuildContext context, VoidCallback continuation) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(S.of(context).rescan),
          content: Text(S.of(context).rescanWalletFromTheFirstBlock),
          actions: confirmButtons(context, continuation)));
}

Future<bool> showMessageBox(BuildContext context, String title, String content, String label) {
  final confirm = showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: confirmButtons(context, () {
              Navigator.of(context).pop(true);
            }, okLabel: label, cancelValue: false)),
  );
  return confirm;
}
