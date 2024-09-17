import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:decimal/decimal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:key_guardmanager/key_guardmanager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart'
    show VxNullableStringIsEmptyOrNullExtension;
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../accounts.dart';
import '../appsettings.dart';
import '../coin/coins.dart';
import '../generated/intl/messages.dart';
import '../main.dart';
import '../router.dart';
import '../store.dart';
import 'widgets.dart';

var logger = Logger();

const APP_NAME = "YWallet";
const ZECUNIT = 100000000.0;
const ZECUNIT_INT = 100000000;
const MAX_PRECISION = 8;
const DAY_MS = 24 * 3600 * 1000;
const MAXHEIGHT = 4000000000;

final DateFormat noteDateFormat = DateFormat("yy-MM-dd HH:mm");
final DateFormat txDateFormat = DateFormat("MM-dd HH:mm");
final DateFormat msgDateFormat = DateFormat("MM-dd HH:mm");
final DateFormat msgDateFormatFull = DateFormat("yy-MM-dd HH:mm:ss");

int decimalDigits(bool fullPrec) => fullPrec ? MAX_PRECISION : 3;
String decimalFormat(double x, int decimalDigits, {String symbol = ''}) {
  return NumberFormat.currency(
    locale: Platform.localeName,
    decimalDigits: decimalDigits,
    symbol: symbol,
  ).format(x).trimRight();
}

String decimalToString(double x) =>
    decimalFormat(x, decimalDigits(appSettings.fullPrec));

Future<bool> showMessageBox2(BuildContext context, String title, String content,
    {String? label, bool dismissable = true}) async {
  final s = S.of(context);
  final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(content), actions: [
            if (dismissable)
              ElevatedButton.icon(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: Icon(Icons.check),
                  label: Text(label ?? s.ok))
          ]));
  return confirm ?? false;
}

mixin WithLoadingAnimation<T extends StatefulWidget> on State<T> {
  bool loading = false;

  Widget wrapWithLoading(Widget child) {
    return LoadingWrapper(loading, child: child);
  }

  Future<U> load<U>(Future<U> Function() calc) async {
    try {
      setLoading(true);
      return await calc();
    } finally {
      setLoading(false);
    }
  }

  setLoading(bool v) {
    if (mounted) setState(() => loading = v);
  }
}

Future<void> showSnackBar(String msg) async {
  final bar = FlushbarHelper.createInformation(
      message: msg, duration: Duration(seconds: 4));
  await bar.show(rootNavigatorKey.currentContext!);
}

void openTxInExplorer(String txId) async {
  final settings = await CoinSettingsExtension.load(aa.coin);
  final url = settings.resolveBlockExplorer(aa.coin);
  launchUrl(Uri.parse("$url/$txId"), mode: LaunchMode.inAppWebView);
}

String? addressOrUriValidator(String? v) {
  final s = S.of(rootNavigatorKey.currentContext!);
  if (v == null || v.isEmpty) return s.addressIsEmpty;
  if (warp.isValidAddressOrUri(aa.coin, v) == 0)
    return s.invalidAddress;
  return null;
}

String? addressValidator(String? v) {
  final s = S.of(rootNavigatorKey.currentContext!);
  if (v == null || v.isEmpty) return s.addressIsEmpty;
  try {
    warp.decodeAddress(aa.coin, v);
  } on String catch (e) {
    logger.d(e);
    return s.invalidAddress;
  }
  return null;
}

String? paymentURIValidator(String? v) {
  final s = S.of(rootNavigatorKey.currentContext!);
  if (v.isEmptyOrNull) return s.required;
  try {
    warp.parsePaymentURI(aa.coin, v!);
  }
  catch (_) {
    return s.invalidPaymentURI;
  }
  return null;
}

ColorPalette getPalette(Color color, int n) => ColorPalette.polyad(
      color,
      numberOfColors: max(n, 1),
      hueVariability: 15,
      saturationVariability: 10,
      brightnessVariability: 10,
    );

int numPoolsOf(int v) => Uint8(v).bitsSet;

int poolOf(int v) {
  switch (v) {
    case 1:
      return 0;
    case 2:
      return 1;
    case 4:
      return 2;
    default:
      return 0;
  }
}

Future<bool> authBarrier(BuildContext context,
    {bool dismissable = false}) async {
  final s = S.of(context);
  while (true) {
    final authed = await authenticate(context, s.pleaseAuthenticate);
    if (authed) return true;
    if (dismissable) return false;
  }
}

