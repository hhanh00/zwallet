
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

const DEFAULT_ACCOUNT = 1;

final warp_api_lib = init();

NativeLibrary init() {
  var lib = NativeLibrary(WarpApi.open());
  lib.dart_post_cobject(NativeApi.postCObject.cast());
  return lib;
}

class WarpApi {
  static const MethodChannel _channel =
      const MethodChannel('warp_api');

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
    warp_api_lib.init_wallet(dbPath.toNativeUtf8().cast<Int8>());
  }

  static int newAccount(String name, String key) {
    return warp_api_lib.new_account(name.toNativeUtf8().cast<Int8>(),
        key.toNativeUtf8().cast<Int8>()
    );
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

  static void setMempoolAccount(int account) {
    return warp_api_lib.set_mempool_account(account);
  }

  static int getUnconfirmedBalance() {
    return warp_api_lib.get_mempool_balance();
  }

  static String sendPayment(int account, String address, int amount) {
    final txId = warp_api_lib.send_payment(account, address.toNativeUtf8().cast<Int8>(), amount);
    return txId.cast<Utf8>().toDartString();
  }
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