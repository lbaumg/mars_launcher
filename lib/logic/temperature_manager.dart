import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/services/location_service.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

class TemperatureManager {
  final sharedPrefsManager = getIt<SharedPrefsManager>();
  final temperatureNotifier = ValueNotifier(Strings.defaultTemperatureString);
  final sunriseSunsetNotifier = ValueNotifier("");
  var sunriseSunsetString = "";
  final locationService = LocationService();
  final appShortcutManager = getIt<AppShortcutsManager>();
  final permissionService = getIt<PermissionService>();
  final settingsManager = getIt<SettingsManager>();
  final themeManager = getIt<ThemeManager>();

  Timer? timer;
  DateTime lastTemperatureUpdate = DateTime(0);
  DateTime lastSunriseSunsetUpdate = DateTime(0);

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

    /// Update sunrise/sunset data if last update later than 10h (10h * 60min * 60s)
    bool isMoreThanTenHours = DateTime.now().difference(lastSunriseSunsetUpdate).inHours > 10;
    if (isMoreThanTenHours) {
      updateSunriseSunset();
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
    lastTemperatureUpdate = DateTime.now();

    print("[$runtimeType] New Temperature value: ${temperatureNotifier.value}");
  }

  void updateSunriseSunset() {
    final now = DateTime.now();
    final utcOffset = Duration(minutes: now.timeZoneOffset.inMinutes);
    final sunriseSunset = getSunriseSunset(locationService.locationData.latitude!, locationService.locationData.longitude!, utcOffset, now);
    sunriseSunsetString = "Sunrise: ${DateFormat.Hm().format(sunriseSunset.sunrise)}\nSunset:  ${DateFormat.Hm().format(sunriseSunset.sunset)}";
    lastSunriseSunsetUpdate = now;
  }

  void couldNotRetrieveNewTemperature(String cause) {
    print("[$runtimeType] $cause");
    bool isMoreThanThreeHours = lastTemperatureUpdate.difference(DateTime.now()).inHours > 3;
    if (isMoreThanThreeHours) {
      /// If lastUpdated more than 3h ago delete value
      temperatureNotifier.value = Strings.defaultTemperatureString;
    } else if (temperatureNotifier.value != Strings.defaultTemperatureString){
      /// Append * in front of temperature to signal it is not latest
      if (!temperatureNotifier.value.contains("*")) {
        temperatureNotifier.value = "*" + temperatureNotifier.value;
      }
    }
  }

  void showSunriseSunsetForAFewSeconds() async {
    sunriseSunsetNotifier.value = sunriseSunsetString;
    await Future.delayed(Duration(seconds: DURATION_SHOW_SUNRISE_SUNSET));
    sunriseSunsetNotifier.value = "";
  }
}
