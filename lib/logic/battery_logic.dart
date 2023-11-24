

import 'package:battery/battery.dart';
import 'package:flutter/cupertino.dart';

class BatteryLogic {
  final Battery _battery = Battery();
  final batteryLevelNotifier = ValueNotifier(0);

  BatteryLogic() {
    updateBatteryLevel();
  }

  Future<void> updateBatteryLevel() async {
    batteryLevelNotifier.value = await _battery.batteryLevel;
  }

}