import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';
import './warp_api_generated.dart';

typedef report_callback = Void Function(Int32);

class SyncParams {
  SendPort port;

  SyncParams(this.port);
}

class PaymentParams {
  int account;
  String address;
  int amount;
  int maxAmountPerNote;
  int anchorOffset;
  SendPort port;

  PaymentParams(this.account, this.address, this.amount, this.maxAmountPerNote,
      this.anchorOffset, this.port);
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

  static void warpSync(void Function(int) f) {
    var receivePort = ReceivePort();
    Isolate.spawn(warpSyncIsolateFn, SyncParams(receivePort.sendPort));

    receivePort.listen((height) {
      f(height);
    });
  }

  static Future<int> tryWarpSync() async {
    final res = await compute(tryWarpSyncIsolateFn, null);
    return res;
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

  static void setMempoolAccount(int account) {
    return warp_api_lib.set_mempool_account(account);
  }

  static int getUnconfirmedBalance() {
    return warp_api_lib.get_mempool_balance();
  }

  static Future<String> sendPayment(int account, String address, int amount,
      int maxAmountPerNote, int anchorOffset, void Function(int) f) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      f(progress);
    });

    return await compute(
        sendPaymentIsolateFn,
        PaymentParams(
            account, address, amount, maxAmountPerNote, anchorOffset, receivePort.sendPort));
  }

  static int getTBalance(int account) {
    final balance = warp_api_lib.get_taddr_balance(account);
    return balance;
  }

  static Future<String> shieldTAddr(int account) async {
    final txId = compute(shieldTAddrIsolateFn, account);
    return txId;
  }

  static updateLWD(String url) {
    warp_api_lib.set_lwd_url(url.toNativeUtf8().cast<Int8>());
  }
}

String sendPaymentIsolateFn(PaymentParams params) {
  final txId = warp_api_lib.send_payment(
      params.account,
      params.address.toNativeUtf8().cast<Int8>(),
      params.amount,
      params.maxAmountPerNote,
      params.anchorOffset,
      params.port.nativePort);
  return txId.cast<Utf8>().toDartString();
}

void warpSyncIsolateFn(SyncParams params) {
  warp_api_lib.warp_sync(params.port.nativePort);
}

int tryWarpSyncIsolateFn(Null _dummy) {
  return warp_api_lib.try_warp_sync();
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
