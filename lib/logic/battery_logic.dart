

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/cupertino.dart';

class BatteryLogic {
  final Battery _battery = Battery();
  final batteryLevelNotifier = ValueNotifier(0);

  BatteryLogic() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      print('Battery state changed: $state');
      updateBatteryLevel();
    });
  }

  Future<void> updateBatteryLevel() async {

    _battery.batteryLevel.then((level) {
      if (level != batteryLevelNotifier.value) {
      print("BATTERY LEVEL: $level");
        batteryLevelNotifier.value = level;
      }
    });
  }

}