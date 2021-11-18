import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:convert/convert.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';
import './warp_api_generated.dart';
import 'types.dart';

typedef report_callback = Void Function(Int32);
const DAY_MS = 24 * 3600 * 1000;

class SyncParams {
  bool getTx;
  int anchorOffset;
  SendPort? port;

  SyncParams(this.getTx, this.anchorOffset, this.port);
}

class PaymentParams {
  int account;
  String recipientsJson;
  bool useTransparent;
  int anchorOffset;
  SendPort port;

  PaymentParams(this.account, this.recipientsJson, this.useTransparent, this.anchorOffset, this.port);
}

class CommitContactsParams {
  int account;
  int anchorOffset;

  CommitContactsParams(this.account, this.anchorOffset);
}

const DEFAULT_ACCOUNT = 1;

final warp_api_lib = init();

NativeLibrary init() {
  var lib = NativeLibrary(WarpApi.open());
  lib.dart_post_cobject(NativeApi.postCObject.cast());
  return lib;
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
    throw UnsupportedError('This platform is not supported.');
  }

  static initWallet(String dbPath, String ldUrl) {
    warp_api_lib.init_wallet(
        dbPath.toNativeUtf8().cast<Int8>(), ldUrl.toNativeUtf8().cast<Int8>());
  }

  static int newAccount(String name, String key) {
    return warp_api_lib.new_account(
        name.toNativeUtf8().cast<Int8>(), key.toNativeUtf8().cast<Int8>());
  }

  static void skipToLastHeight() {
    warp_api_lib.skip_to_last_height();
  }

  static void rewindToHeight(int height) {
    warp_api_lib.rewind_to_height(height);
  }

  static void warpSync(SyncParams params) {
    warp_api_lib.warp_sync(params.getTx ? 1 : 0, params.anchorOffset, params.port!.nativePort);
    params.port!.send(-1);
  }

  static Future<int> tryWarpSync(bool getTx, int anchorOffset) async {
    final res = await compute(tryWarpSyncIsolateFn, SyncParams(getTx, anchorOffset, null));
    return res;
  }

  static void mempoolReset(int height) {
    warp_api_lib.mempool_reset(height);
  }

  static Future<int> mempoolSync() async {
    return compute(mempoolSyncIsolateFn, null);
  }

  static Future<int> getLatestHeight() async {
    return await compute(getLatestHeightIsolateFn, null);
  }

  static int validKey(String key) {
    return warp_api_lib.is_valid_key(key.toNativeUtf8().cast<Int8>());
  }

  static bool validAddress(String address) {
    return warp_api_lib.valid_address(address.toNativeUtf8().cast<Int8>()) != 0;
  }

  static String newAddress(int account) {
    final address = warp_api_lib.new_address(account);
    return address.cast<Utf8>().toDartString();
  }

  static String getUA(String zaddress, String taddress) {
    final ua = warp_api_lib.get_ua(zaddress.toNativeUtf8().cast<Int8>(), taddress.toNativeUtf8().cast<Int8>());
    return ua.cast<Utf8>().toDartString();
  }

  static String getSaplingFromUA(String ua) {
    final zaddr = warp_api_lib.get_sapling(ua.toNativeUtf8().cast<Int8>());
    return zaddr.cast<Utf8>().toDartString();
  }

  static void setMempoolAccount(int account) {
    return warp_api_lib.set_mempool_account(account);
  }

  static int getUnconfirmedBalance() {
    return warp_api_lib.get_mempool_balance();
  }

  static Future<String> sendPayment(int account, List<Recipient> recipients, bool useTransparent, int anchorOffset, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    final recipientJson = jsonEncode(recipients);

    return await compute(
        sendPaymentIsolateFn,
        PaymentParams(
            account, recipientJson, useTransparent, anchorOffset, receivePort.sendPort));
  }

  static int getTBalance(int account) {
    final balance = warp_api_lib.get_taddr_balance(account);
    return balance;
  }

  static Future<int> getTBalanceAsync(int account) async {
    final balance = await compute(getTBalanceIsolateFn, account);
    return balance;
  }

  static Future<String> shieldTAddr(int account) async {
    final txId = compute(shieldTAddrIsolateFn, account);
    return txId;
  }

  static String  prepareTx(
    int account,
    List<Recipient> recipients,
    bool useTransparent,
    int anchorOffset,
    String txFilename) {
    final recipientsJson = jsonEncode(recipients);
    final res = warp_api_lib.prepare_multi_payment(account,
        recipientsJson.toNativeUtf8().cast<Int8>(),
        useTransparent ? 1 : 0, anchorOffset);
    return res.cast<Utf8>().toDartString();
  }

  static String broadcast(String txFilename) {
    final res = warp_api_lib.broadcast(txFilename.toNativeUtf8().cast<Int8>());
    return res.cast<Utf8>().toDartString();
  }

  static String broadcastHex(String tx) {
    final res = warp_api_lib.broadcast_txhex(tx.toNativeUtf8().cast<Int8>());
    return res.cast<Utf8>().toDartString();
  }

  static Future<int> syncHistoricalPrices(String currency) async {
    return await compute(syncHistoricalPricesIsolateFn, currency);
  }
  
  static updateLWD(String url) {
    warp_api_lib.set_lwd_url(url.toNativeUtf8().cast<Int8>());
  }

  static void storeContact(int id, String name, String address, bool dirty) {
    warp_api_lib.store_contact(id, name.toNativeUtf8().cast<Int8>(), address.toNativeUtf8().cast<Int8>(), dirty ? 1 : 0);
  }

  static Future<String> commitUnsavedContacts(int account, int anchorOffset) async {
    return compute(commitUnsavedContactsIsolateFn, CommitContactsParams(account, anchorOffset));
  }

  static void truncateData() {
    warp_api_lib.truncate_data();
  }

  static void deleteAccount(int account) {
    warp_api_lib.delete_account(account);
  }

  static String makePaymentURI(String address, int amount, String memo) {
    final uri = warp_api_lib.make_payment_uri(
        address.toNativeUtf8().cast<Int8>(),
        amount,
        memo.toNativeUtf8().cast<Int8>());
    return uri.cast<Utf8>().toDartString();
  }

  static String parsePaymentURI(String uri) {
    final json = warp_api_lib.parse_payment_uri(
        uri.toNativeUtf8().cast<Int8>());
    return json.cast<Utf8>().toDartString();
  }

  static void storeShareSecret(int account, String secret) {
    warp_api_lib.store_share_secret(account, secret.toNativeUtf8().cast<Int8>());
  }

  static Future<void> runAggregator(String secretShare, int port, SendPort sendPort) async {
    compute(runAggregatorIsolateFn, RunAggregatorParams(secretShare, port, sendPort.nativePort));
  }

  static Future<String> submitTx(String txJson, int port) async {
    return await compute(submitTxIsolateFn, SubmitTxParams(txJson, port));
  }

  static Future<int> runMultiSigner(String address, int amount, String secretShare, String aggregatorUrl, String myUrl, int port) async {
    return await compute(runMultiSignerIsolateFn, RunMultiSignerParams(address, amount, secretShare, aggregatorUrl, myUrl, port));
  }

  static void stopAggregator() {
    warp_api_lib.shutdown_aggregator();
  }

  static String splitAccount(int threshold, int participants, int account) {
    return warp_api_lib.split_account(threshold, participants, account).cast<Utf8>().toDartString();
  }
}

