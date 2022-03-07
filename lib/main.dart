import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warp_api/warp_api.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uni_links/uni_links.dart';
import 'package:quick_actions/quick_actions.dart';
import 'accounts.dart';
import 'coin/coins.dart';
import 'generated/l10n.dart';

import 'account_manager.dart';
import 'backup.dart';
import 'home.dart';
import 'multisend.dart';
// import 'multisign.dart';
import 'payment_uri.dart';
import 'reset.dart';
import 'settings.dart';
import 'restore.dart';
import 'send.dart';
import 'store.dart';
import 'theme_editor.dart';
import 'transaction.dart';

const ZECUNIT = 100000000.0;
var ZECUNIT_DECIMAL = Decimal.parse('100000000');
const mZECUNIT = 100000;
const DEFAULT_FEE = 1000;
const MAXMONEY = 21000000;
const DOC_URL = "https://hhanh00.github.io/zwallet/";
const APP_NAME = "ZYWallet";

// var accountManager = AccountManager();
var priceStore = PriceStore();
var syncStatus = SyncStatus();
var settings = Settings();
var multipayData = MultiPayStore();
var eta = ETAStore();
var contacts = ContactStore();
var accounts = AccountManager2();
var active = ActiveAccount();

StreamSubscription? subUniLinks;

void handleUri(BuildContext context, Uri uri) {
  final scheme = uri.scheme;
  final coinDef = settings.coins.firstWhere((c) => c.def.currency == scheme);
  final id = settings.coins[coinDef.coin].active;
  if (id != 0) {
    active.setActiveAccount(coinDef.coin, id);
    Navigator.of(context).pushNamed(
        '/send', arguments: SendPageArgs(uri: uri.toString()));
  }
}

Future<void> initUniLinks(BuildContext context) async {
  try {
    final uri = await getInitialUri();
    if (uri != null) {
      handleUri(context, uri);
    }
  } on PlatformException {}

  subUniLinks = linkStream.listen((String? uriString) {
    if (uriString == null) return;
    final uri = Uri.parse(uriString);
    handleUri(context, uri);
  });
}

void handleQuickAction(BuildContext context, String type) {
  final t = type.split(".");
  final coin = int.parse(t[0]);
  final shortcut = t[1];
  final a = settings.coins[coin].active;

  if (a != 0) {
    Future.microtask(() async {
      await active.setActiveAccount(coin, a);
      switch (shortcut) {
        case 'receive':
          Navigator.of(context).pushNamed('/receive');
          break;
        case 'send':
          Navigator.of(context).pushNamed('/send');
          break;
      }
    });
  }
}

class LoadProgress extends StatelessWidget {
  final double value;

  LoadProgress(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SizedBox(height: 200, width: 200, child:
        Column(
            children: [
              Text(S.of(context).loading, style: Theme.of(context).textTheme.headline4),
              Padding(padding: EdgeInsets.all(16)),
              LinearProgressIndicator(value: value),
              Padding(padding: EdgeInsets.all(16)),
              ElevatedButton(
                  onPressed: () => _reset(context), child: Text('EMERGENCY RESET'))
            ]
        )
        ));
  }

  _reset(BuildContext context) async {
    Navigator.of(context).pushNamed('/reset');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final home = ZWalletApp();
  // final home = MultisigPage();
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
            title: APP_NAME,
            debugShowCheckedModeBanner: false,
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
            onGenerateRoute: (RouteSettings routeSettings) {
              var routes = <String, WidgetBuilder>{
                '/account': (context) => HomePage(),
                '/restore': (context) => RestorePage(),
                '/send': (context) =>
                    SendPage(routeSettings.arguments as SendPageArgs?),
                '/receive': (context) =>
                    PaymentURIPage(routeSettings.arguments as String?),
                '/accounts': (context) => AccountManagerPage(),
                '/settings': (context) => SettingsPage(),
                '/tx': (context) =>
                    TransactionPage(routeSettings.arguments as Tx),
                '/backup': (context) =>
                    BackupPage(routeSettings.arguments as AccountId?),
                '/multipay': (context) => MultiPayPage(),
                // '/multisig': (context) => MultisigPage(),
                // '/multisign': (context) => MultisigAggregatorPage(
                //     routeSettings.arguments as TxSummary),
                // '/multisig_shares': (context) =>
                //     MultisigSharesPage(routeSettings.arguments as String),
                '/edit_theme': (context) =>
                    ThemeEditorPage(onSaved: settings.updateCustomThemeColors),
                '/reset': (context) => ResetPage(),
                '/fullBackup': (context) => FullBackupPage(),
                '/fullRestore': (context) => FullRestorePage(),
              };
              return MaterialPageRoute(builder: routes[routeSettings.name]!);
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
  late Future<bool> init;

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
    init = _init();
  }

  Future<bool> _init() async {
    if (!initialized) {
      initialized = true;
      final dbPath = await getDatabasesPath();
      await ycash.open(dbPath);
      await zcash.open(dbPath);
      WarpApi.initWallet(dbPath);
      for (var s in settings.servers) {
        WarpApi.updateLWD(s.coin, s.getLWDUrl());
      }
      await accounts.refresh();
      await active.restore();
      await syncStatus.update();
      if (accounts.list.isEmpty) {
        for (var c in settings.coins) {
            syncStatus.markAsSynced(c.coin);
          }
        }

      await initUniLinks(this.context);
      final quickActions = QuickActions();
      quickActions.initialize((type) {
        handleQuickAction(this.context, type);
      });
      if (!settings.linkHooksInitialized) {
        Future.microtask(() {
          final s = S.of(this.context);
          List<ShortcutItem> shortcuts = [];
          for (var c in settings.coins) {
            final coin = c.coin;
            final ticker = c.def.ticker;
            shortcuts.add(ShortcutItem(type: '$coin.receive',
                localizedTitle: s.receive(ticker),
                icon: 'receive'));
            shortcuts.add(ShortcutItem(type: '$coin.send',
                localizedTitle: s.sendCointicker(ticker),
                icon: 'send'));
            }
          quickActions.setShortcutItems(shortcuts);
        });
        await settings.setLinkHooksInitialized();
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LoadProgress(0.7);
          return HomePage();
        });
  }
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

List<ElevatedButton> confirmButtons(BuildContext context,
    VoidCallback? onPressed,
    {String? okLabel, Icon? okIcon, cancelValue}) {
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
                .colorScheme!
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

void showQR(BuildContext context, String text, String title) {
  final s = S.of(context);
  showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) =>
          AlertDialog(
              content: Container(
                  width: double.maxFinite,
                  child: SingleChildScrollView(child: Column(children: [
                    QrImage(data: text, backgroundColor: Colors.white),
                    Padding(padding: EdgeInsets.all(8)),
                    Text(title, style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1),
                    Padding(padding: EdgeInsets.all(4)),
                    ElevatedButton.icon(onPressed: () {
                      Navigator.of(context).pop();
                      Clipboard.setData(ClipboardData(text: text));
                      final snackBar = SnackBar(
                          content: Text(s.textCopiedToClipboard(title)));
                      rootScaffoldMessengerKey.currentState?.showSnackBar(
                          snackBar);
                    }, icon: Icon(Icons.copy), label: Text(s.copy))
                  ])))
          ));
}