Future<bool> authenticate(BuildContext context, String reason) async {
  final s = S.of(context);
  if (!isMobile()) {
    if (appStore.dbPassword.isEmpty) return true;
    final formKey = GlobalKey<FormBuilderState>();
    final passwdController = TextEditingController();
    final authed = await showAdaptiveDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: Text(s.pleaseAuthenticate),
                content: Card(
                    child: FormBuilder(
                        key: formKey,
                        child: FormBuilderTextField(
                          name: 'passwd',
                          decoration:
                              InputDecoration(label: Text(s.databasePassword)),
                          controller: passwdController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            (v) => v != appStore.dbPassword
                                ? s.invalidPassword
                                : null,
                          ]),
                          obscureText: true,
                        ))),
                actions: [
                  IconButton(
                      onPressed: () => GoRouter.of(context).pop(false),
                      icon: Icon(Icons.cancel)),
                  IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate())
                          GoRouter.of(context).pop(true);
                      },
                      icon: Icon(Icons.check)),
                ],
              );
            }) ??
        false;
    return authed;
  }

  final localAuth = LocalAuthentication();
  try {
    final bool didAuthenticate;
    if (Platform.isAndroid && !await localAuth.canCheckBiometrics) {
      didAuthenticate = await KeyGuardmanager.authStatus == "true";
    } else {
      didAuthenticate = await localAuth.authenticate(
          localizedReason: reason, options: AuthenticationOptions());
    }
    if (didAuthenticate) {
      return true;
    }
  } on PlatformException catch (e) {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).noAuthenticationMethod),
            content: Text(e.message ?? '')));
  }
  return false;
}

int now() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

void handleAccel(AccelerometerEvent event) {
  final n = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  final inclination = acos(event.z / n) / pi * 180 * event.y.sign;
  final flat = inclination < 20
      ? true
      : inclination > 40
          ? false
          : null;
  flat?.let((f) {
    if (f != appStore.flat) appStore.flat = f;
  });
}

double getScreenSize(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return min(size.height - 200, size.width);
}

Future<FilePickerResult?> pickFile() async {
  if (isMobile()) {
    await FilePicker.platform.clearTemporaryFiles();
  }
  final result = await FilePicker.platform.pickFiles();
  return result;
}

Future<void> saveFileBinary(
    List<int> data, String filename, String title) async {
  if (isMobile()) {
    final context = rootNavigatorKey.currentContext!;
    Size size = MediaQuery.of(context).size;
    final tempDir = await getTempPath();
    final path = p.join(tempDir, filename);
    final xfile = XFile(path);
    final file = File(path);
    await file.writeAsBytes(data);
    await Share.shareXFiles([xfile],
        subject: title,
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  } else {
    final fn = await FilePicker.platform
        .saveFile(dialogTitle: title, fileName: filename);
    if (fn != null) {
      final file = File(fn);
      await file.writeAsBytes(data);
    }
  }
}

int getSpendable(int pools, BalanceT balances) {
  return (pools & 1 != 0 ? balances.transparent : 0) +
      (pools & 2 != 0 ? balances.sapling : 0) +
      (pools & 4 != 0 ? balances.orchard : 0);
}

class MemoData {
  bool reply;
  String subject;
  String memo;
  MemoData(this.reply, this.subject, this.memo);

  MemoData clone() => MemoData(reply, subject, memo);
}

extension ScopeFunctions<T> on T {
  R let<R>(R Function(T) block) => block(this);
}

Future<bool> showConfirmDialog(
    BuildContext context, String title, String body) async {
  final s = S.of(context);

  void close(bool res) {
    GoRouter.of(context).pop<bool>(res);
  }

  final confirmation = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              AlertDialog(title: Text(title), content: Text(body), actions: [
                ElevatedButton.icon(
                    onPressed: () => close(false),
                    icon: Icon(Icons.cancel),
                    label: Text(s.cancel)),
                ElevatedButton.icon(
                    onPressed: () => close(true),
                    icon: Icon(Icons.check),
                    label: Text(s.ok)),
              ])) ??
      false;
  return confirmation;
}

Decimal parseNumber(String? sn) {
  if (sn == null || sn.isEmpty) return Decimal.zero;
  // There is no API to parse directly from intl string
  final v = NumberFormat.currency(locale: Platform.localeName).parse(sn);
  return Decimal.parse(v.toStringAsFixed(8));
}

int stringToAmount(String? s) {
  final v = parseNumber(s);
  return (ZECUNIT_DECIMAL * v).toBigInt().toInt();
}

String amountToString2(int amount, {int? digits}) {
  final dd = digits ?? decimalDigits(appSettings.fullPrec);
  return decimalFormat(amount / ZECUNIT, dd);
}

Future<void> saveFile(String data, String filename, String title) async {
  await saveFileBinary(utf8.encode(data), filename, title);
}

String centerTrim(String v, {int leading = 2, int length = 16}) {
  if (v.length <= length) return v;
  final e = v.length - length + leading;
  return v.substring(0, leading) + '...' + v.substring(e);
}

