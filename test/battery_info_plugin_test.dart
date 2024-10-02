import 'package:flutter_test/flutter_test.dart';
import 'package:battery_info_plugin/battery_info_plugin.dart';
import 'package:battery_info_plugin/battery_info_plugin_platform_interface.dart';
import 'package:battery_info_plugin/battery_info_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBatteryInfoPluginPlatform
    with MockPlatformInterfaceMixin
    implements BatteryInfoPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BatteryInfoPluginPlatform initialPlatform = BatteryInfoPluginPlatform.instance;

  test('$MethodChannelBatteryInfoPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBatteryInfoPlugin>());
  });

  test('getPlatformVersion', () async {
    BatteryInfoPlugin batteryInfoPlugin = BatteryInfoPlugin();
    MockBatteryInfoPluginPlatform fakePlatform = MockBatteryInfoPluginPlatform();
    BatteryInfoPluginPlatform.instance = fakePlatform;

    // expect(await batteryInfoPlugin.getPlatformVersion(), '42');
  });
}