class RunAggregatorParams {
  String secretShare;
  int port;
  int sendPort;
  RunAggregatorParams(this.secretShare, this.port, this.sendPort);
}

void runAggregatorIsolateFn(RunAggregatorParams params) {
  warp_api_lib.run_aggregator(params.secretShare.toNativeUtf8().cast<Int8>(), params.port, params.sendPort);
}

class SubmitTxParams {
  String txJson;
  int port;
  SubmitTxParams(this.txJson, this.port);
}

String submitTxIsolateFn(SubmitTxParams params) {
  final r = warp_api_lib.submit_multisig_tx(params.txJson.toNativeUtf8().cast<Int8>(), params.port);
  return r.cast<Utf8>().toDartString();
}

class RunMultiSignerParams {
  String address;
  int amount;
  String secretShare;
  String aggregatorUrl;
  String myUrl;
  int port;
  RunMultiSignerParams(this.address, this.amount, this.secretShare, this.aggregatorUrl, this.myUrl, this.port);
}

int runMultiSignerIsolateFn(RunMultiSignerParams params) {
  return warp_api_lib.run_multi_signer(
      params.address.toNativeUtf8().cast<Int8>(), params.amount,
      params.secretShare.toNativeUtf8().cast<Int8>(),
      params.aggregatorUrl.toNativeUtf8().cast<Int8>(), params.myUrl.toNativeUtf8().cast<Int8>(), params.port);
}

String sendPaymentIsolateFn(PaymentParams params) {
  final txId = warp_api_lib.send_multi_payment(
      params.account,
      params.recipientsJson.toNativeUtf8().cast<Int8>(),
      params.anchorOffset,
      params.useTransparent ? 1 : 0,
      params.port.nativePort);
  return txId.cast<Utf8>().toDartString();
}

int tryWarpSyncIsolateFn(SyncParams params) {
  return warp_api_lib.try_warp_sync(params.getTx ? 1 : 0, params.anchorOffset);
}

int getLatestHeightIsolateFn(Null _dummy) {
  return warp_api_lib.get_latest_height();
}

int mempoolSyncIsolateFn(Null _dummy) {
  return warp_api_lib.mempool_sync();
}

String shieldTAddrIsolateFn(int account) {
  final txId = warp_api_lib.shield_taddr(account);
  return txId.cast<Utf8>().toDartString();
}

int syncHistoricalPricesIsolateFn(String currency) {
  final now = DateTime.now();
  final today = DateTime.utc(now.year, now.month, now.day);
  return warp_api_lib.sync_historical_prices(today.millisecondsSinceEpoch ~/ 1000, 365, currency.toNativeUtf8().cast<Int8>());
}

String commitUnsavedContactsIsolateFn(CommitContactsParams params) {
  final txId = warp_api_lib.commit_unsaved_contacts(params.account, params.anchorOffset);
  return txId.cast<Utf8>().toDartString();
}

int getTBalanceIsolateFn(int account) {
  return warp_api_lib.get_taddr_balance(account);
}