// String trailing(String v, int n) {
//   final len = min(n, v.length);
//   return v.substring(v.length - len);
// }

String getPrivacyLevel(BuildContext context, int level) {
  final s = S.of(context);
  final privacyLevels = [s.veryLow, s.low, s.medium, s.high];
  return privacyLevels[level];
}

bool isMobile() => Platform.isAndroid || Platform.isIOS;

Future<String> getDataPath() async {
  String? home;
  if (Platform.isAndroid)
    home = (await getApplicationDocumentsDirectory()).parent.path;
  if (Platform.isWindows) home = Platform.environment['LOCALAPPDATA'];
  if (Platform.isLinux)
    home =
        Platform.environment['XDG_DATA_HOME'] ?? Platform.environment['HOME'];
  if (Platform.isMacOS) home = (await getApplicationSupportDirectory()).path;
  final h = home ?? "";
  return h;
}

Future<String> getTempPath() async {
  if (isMobile()) {
    final d = await getTemporaryDirectory();
    return d.path;
  }
  final dataPath = await getDataPath();
  final tempPath = p.join(dataPath, "tmp");
  Directory(tempPath).createSync(recursive: true);
  return tempPath;
}

Future<String> getDbPath() async {
  if (Platform.isIOS) return (await getApplicationDocumentsDirectory()).path;
  final h = await getDataPath();
  return "$h/databases";
}

abstract class HasHeight {
  int height = 0;
}

class Reflector extends Reflectable {
  const Reflector() : super(instanceInvokeCapability);
}

const reflector = const Reflector();

@reflector
class Note extends HasHeight {
  int id;
  int height;
  int? confirmations;
  DateTime timestamp;
  double value;
  bool orchard;
  bool excluded;
  bool selected;

  factory Note.from(int? latestHeight, int id, int height, DateTime timestamp,
      double value, bool orchard, bool excluded, bool selected) {
    final confirmations = latestHeight?.let((h) => h - height + 1);
    return Note(id, height, confirmations, timestamp, value, orchard, excluded, selected);
  }

  Note(this.id, this.height, this.confirmations, this.timestamp, this.value,
      this.orchard, this.excluded, this.selected);

  Note get invertExcluded =>
      Note(id, height, confirmations, timestamp, value, orchard, !excluded, selected);

  Note clone() => Note(id, height, confirmations, timestamp, value, orchard, excluded, selected);
}

@reflector
class Tx extends HasHeight {
  int id;
  int height;
  int? confirmations;
  DateTime timestamp;
  String txId;
  String fullTxId;
  int value;
  String? address;
  String? contact;
  String memo;

  factory Tx.from(
      int? latestHeight,
      int id,
      int height,
      DateTime timestamp,
      String txid,
      String fullTxId,
      int value,
      String? address,
      String? contact,
      String memo,
      ) {
    final confirmations = latestHeight?.let((h) => h - height + 1);
    return Tx(id, height, confirmations, timestamp, txid, fullTxId, value,
        address, contact, memo);
  }

  Tx(this.id, this.height, this.confirmations, this.timestamp, this.txId,
      this.fullTxId, this.value, this.address, this.contact, this.memo);
}

class ZMessage extends HasHeight {
  final int id;
  final int txId;
  final bool incoming;
  final String? fromAddress;
  final String? sender;
  final String recipient;
  final String subject;
  final String body;
  final DateTime timestamp;
  final int height;
  final bool read;

  ZMessage(
      this.id,
      this.txId,
      this.incoming,
      this.fromAddress,
      this.sender,
      this.recipient,
      this.subject,
      this.body,
      this.timestamp,
      this.height,
      this.read);

  ZMessage withRead(bool v) {
    return ZMessage(id, txId, incoming, fromAddress, sender, recipient, subject,
        body, timestamp, height, v);
  }

  String fromto() => incoming
      ? "\u{21e6} ${sender != null ? centerTrim(sender!) : ''}"
      : "\u{21e8} ${centerTrim(recipient)}";
}

class PnL {
  final DateTime timestamp;
  final double price;
  final double amount;
  final double realized;
  final double unrealized;

  PnL(this.timestamp, this.price, this.amount, this.realized, this.unrealized);

  @override
  String toString() {
    return "$timestamp $price $amount $realized $unrealized";
  }
}

Color amountColor(BuildContext context, num a) {
  final theme = Theme.of(context);
  if (a < 0) return Colors.red;
  if (a > 0) return Colors.green;
  return theme.textTheme.bodyLarge!.color!;
}

