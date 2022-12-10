import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';
import './warp_api_generated.dart';
import 'types.dart';

typedef report_callback = Void Function(Int32);

const DAY_MS = 24 * 3600 * 1000;
const DEFAULT_ACCOUNT = 1;

final warp_api_lib = init();

NativeLibrary init() {
  var lib = NativeLibrary(WarpApi.open());
  lib.dart_post_cobject(NativeApi.postCObject.cast());
  return lib;
}

Pointer<Int8> toNative(String s) {
  return s.toNativeUtf8().cast<Int8>();
}

int unwrapResultU8(CResult_u8 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value;
}

int unwrapResultU32(CResult_u32 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value;
}

int unwrapResultU64(CResult_u64 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value;
}

String unwrapResultString(CResult_____c_char r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return convertCString(r.value);
}

class WarpApi {
  static const MethodChannel _channel = const MethodChannel('warp_api');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static DynamicLibrary open() {
    if (Platform.isAndroid) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isIOS) return DynamicLibrary.executable();
    if (Platform.isWindows) return DynamicLibrary.open('warp_api_ffi.dll');
    if (Platform.isLinux) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isMacOS) return DynamicLibrary.open('libwarp_api_ffi.dylib');
    throw UnsupportedError('This platform is not supported.');
  }

  static void createDb(String dbPath) {
    warp_api_lib.create_db(dbPath.toNativeUtf8().cast<Int8>());
  }

  static void migrateWallet(int coin, String dbPath) {
    warp_api_lib.migrate_db(coin, dbPath.toNativeUtf8().cast<Int8>());
  }

  static void migrateData(int coin) {
    warp_api_lib.migrate_data_db(coin);
  }

  static void initWallet(int coin, String dbPath) {
    warp_api_lib.init_wallet(coin, dbPath.toNativeUtf8().cast<Int8>());
  }

  static void resetApp() {
    warp_api_lib.reset_app();
  }

  static void mempoolRun(int port) {
    compute(mempoolRunIsolateFn, port);
  }

  static int newAccount(int coin, String name, String key, int index) {
    return unwrapResultU32(warp_api_lib.new_account(
        coin,
        name.toNativeUtf8().cast<Int8>(),
        key.toNativeUtf8().cast<Int8>(),
        index));
  }

  static void newSubAccount(String name, int index, int count) {
    warp_api_lib.new_sub_account(
        name.toNativeUtf8().cast<Int8>(), index, count);
  }

  static void convertToWatchOnly(int coin, int id) {
    warp_api_lib.convert_to_watchonly(coin, id);
  }

  static Backup getBackup(int coin, int id) {
    final backupStr = unwrapResultString(warp_api_lib.get_backup(coin, id));
    final backupJson = jsonDecode(backupStr);
    return Backup.fromJson(backupJson);
  }

  static String getAddress(int coin, int id, int uaType) {
    final address = warp_api_lib.get_address(coin, id, uaType);
    return unwrapResultString(address);
  }

  static void importTransparentPath(int coin, int id, String path) {
    warp_api_lib.import_transparent_key(
        coin, id, path.toNativeUtf8().cast<Int8>());
  }

  static void importTransparentSecretKey(int coin, int id, String key) {
    warp_api_lib.import_transparent_secret_key(
        coin, id, key.toNativeUtf8().cast<Int8>());
  }

  static void importFromZWL(int coin, String name, String path) {
    warp_api_lib.import_from_zwl(coin, name.toNativeUtf8().cast<Int8>(),
        path.toNativeUtf8().cast<Int8>());
  }

  static void skipToLastHeight(int coin) {
    warp_api_lib.skip_to_last_height(coin);
  }

  static int rewindTo(int height) {
    return unwrapResultU32(warp_api_lib.rewind_to(height));
  }

  static void rescanFrom(int height) {
    warp_api_lib.rescan_from(height);
  }

  static int warpSync(SyncParams params) {
    final res = warp_api_lib.warp(params.coin, params.getTx ? 1 : 0,
        params.anchorOffset, params.maxCost, params.port!.nativePort);
    params.port!.send(null);
    return unwrapResultU8(res);
  }

  static void cancelSync() {
    warp_api_lib.cancel_warp();
  }

  static Future<int> getLatestHeight() async {
    return await compute(getLatestHeightIsolateFn, null);
  }

  static int validKey(int coin, String key) {
    return warp_api_lib.is_valid_key(coin, key.toNativeUtf8().cast<Int8>());
  }

  static bool validAddress(int coin, String address) {
    return warp_api_lib.valid_address(
            coin, address.toNativeUtf8().cast<Int8>()) !=
        0;
  }

  static String newDiversifiedAddress() {
    final address = warp_api_lib.new_diversified_address();
    return unwrapResultString(address);
  }

  static void setActiveAccount(int coin, int account) {
    warp_api_lib.set_active(coin);
    warp_api_lib.set_active_account(coin, account);
    warp_api_lib.mempool_set_active(coin, account);
  }

  // static Future<String> sendPayment(
  //     int coin,
  //     int account,
  //     List<Recipient> recipients,
  //     bool useTransparent,
  //     int anchorOffset,
  //     void Function(int) f) async {
  //   var receivePort = ReceivePort();
  //   receivePort.listen((progress) {
  //     f(progress);
  //   });
  //
  //   final recipientJson = jsonEncode(recipients);
  //
  //   return await compute(
  //       sendPaymentIsolateFn,
  //       PaymentParams(coin, account,
  //           recipientJson, useTransparent, anchorOffset, receivePort.sendPort));
  // }

  static int getTBalance() {
    final balance = warp_api_lib.get_taddr_balance(0xFF, 0);
    return unwrapResultU64(balance);
  }

  static Future<int> getTBalanceAsync(int coin, int account) async {
    final balance =
        await compute(getTBalanceIsolateFn, GetTBalanceParams(coin, account));
    return balance;
  }

  static Future<String> transferPools(int coin, int account, int fromPool, int toPool,
      int amount, String memo, int splitAmount, int anchorOffset) async {
    final txId = await compute(transferPoolsIsolateFn, TransferPoolsParams(coin, account, fromPool, toPool, amount,
        false, memo, splitAmount, anchorOffset));
    return txId;
  }

  static Future<String> shieldTAddr(int coin, int account, int amount, int anchorOffset) async {
    final txId = await compute(shieldTAddrIsolateFn, ShieldTAddrParams(coin, account, amount, anchorOffset));
    return txId;
  }

  static Future<void> scanTransparentAccounts(
      int coin, int account, int gapLimit) async {
    await compute(scanTransparentAccountsParamsIsolateFn,
        ScanTransparentAccountsParams(gapLimit));
  }

  static String prepareTx(int coin, int account,
      List<Recipient> recipients, int anchorOffset) {
    final recipientsJson = jsonEncode(recipients);
    final res = warp_api_lib.prepare_multi_payment(
        coin, account,
        recipientsJson.toNativeUtf8().cast<Int8>(),
        anchorOffset);
    final json = unwrapResultString(res);
    return json;
  }

  static String transactionReport(int coin, String plan) {
    final report = warp_api_lib.transaction_report(coin, plan.toNativeUtf8().cast<Int8>());
    return unwrapResultString(report);
  }

  static String signAndBroadcast (int coin, int account, String plan) {
    final txid = warp_api_lib.sign_and_broadcast(coin, account, plan.toNativeUtf8().cast<Int8>());
    return unwrapResultString(txid);
  }

  static Future<String> signOnly(
      int coin, int account, String tx, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    return await compute(
        signOnlyIsolateFn, SignOnlyParams(coin, account, tx, receivePort.sendPort));
  }

  static String broadcast(String txStr) {
    final res = warp_api_lib.broadcast_tx(txStr.toNativeUtf8().cast<Int8>());
    return unwrapResultString(res);
  }

  // static String ledgerSign(int coin, String txFilename) {
  //   final res = warp_api_lib.ledger_sign(coin, txFilename.toNativeUtf8().cast<Int8>());
  //   return res.cast<Utf8>().toDartString();
  // }

  static DateTime getActivationDate() {
    final res = unwrapResultU32(warp_api_lib.get_activation_date());
    return DateTime.fromMillisecondsSinceEpoch(res * 1000);
  }

  static Future<int> getBlockHeightByTime(DateTime time) async {
    final res = await compute(getBlockHeightByTimeIsolateFn,
        BlockHeightByTimeParams(time.millisecondsSinceEpoch ~/ 1000));
    return res;
  }

  static Future<int> syncHistoricalPrices(String currency) async {
    return await compute(
        syncHistoricalPricesIsolateFn, SyncHistoricalPricesParams(currency));
  }

  static updateLWD(int coin, String url) {
    warp_api_lib.set_coin_lwd_url(coin, url.toNativeUtf8().cast<Int8>());
  }

  static String getLWD(int coin) {
    return convertCString(warp_api_lib.get_lwd_url(coin));
  }

  static void storeContact(int id, String name, String address, bool dirty) {
    warp_api_lib.store_contact(id, name.toNativeUtf8().cast<Int8>(),
        address.toNativeUtf8().cast<Int8>(), dirty ? 1 : 0);
  }

  static Future<String> commitUnsavedContacts(int anchorOffset) async {
    return compute(
        commitUnsavedContactsIsolateFn, CommitContactsParams(anchorOffset));
  }

  static void markMessageAsRead(int messageId, bool read) {
    warp_api_lib.mark_message_read(messageId, read ? 1 : 0);
  }

  static void markAllMessagesAsRead(bool read) {
    warp_api_lib.mark_all_messages_read(read ? 1 : 0);
  }

  static void truncateData() {
    warp_api_lib.truncate_data();
  }

  static void truncateSyncData() {
    warp_api_lib.truncate_sync_data();
  }

  static void deleteAccount(int coin, int account) {
    warp_api_lib.delete_account(coin, account);
  }

  static String makePaymentURI(String address, int amount, String memo) {
    final uri = warp_api_lib.make_payment_uri(
        address.toNativeUtf8().cast<Int8>(),
        amount,
        memo.toNativeUtf8().cast<Int8>());
    return unwrapResultString(uri);
  }

  static String parsePaymentURI(String uri) {
    final json =
        warp_api_lib.parse_payment_uri(uri.toNativeUtf8().cast<Int8>());
    return unwrapResultString(json);
  }

  static AGEKeys generateKey() {
    final key = warp_api_lib.generate_key();
    final json = unwrapResultString(key);
    final ageKeys = AGEKeys.fromJson(jsonDecode(json));
    return ageKeys;
  }

  static void zipBackup(String key, String tmpDir) {
    final r = warp_api_lib.zip_backup(toNative(key), toNative(tmpDir));
    unwrapResultU8(r);
  }

  static void unzipBackup(String key, String path, String tmpDir) {
    warp_api_lib.unzip_backup(toNative(key), toNative(path), toNative(tmpDir));
  }

  static List<String> splitData(int id, String data) {
    final res = unwrapResultString(
        warp_api_lib.split_data(id, data.toNativeUtf8().cast<Int8>()));
    final jsonMap = jsonDecode(res);
    final raptorq = RaptorQDrops.fromJson(jsonMap);
    return raptorq.drops;
  }

  static String mergeData(String drop) {
    return unwrapResultString(
        warp_api_lib.merge_data(drop.toNativeUtf8().cast<Int8>()));
  }

  static String getTxSummary(String tx) {
    return unwrapResultString(
        warp_api_lib.get_tx_summary(tx.toNativeUtf8().cast<Int8>()));
    // TODO: Free
  }

  static String getBestServer(List<String> urls) {
    final servers = Servers(urls);
    final serversJson = jsonEncode(servers);
    final bestServer = unwrapResultString(
        warp_api_lib.get_best_server(serversJson.toNativeUtf8().cast<Int8>()));
    return bestServer;
  }

  static KeyPack deriveZip32(int coin, int idAccount, int accountIndex,
      int externalIndex, int? addressIndex) {
    final res = unwrapResultString(warp_api_lib.derive_zip32(
        coin,
        idAccount,
        accountIndex,
        externalIndex,
        addressIndex != null ? 1 : 0,
        addressIndex ?? 0));
    final jsonMap = jsonDecode(res);
    final kp = KeyPack.fromJson(jsonMap);
    return kp;
  }

  static void disableWAL(String dbPath) {
    warp_api_lib.disable_wal(dbPath.toNativeUtf8().cast<Int8>());
  }

  static bool hasCuda() {
    return warp_api_lib.has_cuda() != 0;
  }

  static bool hasMetal() {
    return warp_api_lib.has_metal() != 0;
  }

  static bool hasGPU() {
    return warp_api_lib.has_gpu() != 0;
  }

  static void useGPU(bool v) {
    warp_api_lib.use_gpu(v ? 1 : 0);
  }
}

