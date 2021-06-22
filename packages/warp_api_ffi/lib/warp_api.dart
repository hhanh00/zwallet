
import 'dart:async';

import 'package:flutter/services.dart';

class WarpApi {
  static const MethodChannel _channel =
      const MethodChannel('warp_api');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