TextStyle weightFromAmount(TextStyle style, num v) {
  final value = v.abs();
  final coin = coins[aa.coin];
  final style2 = style.copyWith(fontFeatures: [FontFeature.tabularFigures()]);
  if (value >= coin.weights[2])
    return style2.copyWith(fontWeight: FontWeight.w800);
  else if (value >= coin.weights[1])
    return style2.copyWith(fontWeight: FontWeight.w600);
  else if (value >= coin.weights[0])
    return style2.copyWith(fontWeight: FontWeight.w400);
  return style2.copyWith(fontWeight: FontWeight.w200);
}

final DateFormat todayDateFormat = DateFormat("HH:mm");
final DateFormat monthDateFormat = DateFormat("MMMd");
final DateFormat longAgoDateFormat = DateFormat("yy-MM-dd");

String humanizeDateTime(BuildContext context, DateTime datetime) {
  final messageDate = datetime.toLocal();
  final now = DateTime.now();
  final justNow = now.subtract(Duration(minutes: 1));
  final midnight = DateTime(now.year, now.month, now.day);
  final year = DateTime(now.year, 1, 1);

  String dateString;
  if (justNow.isBefore(messageDate))
    dateString = S.of(context).now;
  else if (midnight.isBefore(messageDate))
    dateString = todayDateFormat.format(messageDate);
  else if (year.isBefore(messageDate))
    dateString = monthDateFormat.format(messageDate);
  else
    dateString = longAgoDateFormat.format(messageDate);
  return dateString;
}

Future<double?> getFxRate(String coin, String fiat) async {
  final base = "api.coingecko.com";
  final uri = Uri.https(
      base, '/api/v3/simple/price', {'ids': coin, 'vs_currencies': fiat});
  try {
    final rep = await http.get(uri);
    if (rep.statusCode == 200) {
      final json = convert.jsonDecode(rep.body) as Map<String, dynamic>;
      final p = json[coin][fiat.toLowerCase()];
      return (p is double) ? p : (p as int).toDouble();
    }
  } catch (e) {
    logger.e(e);
  }
  return null;
}

class TimeSeriesPoint<V> {
  final int day;
  final V value;

  TimeSeriesPoint(this.day, this.value);

  @override
  String toString() => '($day, $value)';
}

class AccountBalance {
  final DateTime time;
  final double balance;

  AccountBalance(this.time, this.balance);
  @override
  String toString() => "($time $balance)";
}

const DAY_SEC = 24 * 3600;

List<TimeSeriesPoint<V>> sampleDaily<T, Y, V>(
    Iterable<T> timeseries,
    int start,
    int end,
    int Function(T) getDay,
    Y Function(T) getY,
    V Function(V, Y) accFn,
    V initial) {
  assert(start % DAY_SEC == 0);
  final s = start ~/ DAY_SEC;
  final e = end ~/ DAY_SEC;

  List<TimeSeriesPoint<V>> ts = [];
  var acc = initial;

  var tsIterator = timeseries.iterator;
  var next = tsIterator.moveNext() ? tsIterator.current : null;
  var nextDay = next?.let((n) => getDay(n));

  for (var day = s; day <= e; day++) {
    while (nextDay != null && day == nextDay) {
      // accumulate
      acc = accFn(acc, getY(next!));
      next = tsIterator.moveNext() ? tsIterator.current : null;
      nextDay = next?.let((n) => getDay(n));
    }
    ts.add(TimeSeriesPoint(day, acc));
  }
  return ts;
}

class Quote {
  final DateTime dt;
  final price;

  Quote(this.dt, this.price);
}

class Trade {
  final DateTime dt;
  final qty;

  Trade(this.dt, this.qty);
}

FormFieldValidator<T> composeOr<T>(List<FormFieldValidator<T>> validators) {
  return (v) {
    String? first;
    for (var validator in validators) {
      final res = validator.call(v);
      if (res == null) return null;
      if (first == null) first = res;
    }
    return first;
  };
}

class PoolBitSet {
  static Set<int> toSet(int pools) {
    return List.generate(3, (index) => pools & (1 << index) != 0 ? index : null)
        .whereNotNull()
        .toSet();
  }

  static int fromSet(Set<int> poolSet) => poolSet.map((p) => 1 << p).sum;
}

List<AccountNameT> getAllAccounts() {
  var accounts = <AccountNameT>[];
  for (var coin in coins) {
    final a = warp.listAccounts(coin.coin);
    accounts.addAll(a);
  }
  return accounts;
}

void showLocalNotification({required int id, String? title, String? body}) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    channelKey: APP_NAME,
    id: id,
    title: title,
    body: body,
  ));
}

extension PoolBalanceExtension on BalanceT {
  int get total => transparent + sapling + orchard;
}

String? isValidUA(int uaType) {
  if (uaType == 1) return GetIt.I<S>().invalidAddress;
  return null;
}

