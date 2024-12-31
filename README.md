# Battery Info Plugin

Battery Info Plugin is an Android-only plugin that provides comprehensive information from the Android Battery Manager API.

## Features

- Battery level
- Charging status
- Battery health
- Battery temperature
- Battery voltage

## Installation

Add `battery_info_plugin` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
    battery_info_plugin: latest_version
```

## Usage

Import the package and use it in your Flutter application:

```dart
import 'package:battery_info_plugin/battery_info_plugin.dart';

void getBatteryInfo() async {
    var batteryLevel = await BatteryInfoPlugin.getBatteryLevel();
    var chargingStatus = await BatteryInfoPlugin.getChargingStatus();
    // Add more usage examples as needed
}
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:battery_info_plugin/battery_info_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: BatteryInfoScreen(),
        );
    }
}

class BatteryInfoScreen extends StatefulWidget {
    @override
    _BatteryInfoScreenState createState() => _BatteryInfoScreenState();
}

class _BatteryInfoScreenState extends State<BatteryInfoScreen> {
    String batteryLevel = 'Unknown';

    @override
    void initState() {
        super.initState();
        getBatteryLevel();
    }

    void getBatteryLevel() async {
        var level = await BatteryInfoPlugin.getBatteryLevel();
        setState(() {
            batteryLevel = '$level%';
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Battery Info'),
            ),
            body: Center(
                child: Text('Battery Level: $batteryLevel'),
            ),
        );
    }
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request.

## Support

For any questions or issues, please open an issue on the [GitHub repository](https://github.com/JustinBenito/Flutter-Battery-Info).

