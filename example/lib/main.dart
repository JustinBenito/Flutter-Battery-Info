import 'package:flutter/material.dart';
import 'package:battery_info_plugin/battery_info_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _batteryInfo = {};

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
  }

  Future<void> _getBatteryInfo() async {
    try {
      final batteryInfo = await BatteryInfoPlugin.getBatteryInfo();
      setState(() {
        _batteryInfo = batteryInfo;
      });
      print('Received battery info: $batteryInfo');
    } catch (e) {
      print('Error getting battery info: $e');
      setState(() {
        _batteryInfo = {};
      });
    }
  }

  String _getValueOrUnknown(String key) {
    final value = _batteryInfo[key];
    if (value == null) return 'Unknown';
    if (value is num) return value.toString();
    return value.toString();
  }

  double _calculateCarbonEmitted() {
    final current = _batteryInfo['batteryCurrentNow'];
    final voltage = _batteryInfo['batteryVoltage'];
    
    // Ensure current and voltage are valid numbers.
    if (current == null || voltage == null) {
      return 0.0;
    }
    
    // Convert µA (microamps) to A (amps), and mV (millivolts) to V (volts).
    final currentInAmps = current / 1000000;
    final voltageInVolts = voltage / 1000;
    
    // Carbon emitted (grams) = currentInAmps * voltageInVolts * emission factor (0.43)
    return currentInAmps * voltageInVolts * 0.43;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Info Plugin Example'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Battery Level: ${_getValueOrUnknown('batteryLevel')}%'),
                Text('Is Charging: ${_getValueOrUnknown('isCharging')}'),
                Text('Charging Status: ${_getValueOrUnknown('chargingStatus')}'),
                Text('Battery Health: ${_getValueOrUnknown('batteryHealth')}'),
                Text('Plugged Status: ${_getValueOrUnknown('pluggedStatus')}'),
                Text('Battery Capacity: ${_getValueOrUnknown('batteryCapacity')}%'),
                Text('Battery Voltage: ${_getValueOrUnknown('batteryVoltage')} mV'),
                Text('Battery Temperature: ${_getValueOrUnknown('batteryTemperature')}°C'),
                Text('Battery Technology: ${_getValueOrUnknown('batteryTechnology')}'),
                Text('Battery Current: ${_getValueOrUnknown('batteryCurrentNow')} µA'),
                Text('Battery Charge Counter: ${_getValueOrUnknown('chargeCounter')} µAh'),
                Text('Battery Energy Counter: ${_getValueOrUnknown('batteryEnergyCounter')} nWh'),
                Text('Average Battery Current: ${_getValueOrUnknown('batteryCurrentAvg')} µA'),
                ElevatedButton(
                  onPressed: _getBatteryInfo,
                  child: const Text('Refresh Battery Info'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
