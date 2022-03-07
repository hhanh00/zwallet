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
  int coin;
  bool getTx;
  int anchorOffset;
  SendPort? port;

  SyncParams(this.coin, this.getTx, this.anchorOffset, this.port);
}

class PaymentParams {
  int coin;
  int account;
  String recipientsJson;
  bool useTransparent;
  int anchorOffset;
  SendPort port;

  PaymentParams(this.coin, this.account, this.recipientsJson, this.useTransparent, this.anchorOffset, this.port);
}

class ShieldTAddrParams {
  int coin;
  int account;
  ShieldTAddrParams(this.coin, this.account);
}

class CommitContactsParams {
  int coin;
  int account;
  int anchorOffset;

  CommitContactsParams(this.coin, this.account, this.anchorOffset);
}

class SyncHistoricalPricesParams {
  int coin;
  String currency;
  SyncHistoricalPricesParams(this.coin, this.currency);
}

class GetTBalanceParams {
  int coin;
  int account;
  GetTBalanceParams(this.coin, this.account);
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

  static initWallet(String dbPath) {
    warp_api_lib.init_wallet(
        dbPath.toNativeUtf8().cast<Int8>());
  }

  static void resetApp() {
    warp_api_lib.reset_app();
  }

  static int newAccount(int coin, String name, String key, int index) {
    return warp_api_lib.new_account(coin,
        name.toNativeUtf8().cast<Int8>(), key.toNativeUtf8().cast<Int8>(), index);
  }

  static int newSubAccount(int coin, int accountId, String name) {
    return warp_api_lib.new_sub_account(coin, accountId,
        name.toNativeUtf8().cast<Int8>());
  }

  static void skipToLastHeight(int coin) {
    warp_api_lib.skip_to_last_height(coin);
  }

  static void rewindToHeight(int coin, int height) {
    warp_api_lib.rewind_to_height(coin, height);
  }

  static int warpSync(SyncParams params) {
    final res = warp_api_lib.warp_sync(params.coin, params.getTx ? 1 : 0, params.anchorOffset, params.port!.nativePort);
    params.port!.send(null);
    return res;
  }

  static void mempoolReset(int coin, int height) {
    warp_api_lib.mempool_reset(coin, height);
  }

  static Future<int> mempoolSync(int coin) async {
    return compute(mempoolSyncIsolateFn, coin);
  }

  static Future<int> getLatestHeight(int coin) async {
    return await compute(getLatestHeightIsolateFn, coin);
  }

  static int validKey(int coin, String key) {
    return warp_api_lib.is_valid_key(coin, key.toNativeUtf8().cast<Int8>());
  }

  static bool validAddress(int coin, String address) {
    return warp_api_lib.valid_address(coin, address.toNativeUtf8().cast<Int8>()) != 0;
  }

