import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'battery_info_plugin_platform_interface.dart';

/// An implementation of [BatteryInfoPluginPlatform] that uses method channels.
class MethodChannelBatteryInfoPlugin extends BatteryInfoPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('battery_info_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