String signOnlyIsolateFn(SignOnlyParams params) {
  final txIdRes = warp_api_lib.sign(
      params.coin, params.account,
      params.tx.toNativeUtf8().cast<Int8>(), params.port.nativePort);
  if (txIdRes.error != nullptr) throw convertCString(txIdRes.error);
  return convertCString(txIdRes.value);
}

int getLatestHeightIsolateFn(Null n) {
  return unwrapResultU32(warp_api_lib.get_latest_height());
}

String transferPoolsIsolateFn(TransferPoolsParams params) {
  final txId = warp_api_lib.transfer_pools(params.coin, params.account, params.fromPool, params.toPool,
      params.amount, params.takeFee ? 1 : 0, toNative(params.memo), params.splitAmount, params.anchorOffset);
  return unwrapResultString(txId);
}

String shieldTAddrIsolateFn(ShieldTAddrParams params) {
  final txId = warp_api_lib.shield_taddr(params.coin, params.account, params.amount, params.anchorOffset);
  return unwrapResultString(txId);
}

int syncHistoricalPricesIsolateFn(SyncHistoricalPricesParams params) {
  final now = DateTime.now();
  final today = DateTime.utc(now.year, now.month, now.day);
  return unwrapResultU32(warp_api_lib.sync_historical_prices(
      today.millisecondsSinceEpoch ~/ 1000,
      365,
      params.currency.toNativeUtf8().cast<Int8>()));
}