Future<bool> rescanDialog(BuildContext context) async {
  final approved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
              title: Text(S
                  .of(context)
                  .rescan),
              content: Text(S
                  .of(context)
                  .rescanWalletFromTheFirstBlock),
              actions: confirmButtons(
                  context, () => Navigator.of(context).pop(true),
                  cancelValue: false))) ?? false;
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
        builder: (context) =>
            AlertDialog(
                title: Text(S
                    .of(context)
                    .rescan),
                content: Text(
                    'On Mobile Data, scanning may incur additional charges. Do you want to proceed?'),
                actions: confirmButtons(
                    context, () => Navigator.of(context).pop(true),
                    cancelValue: false))) ?? false;
  }
  return true;
}

Future<bool> showMessageBox(BuildContext context, String title, String content,
    String label) async {
  final confirm = await showDialog<bool>(
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
  return confirm ?? false;
}

double getScreenSize(BuildContext context) {
  final size = MediaQuery
      .of(context)
      .size;
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
  final coin = activeCoin();
  final style2 = style.copyWith(fontFeatures: [FontFeature.tabularFigures()]);
  if (value >= coin.weights[2])
    return style2.copyWith(fontWeight: FontWeight.w800);
  else if (value >= coin.weights[1])
    return style2.copyWith(fontWeight: FontWeight.w600);
  else if (value >= coin.weights[0])
    return style2.copyWith(fontWeight: FontWeight.w400);
  return style2.copyWith(fontWeight: FontWeight.w200);
}

CurrencyTextInputFormatter makeInputFormatter(bool? mZEC) =>
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
  on FormatException {
    return false;
  }
  return true;
}

int precision(bool? mZEC) => (mZEC == null || mZEC) ? 3 : 8;

Future<String?> scanCode(BuildContext context) async {
  final code = await FlutterBarcodeScanner.scanBarcode('#FF0000', S
      .of(context)
      .cancel, true, ScanMode.QR);
  if (code == "-1") return null;
  return code;
}

String addressLeftTrim(String address) =>
    address != "" ? address.substring(0, 8) + "..." +
        address.substring(address.length - 16) : "";

void showSnackBar(String msg) {
  final snackBar = SnackBar(content: Text(msg));
  rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}

enum DeviceWidth {
  xs,
  sm,
  md,
  lg,
  xl
}

DeviceWidth getWidth(BuildContext context) {
  final width = MediaQuery
      .of(context)
      .size
      .width;
  if (width < 600) return DeviceWidth.xs;
  if (width < 960) return DeviceWidth.sm;
  if (width < 1280) return DeviceWidth.md;
  if (width < 1920) return DeviceWidth.lg;
  return DeviceWidth.xl;
}

String decimalFormat(double x, int decimalDigits, { String symbol = '' }) =>
    NumberFormat.currency(decimalDigits: decimalDigits, symbol: symbol).format(
        x).trimRight();

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
    builder: (context) =>
        AlertDialog(
            title: Text(S
                .of(context)
                .shieldTransparentBalance),
            content: Text(S
                .of(context)
                .doYouWantToTransferYourEntireTransparentBalanceTo(
                activeCoin().ticker)),
            actions: confirmButtons(context, () async {
              final s = S.of(context);
              Navigator.of(context).pop();
              final snackBar1 = SnackBar(content: Text(s.shieldingInProgress));
              rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar1);
              final txid = await WarpApi.shieldTAddr(active.coin, active.id);
              final snackBar2 = SnackBar(content: Text("${s.txId}: $txid"));
              rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar2);
            })),
  );
}

Future<void> shareCsv(List<List> data, String filename, String title) async {
  final csvConverter = ListToCsvConverter();
  final csv = csvConverter.convert(data);
  Directory tempDir = await getTemporaryDirectory();
  String fn = "${tempDir.path}/$filename";
  final file = File(fn);
  await file.writeAsString(csv);
  await Share.shareFiles([fn], subject: title);
}

