import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';
import 'package:splashscreen/splashscreen.dart';

import 'account.dart';
import 'account_manager.dart';
import 'restore.dart';
import 'send.dart';
import 'store.dart';

const ZECUNIT = 100000000.0;

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
  runApp(Observer(
      builder: (context) => MaterialApp(
            title: 'Warp Sync Demo',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: settings.mode,
            home: ZWalletApp(),
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            onGenerateRoute: (RouteSettings settings) {
              var routes = <String, WidgetBuilder>{
                '/account': (context) => AccountPage(),
                '/restore': (context) => RestorePage(),
                '/send': (context) => SendPage(),
                '/accounts': (context) => AccountManagerPage(),
              };
              return MaterialPageRoute(builder: routes[settings.name]);
            },
          )));
}

class ZWalletApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ZWalletState();
}

class _ZWalletState extends State<ZWalletApp> {
  Future<Widget> _init() async {
    final dbPath = await getDatabasesPath();
    WarpApi.initWallet(dbPath + "/zec.db");
    await accountManager.init();
    await syncStatus.init();
    await settings.restore();
    return Future.value(AccountPage());
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
