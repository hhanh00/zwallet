import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';
import 'package:splashscreen/splashscreen.dart';

import 'account.dart';
import 'account_manager.dart';
import 'backup.dart';
import 'multisend.dart';
import 'settings.dart';
import 'restore.dart';
import 'send.dart';
import 'store.dart';
import 'transaction.dart';

const ZECUNIT = 100000000.0;
var ZECUNIT_DECIMAL = Decimal.parse('100000000');
const mZECUNIT = 100000;
const DEFAULT_FEE = 1000;

var accountManager = AccountManager();
var priceStore = PriceStore();
var syncStatus = SyncStatus();
var settings = Settings();
var multipayData = MultiPayStore();

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
      builder: (context, state) => state.hasData
          ? Observer(
              builder: (context) => MaterialApp(
                    title: 'ZWallet',
                    theme: settings.themeData,
                    home: home,
                    scaffoldMessengerKey: rootScaffoldMessengerKey,
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
      await accountManager.init();
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
        'ZWallet',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset('assets/zcash.png'),
      backgroundColor: theme.backgroundColor,
      photoSize: 50.0,
      loaderColor: theme.primaryColor,
    );
  }
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
