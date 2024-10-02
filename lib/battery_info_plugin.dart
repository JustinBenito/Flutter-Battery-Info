import 'dart:async';

import 'package:flutter/services.dart';

class BatteryInfoPlugin {
  static const MethodChannel _channel = MethodChannel('battery_info_plugin');

  static Future<Map<String, dynamic>> getBatteryInfo() async {
    try {
      final result = await _channel.invokeMethod('getBatteryInfo');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      } else {
        print('Unexpected result type: ${result.runtimeType}');
        return {};
      }
    } on PlatformException catch (e) {
      print('Failed to get battery info: ${e.message}');
      return {};
    }
  }
}