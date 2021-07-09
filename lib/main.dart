import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';
import 'package:splashscreen/splashscreen.dart';

import 'account.dart';
import 'account_manager.dart';
import 'settings.dart';
import 'restore.dart';
import 'send.dart';
import 'store.dart';

const ZECUNIT = 100000000.0;
var ZECUNIT_DECIMAL = Decimal.parse('100000000');
const mZECUNIT = 100000;
const DEFAULT_FEE = 1000;

var accountManager = AccountManager();
var priceStore = PriceStore();
var syncStatus = SyncStatus();
var settings = Settings();

Future<Database> getDatabase() async {
  var databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'zec.db');
  var db = await openDatabase(path);
  return db;
}

void main() {
  final home = ZWalletApp();
  runApp(Observer(
      builder: (context) => MaterialApp(
            title: 'Warp Sync Demo',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: settings.mode,
            home: home,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            onGenerateRoute: (RouteSettings settings) {
              var routes = <String, WidgetBuilder>{
                '/account': (context) => AccountPage(),
                '/restore': (context) => RestorePage(),
                '/send': (context) => SendPage(),
                '/accounts': (context) => AccountManagerPage(),
                '/settings': (context) => SettingsPage(),
              };
              return MaterialPageRoute(builder: routes[settings.name]);
            },
          )));
}

class ZWalletApp extends StatelessWidget {
  Future<Widget> _init() async {
    final dbPath = await getDatabasesPath();
    await settings.restore();
    WarpApi.initWallet(dbPath + "/zec.db", settings.getLWD());
    await accountManager.init();
    await syncStatus.init();
    return Future.value(
        accountManager.accounts.isNotEmpty ? AccountPage() : AccountManagerPage());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterFuture: _init(),
        title: new Text(
          'ZWallet',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: new Image.asset('assets/zcash.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 50.0,
        loaderColor: Colors.red);
  }
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
