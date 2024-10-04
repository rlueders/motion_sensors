# motion_sensors

Flutter plugin for accessing the Android and iOS accelerometer, gyroscope, magnetometer and orientation sensors.

## Getting Started

To use this plugin, add `motion_sensors` as a [dependency in your pubspec.yaml
file](https://flutter.io/platform-plugins/).

``` dart
import 'package:motion_sensors/motion_sensors.dart';

motionSensors.magnetometer.listen((MagnetometerEvent event) {
    print(event);
});

```

## Screenshot

![screenshot](https://github.com/zesage/motion_sensors/raw/master/screenshot.png)


0.1.0
Added null safety

0.2.0
upgrade dependancies 

1.2.0
Addging event timestamps
1.2.1
Adding timestamp to absolute orientation