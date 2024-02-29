import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/services/location_service.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:open_meteo/open_meteo.dart';

class TemperatureManager {
  final sharedPrefsManager = getIt<SharedPrefsManager>();
  final temperatureNotifier = ValueNotifier("-°C");
  final locationService = LocationService();
  final appShortcutManager = getIt<AppShortcutsManager>();
  final permissionService = getIt<PermissionService>();
  final settingsManager = getIt<SettingsManager>();
  final themeManager = getIt<ThemeManager>();

  Timer? timer;
  int lastTemperatureUpdateMillis = 0;

  TemperatureManager() {
    print("[$runtimeType] INITIALIZING");

    if (settingsManager.weatherWidgetEnabledNotifier.value) {
      updateTemperature();
    }

    /// Setup timer to update temperature every 5min only when weatherWidget is enabled
    timer = Timer.periodic(Duration(minutes: UPDATE_TEMPERATURE_EVERY), (timer) {
      if (settingsManager.weatherWidgetEnabledNotifier.value) {
        updateTemperature();
      }
    });

    settingsManager.weatherWidgetEnabledNotifier.addListener(() {
      if (settingsManager.weatherWidgetEnabledNotifier.value) {
        updateTemperature();
      }
    });
  }

  void updateTemperature() async {
    /// Check if weather is enabled
    if (!settingsManager.weatherWidgetEnabledNotifier.value) {
      return couldNotRetrieveNewTemperature("[$runtimeType] weather widget disabled");
    }

    /// Check if permission for location is granted
    if (!await locationService.checkPermission()) {
      return couldNotRetrieveNewTemperature("[$runtimeType] no permission for location.");
    }

    /// Get current location from locationService
    await locationService.updateLocation();
    if (locationService.locationData.latitude == null || locationService.locationData.longitude == null) {
      return couldNotRetrieveNewTemperature("[$runtimeType] latitude or longitude == null");
    }

    /// Request the current weather for location data
    print("[$runtimeType] Check new weather");
    var weather = Weather(latitude: locationService.locationData.latitude!, longitude: locationService.locationData.longitude!, temperature_unit: TemperatureUnit.celsius);

    var result = await weather.raw_request(current: [Current.temperature_2m]);
    final temperatureObj = result["current"];
    if (temperatureObj != null) {
      final temp = temperatureObj["temperature_2m"];
      if (temp != null) {
        setNewTemperature(temp);
      } else {
        couldNotRetrieveNewTemperature("[$runtimeType] temp is null");
      }
    } else {
      couldNotRetrieveNewTemperature("[$runtimeType] temperatureObj is null");
    }
  }

  void setNewTemperature(temp) {
    temperatureNotifier.value = "$temp°C";
    lastTemperatureUpdateMillis = DateTime.now().millisecondsSinceEpoch;

    print("[$runtimeType] New Temperature value: ${temperatureNotifier.value}");
  }

  void couldNotRetrieveNewTemperature(String cause) {
    print("[$runtimeType] $cause");

    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    int differenceMillis = currentTimeMillis - lastTemperatureUpdateMillis;
    int differenceSeconds = differenceMillis ~/ 1000;
    bool isMoreThanThreeHours = differenceSeconds > (3 * 60 * 60);

    /// > (3 h * 60 min * 60 sec)?
    if (isMoreThanThreeHours) {
      /// If lastUpdated more than 3h ago delete value
      temperatureNotifier.value = "-°C";
    } else {
      /// Append * in front of temperature to signal it is not latest
      if (!temperatureNotifier.value.contains("*")) {
        temperatureNotifier.value = "*" + temperatureNotifier.value;
      }
    }
  }
}