String commitUnsavedContactsIsolateFn(CommitContactsParams params) {
  final txId = warp_api_lib.commit_unsaved_contacts(params.anchorOffset);
  return unwrapResultString(txId);
}

int getTBalanceIsolateFn(GetTBalanceParams params) {
  return unwrapResultU64(warp_api_lib.get_taddr_balance(params.coin, params.account));
}

int getBlockHeightByTimeIsolateFn(BlockHeightByTimeParams params) {
  return unwrapResultU32(warp_api_lib.get_block_by_time(params.time));
}

void scanTransparentAccountsParamsIsolateFn(
    ScanTransparentAccountsParams params) {
  return warp_api_lib.scan_transparent_accounts(params.gapLimit);
}

class SyncParams {
  final int coin;
  final bool getTx;
  final int anchorOffset;
  final int maxCost;
  final SendPort? port;

  SyncParams(this.coin, this.getTx, this.anchorOffset, this.maxCost, this.port);
}

class PaymentParams {
  final int coin;
  final int account;
  final String recipientsJson;
  final bool useTransparent;
  final int anchorOffset;
  final SendPort port;

  PaymentParams(
      this.coin, this.account, this.recipientsJson, this.useTransparent, this.anchorOffset, this.port);
}

class SignOnlyParams {
  final int coin;
  final int account;
  final String tx;
  final SendPort port;

