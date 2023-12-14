import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/services/service_locator.dart';

class BatteryManager {
  final settingsManager = getIt<SettingsManager>();
  final Battery _battery = Battery();
  final batteryLevelNotifier = ValueNotifier(0);

  StreamSubscription<BatteryState>? subscriptionBatteryEnabled;

  BatteryManager() {
    settingsManager.batteryWidgetEnabledNotifier.addListener(handleBatteryWidgetEnabledChanged);

    /// Activate listener if batteryWidget is enabled
    if (settingsManager.batteryWidgetEnabledNotifier.value) {
      activateOnBatteryChangedListener();
    }
  }

  void handleBatteryWidgetEnabledChanged() {
    if (settingsManager.batteryWidgetEnabledNotifier.value) {
      activateOnBatteryChangedListener();
    } else {
      deactivateOnBatteryChangedListener();
    }
  }

  /// Listen to changes of battery
  void activateOnBatteryChangedListener() {
    if (subscriptionBatteryEnabled == null) {
      /// Add subscription if not already subscribed
      subscriptionBatteryEnabled = _battery.onBatteryStateChanged.listen((BatteryState state) {
        print('Battery state changed: $state');
        updateBatteryLevel();
      });
    }
  }

  /// Cancel subscription to battery changed
  void deactivateOnBatteryChangedListener() {
    subscriptionBatteryEnabled?.cancel();
    subscriptionBatteryEnabled = null;
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