  static String newAddress(int coin, int account) {
    final address = warp_api_lib.new_address(coin, account);
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

  static void setMempoolAccount(int coin, int account) {
    return warp_api_lib.set_mempool_account(coin, account);
  }

  static int getUnconfirmedBalance(int coin) {
    return warp_api_lib.get_mempool_balance(coin);
  }

  static Future<String> sendPayment(int coin, int account, List<Recipient> recipients, bool useTransparent, int anchorOffset, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    final recipientJson = jsonEncode(recipients);

    return await compute(
        sendPaymentIsolateFn,
        PaymentParams(
            coin, account, recipientJson, useTransparent, anchorOffset, receivePort.sendPort));
  }

  static int getTBalance(int coin, int account) {
    final balance = warp_api_lib.get_taddr_balance(coin, account);
    return balance;
  }

  static Future<int> getTBalanceAsync(int coin, int account) async {
    final balance = await compute(getTBalanceIsolateFn, GetTBalanceParams(coin, account));
    return balance;
  }

  static Future<String> shieldTAddr(int coin, int account) async {
    final txId = compute(shieldTAddrIsolateFn, ShieldTAddrParams(coin, account));
    return txId;
  }

  static String  prepareTx(
    int coin,
    int account,
    List<Recipient> recipients,
    bool useTransparent,
    int anchorOffset,
    String txFilename) {
    final recipientsJson = jsonEncode(recipients);
    final res = warp_api_lib.prepare_multi_payment(coin, account,
        recipientsJson.toNativeUtf8().cast<Int8>(),
        useTransparent ? 1 : 0, anchorOffset);
    return res.cast<Utf8>().toDartString();
  }

  static String broadcast(int coin, String txFilename) {
    final res = warp_api_lib.broadcast(coin, txFilename.toNativeUtf8().cast<Int8>());
    return res.cast<Utf8>().toDartString();
  }

  static String broadcastHex(int coin, String tx) {
    final res = warp_api_lib.broadcast_txhex(coin, tx.toNativeUtf8().cast<Int8>());
    return res.cast<Utf8>().toDartString();
  }

  static Future<int> syncHistoricalPrices(int coin, String currency) async {
    return await compute(syncHistoricalPricesIsolateFn, SyncHistoricalPricesParams(coin, currency));
  }
  
  static updateLWD(int coin, String url) {
    warp_api_lib.set_lwd_url(coin, url.toNativeUtf8().cast<Int8>());
  }

  static void storeContact(int coin, int id, String name, String address, bool dirty) {
    warp_api_lib.store_contact(coin, id, name.toNativeUtf8().cast<Int8>(), address.toNativeUtf8().cast<Int8>(), dirty ? 1 : 0);
  }

  static Future<String> commitUnsavedContacts(int coin, int account, int anchorOffset) async {
    return compute(commitUnsavedContactsIsolateFn, CommitContactsParams(coin, account, anchorOffset));
  }

  static void truncateData(int coin) {
    warp_api_lib.truncate_data(coin);
  }

  static void deleteAccount(int coin, int account) {
    warp_api_lib.delete_account(coin, account);
  }

  static String makePaymentURI(int coin, String address, int amount, String memo) {
    final uri = warp_api_lib.make_payment_uri(
        coin,
        address.toNativeUtf8().cast<Int8>(),
        amount,
        memo.toNativeUtf8().cast<Int8>());
    return uri.cast<Utf8>().toDartString();
  }

  static String parsePaymentURI(int coin, String uri) {
    final json = warp_api_lib.parse_payment_uri(
        coin,
        uri.toNativeUtf8().cast<Int8>());
    return json.cast<Utf8>().toDartString();
  }

  static String generateEncKey() {
    return warp_api_lib.generate_random_enc_key().cast<Utf8>().toDartString();
  }

  static String getFullBackup(String key) {
    final backup = warp_api_lib.get_full_backup(key.toNativeUtf8().cast<Int8>());
    return backup.cast<Utf8>().toDartString();
  }

  static String restoreFullBackup(String key, String backup) {
    final res = warp_api_lib.restore_full_backup(key.toNativeUtf8().cast<Int8>(), backup.toNativeUtf8().cast<Int8>());
    return res.cast<Utf8>().toDartString();
  }

  static void storeShareSecret(int coin, int account, String secret) {
    warp_api_lib.store_share_secret(coin, account, secret.toNativeUtf8().cast<Int8>());
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

  static String splitAccount(int coin, int threshold, int participants, int account) {
    return warp_api_lib.split_account(coin, threshold, participants, account).cast<Utf8>().toDartString();
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
      params.coin,
      params.account,
      params.recipientsJson.toNativeUtf8().cast<Int8>(),
      params.anchorOffset,
      params.useTransparent ? 1 : 0,
      params.port.nativePort);
  return txId.cast<Utf8>().toDartString();
}

int getLatestHeightIsolateFn(int coin) {
  return warp_api_lib.get_latest_height(coin);
}

int mempoolSyncIsolateFn(int coin) {
  return warp_api_lib.mempool_sync(coin);
}

String shieldTAddrIsolateFn(ShieldTAddrParams params) {
  final txId = warp_api_lib.shield_taddr(params.coin, params.account);
  return txId.cast<Utf8>().toDartString();
}

int syncHistoricalPricesIsolateFn(SyncHistoricalPricesParams params) {
  final now = DateTime.now();
  final today = DateTime.utc(now.year, now.month, now.day);
  return warp_api_lib.sync_historical_prices(params.coin, today.millisecondsSinceEpoch ~/ 1000, 365, params.currency.toNativeUtf8().cast<Int8>());
}

String commitUnsavedContactsIsolateFn(CommitContactsParams params) {
  final txId = warp_api_lib.commit_unsaved_contacts(params.coin, params.account, params.anchorOffset);
  return txId.cast<Utf8>().toDartString();
}

int getTBalanceIsolateFn(GetTBalanceParams params) {
  return warp_api_lib.get_taddr_balance(params.coin, params.account);
}