  SignOnlyParams(this.coin, this.account, this.tx, this.port);
}

class TransferPoolsParams {
  final int coin;
  final int account;
  final int fromPool;
  final int toPool;
  final int amount;
  final bool takeFee;
  final String memo;
  final int splitAmount;
  final int anchorOffset;

  TransferPoolsParams(this.coin, this.account, this.fromPool, this.toPool, this.amount, this.takeFee, this.memo,
      this.splitAmount, this.anchorOffset);
}

class ShieldTAddrParams {
  final int coin;
  final int account;
  final int amount;
  final int anchorOffset;

  ShieldTAddrParams(this.coin, this.account, this.amount, this.anchorOffset);
}

class CommitContactsParams {
  final int anchorOffset;

  CommitContactsParams(this.anchorOffset);
}

class SyncHistoricalPricesParams {
  final String currency;

  SyncHistoricalPricesParams(this.currency);
}

class GetTBalanceParams {
  final int coin;
  final int account;

  GetTBalanceParams(this.coin, this.account);
}

class BlockHeightByTimeParams {
  final int time;

  BlockHeightByTimeParams(this.time);
}

class ScanTransparentAccountsParams {
  final int gapLimit;

  ScanTransparentAccountsParams(this.gapLimit);
}

String convertCString(Pointer<Int8> s) {
  final str = s.cast<Utf8>().toDartString();
  warp_api_lib.deallocate_str(s);
  return str;
}

void mempoolRunIsolateFn(int port) {
  warp_api_lib.mempool_run(port);
}
