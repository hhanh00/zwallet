
import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import './warp_api_generated.dart';

class WarpApi {
  static const MethodChannel _channel =
      const MethodChannel('warp_api');

  NativeLibrary lib;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  WarpApi() : lib = NativeLibrary(_open());

  static _open() {
    if (Platform.isAndroid) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isIOS) return DynamicLibrary.executable();
    throw UnsupportedError('This platform is not supported.');
  }
}
