import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'battery_info_plugin_method_channel.dart';

abstract class BatteryInfoPluginPlatform extends PlatformInterface {
  /// Constructs a BatteryInfoPluginPlatform.
  BatteryInfoPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static BatteryInfoPluginPlatform _instance = MethodChannelBatteryInfoPlugin();

  /// The default instance of [BatteryInfoPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelBatteryInfoPlugin].
  static BatteryInfoPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BatteryInfoPluginPlatform] when
  /// they register themselves.
  static set instance(BatteryInfoPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
