import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/services/location_service.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:weather/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TemperatureLogic {
  final temperatureNotifier = ValueNotifier("");
  final locationService = LocationService();
  final wf = WeatherFactory(dotenv.env['WEATHER_API_KEY']!);
  final appShortcutManager = getIt<AppShortcutsManager>();
  final permissionService = getIt<PermissionService>();
  final settingsLogic = getIt<SettingsLogic>();
  late Timer timer;


  TemperatureLogic() {
    print("[$runtimeType] INITIALIZING");

    updateTemperature();
    timer = Timer.periodic(Duration(minutes: UPDATE_TEMPERATURE_EVERY), (timer) => updateTemperature());
    permissionService.weatherActivated.addListener(initializeTemp);
  }

  void initializeTemp() {
    if (permissionService.weatherActivated.value) {
      print("[$runtimeType] initializing temp");
      permissionService.weatherActivated.removeListener(initializeTemp);
      updateTemperature();
    }
  }

  void updateTemperature() async {
    /// Check if weather is enabled and permission for location is granted
    if (!permissionService.weatherActivated.value || !settingsLogic.weatherEnabledNotifier.value || !await locationService.checkPermission()) {
      print("[$runtimeType] Weather not enabled or no permission for location.");
      return;
    }


    await locationService.updateLocation();
    if (locationService.locationData.latitude == null || locationService.locationData.longitude == null) {
      print("[$runtimeType] Test works");
      return;
    }

    print("[$runtimeType] Check new weather");
    Weather w = await wf.currentWeatherByLocation(locationService.locationData.latitude!, locationService.locationData.longitude!);
    String? temp = w.temperature?.celsius?.toInt().toString();
    if (temp != null) {
      temperatureNotifier.value = "$temp°C";
      print("[$runtimeType] new Temperature value: ${temperatureNotifier.value}");
    }
  }
}
