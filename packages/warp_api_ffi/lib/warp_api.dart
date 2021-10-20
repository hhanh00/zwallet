import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';
import './warp_api_generated.dart';

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
  String address;
  int amount;
  String memo;
  int maxAmountPerNote;
  int anchorOffset;
  bool useTransparent;
  SendPort port;

  PaymentParams(this.account, this.address, this.amount, this.memo, this.maxAmountPerNote,
      this.anchorOffset, this.useTransparent, this.port);
}

class MultiPaymentParams {
  int account;
  String recipientJson;
  int anchorOffset;
  SendPort port;

  MultiPaymentParams(this.account, this.recipientJson, this.anchorOffset, this.port);
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

  static bool validKey(String key) {
    return warp_api_lib.is_valid_key(key.toNativeUtf8().cast<Int8>()) != 0;
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

  static Future<String> sendPayment(int account, String address, int amount, String memo,
      int maxAmountPerNote, int anchorOffset, bool useTransparent, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    return await compute(
        sendPaymentIsolateFn,
        PaymentParams(
            account, address, amount, memo, maxAmountPerNote, anchorOffset, useTransparent, receivePort.sendPort));
  }

  static Future<String> sendMultiPayment(int account, String recipientsJson, int anchorOffset, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    return await compute(
        sendMultiPaymentIsolateFn,
        MultiPaymentParams(
            account, recipientsJson, anchorOffset, receivePort.sendPort));
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
    String toAddress,
    int amount,
    String memo,
    int maxAmountPerNote,
    int anchorOffset,
    String txFilename) {
    final res = warp_api_lib.prepare_offline_tx(account,
        toAddress.toNativeUtf8().cast<Int8>(), amount,
        memo.toNativeUtf8().cast<Int8>(), maxAmountPerNote, anchorOffset,
        txFilename.toNativeUtf8().cast<Int8>());
    return res.cast<Utf8>().toDartString();
  }

  static String broadcast(String txFilename) {
    final res = warp_api_lib.broadcast(txFilename.toNativeUtf8().cast<Int8>());
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
}

String sendPaymentIsolateFn(PaymentParams params) {
  final txId = warp_api_lib.send_payment(
      params.account,
      params.address.toNativeUtf8().cast<Int8>(),
      params.amount,
      params.memo.toNativeUtf8().cast<Int8>(),
      params.maxAmountPerNote,
      params.anchorOffset,
      params.useTransparent ? 1 : 0,
      params.port.nativePort);
  return txId.cast<Utf8>().toDartString();
}

String sendMultiPaymentIsolateFn(MultiPaymentParams params) {
  final txId = warp_api_lib.send_multi_payment(
      params.account,
      params.recipientJson.toNativeUtf8().cast<Int8>(),
      params.anchorOffset,
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
  return warp_api_lib.sync_historical_prices(today.millisecondsSinceEpoch ~/ 1000, 370, currency.toNativeUtf8().cast<Int8>());
}

String commitUnsavedContactsIsolateFn(CommitContactsParams params) {
  final txId = warp_api_lib.commit_unsaved_contacts(params.account, params.anchorOffset);
  return txId.cast<Utf8>().toDartString();
}

int getTBalanceIsolateFn(int account) {
  return warp_api_lib.get_taddr_balance(account);
}
