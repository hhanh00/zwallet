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

int unwrapResultI64(CResult_i64 r) {
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

  static open() {
    if (Platform.isAndroid) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isIOS) return DynamicLibrary.executable();
    if (Platform.isWindows) return DynamicLibrary.open('warp_api_ffi.dll');
    if (Platform.isLinux) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isMacOS) return DynamicLibrary.open('libwarp_api_ffi.dylib');
    throw UnsupportedError('This platform is not supported.');
  }

  static initWallet(String dbPath) {
    warp_api_lib.init_wallet(dbPath.toNativeUtf8().cast<Int8>());
  }

  static void resetApp() {
    warp_api_lib.reset_app();
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

  static void mempoolReset() {
    warp_api_lib.mempool_reset();
  }

  static Future<int> mempoolSync() async {
    return compute(mempoolSyncIsolateFn, null);
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
  }

  static int getUnconfirmedBalance() {
    return warp_api_lib.get_mempool_balance();
  }

  static Future<String> sendPayment(
      int coin,
      int account,
      List<Recipient> recipients,
      bool useTransparent,
      int anchorOffset,
      void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    final recipientJson = jsonEncode(recipients);

    return await compute(
        sendPaymentIsolateFn,
        PaymentParams(
            recipientJson, useTransparent, anchorOffset, receivePort.sendPort));
  }

  static int getTBalance() {
    final balance = warp_api_lib.get_taddr_balance(0xFF, 0);
    return unwrapResultU64(balance);
  }

  static Future<int> getTBalanceAsync(int coin, int account) async {
    final balance =
        await compute(getTBalanceIsolateFn, GetTBalanceParams(coin, account));
    return balance;
  }

  static Future<String> shieldTAddr() async {
    final txId = await compute(shieldTAddrIsolateFn, null);
    return txId;
  }

  static Future<void> scanTransparentAccounts(
      int coin, int account, int gapLimit) async {
    await compute(scanTransparentAccountsParamsIsolateFn,
        ScanTransparentAccountsParams(gapLimit));
  }

  static String prepareTx(
      List<Recipient> recipients, bool useTransparent, int anchorOffset) {
    final recipientsJson = jsonEncode(recipients);
    final res = warp_api_lib.prepare_multi_payment(
        recipientsJson.toNativeUtf8().cast<Int8>(),
        useTransparent ? 1 : 0,
        anchorOffset);
    final json = unwrapResultString(res);
    return json;
  }

  static Future<String> signOnly(
      int coin, int account, String tx, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    return await compute(
        signOnlyIsolateFn, SignOnlyParams(tx, receivePort.sendPort));
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

  static String generateEncKey() {
    return unwrapResultString(warp_api_lib.generate_random_enc_key());
  }

  static String getFullBackup(String key) {
    final backup =
        warp_api_lib.get_full_backup(key.toNativeUtf8().cast<Int8>());
    return unwrapResultString(backup);
  }

  static void restoreFullBackup(String key, String backup) {
    warp_api_lib.restore_full_backup(
        key.toNativeUtf8().cast<Int8>(), backup.toNativeUtf8().cast<Int8>());
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

  static String getBestServer(List<String> servers) {
    List<Pointer<Int8>> serversAsPointers =
        servers.map((s) => s.toNativeUtf8().cast<Int8>()).toList();
    final Pointer<Pointer<Int8>> serverArray =
        malloc.allocate(sizeOf<Pointer<Utf8>>() * serversAsPointers.length);
    serversAsPointers.asMap().forEach((index, utf) {
      serverArray[index] = serversAsPointers[index];
    });
    final bestServer = unwrapResultString(
        warp_api_lib.get_best_server(serverArray, serversAsPointers.length));
    malloc.free(serverArray);
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

  static void importSyncFile(int coin, String path) {
    warp_api_lib.import_sync_file(coin, path.toNativeUtf8().cast<Int8>());
  }
// // static void storeShareSecret(int coin, int account, String secret) {
// //   warp_api_lib.store_share_secret(coin, account, secret.toNativeUtf8().cast<Int8>());
// // }
// //
// // static Future<void> runAggregator(String secretShare, int port, SendPort sendPort) async {
// //   compute(runAggregatorIsolateFn, RunAggregatorParams(secretShare, port, sendPort.nativePort));
// // }
//
// static Future<String> submitTx(String txJson, int port) async {
//   return await compute(submitTxIsolateFn, SubmitTxParams(txJson, port));
// }
//
// static Future<int> runMultiSigner(String address, int amount, String secretShare, String aggregatorUrl, String myUrl, int port) async {
//   return await compute(runMultiSignerIsolateFn, RunMultiSignerParams(address, amount, secretShare, aggregatorUrl, myUrl, port));
// }
//
// static void stopAggregator() {
//   warp_api_lib.shutdown_aggregator();
// }
//
// static String splitAccount(int coin, int threshold, int participants, int account) {
//   return warp_api_lib.split_account(coin, threshold, participants, account).cast<Utf8>().toDartString();
// }
}

// class RunAggregatorParams {
//   String secretShare;
//   int port;
//   int sendPort;
//   RunAggregatorParams(this.secretShare, this.port, this.sendPort);
// }
//
// void runAggregatorIsolateFn(RunAggregatorParams params) {
//   warp_api_lib.run_aggregator(params.secretShare.toNativeUtf8().cast<Int8>(), params.port, params.sendPort);
// }
//
// class SubmitTxParams {
//   String txJson;
//   int port;
//   SubmitTxParams(this.txJson, this.port);
// }
//
// String submitTxIsolateFn(SubmitTxParams params) {
//   final r = warp_api_lib.submit_multisig_tx(params.txJson.toNativeUtf8().cast<Int8>(), params.port);
//   return r.cast<Utf8>().toDartString();
// }
//
// class RunMultiSignerParams {
//   String address;
//   int amount;
//   String secretShare;
//   String aggregatorUrl;
//   String myUrl;
//   int port;
//   RunMultiSignerParams(this.address, this.amount, this.secretShare, this.aggregatorUrl, this.myUrl, this.port);
// }
//
// int runMultiSignerIsolateFn(RunMultiSignerParams params) {
//   return warp_api_lib.run_multi_signer(
//       params.address.toNativeUtf8().cast<Int8>(), params.amount,
//       params.secretShare.toNativeUtf8().cast<Int8>(),
//       params.aggregatorUrl.toNativeUtf8().cast<Int8>(), params.myUrl.toNativeUtf8().cast<Int8>(), params.port);
// }

String sendPaymentIsolateFn(PaymentParams params) {
  final txId = warp_api_lib.send_multi_payment(
      params.recipientsJson.toNativeUtf8().cast<Int8>(),
      params.anchorOffset,
      params.useTransparent ? 1 : 0,
      params.port.nativePort);
  return unwrapResultString(txId);
}

String signOnlyIsolateFn(SignOnlyParams params) {
  final txIdRes = warp_api_lib.sign(
      params.tx.toNativeUtf8().cast<Int8>(), params.port.nativePort);
  if (txIdRes.error != nullptr) throw convertCString(txIdRes.error);
  return convertCString(txIdRes.value);
}

int getLatestHeightIsolateFn(Null n) {
  return unwrapResultU32(warp_api_lib.get_latest_height());
}

int mempoolSyncIsolateFn(Null n) {
  return unwrapResultI64(warp_api_lib.mempool_sync());
}

String shieldTAddrIsolateFn(Null n) {
  final txId = warp_api_lib.shield_taddr();
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
  final String recipientsJson;
  final bool useTransparent;
  final int anchorOffset;
  final SendPort port;

  PaymentParams(
      this.recipientsJson, this.useTransparent, this.anchorOffset, this.port);
}

class SignOnlyParams {
  final String tx;
  final SendPort port;

  SignOnlyParams(this.tx, this.port);
}

class ShieldTAddrParams {
  final int coin;
  final int account;

  ShieldTAddrParams(this.coin, this.account);
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
