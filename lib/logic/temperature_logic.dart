import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/services/location_service.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

const API_KEY = "fe944563ad38e93ba270f054ec5b3474";

class TemperatureLogic {
  final temperatureNotifier = ValueNotifier("");
  final locationService = LocationService();
  final wf = WeatherFactory(API_KEY);
  final appShortcutManager = getIt<AppShortcutsManager>();
  late Timer timer;

  TemperatureLogic() {
    print("INITIALIZING TemperatureLogic");
    timer = Timer.periodic(Duration(minutes: UPDATE_TEMPERATURE_EVERY), (timer) => updateTemperature());
    updateTemperature();
  }

  void updateTemperature() async {
    /// Check if weather is enabled and permission for location is granted
    if (!appShortcutManager.weatherEnabledNotifier.value || !await locationService.checkPermission()) {
      print("Weather not enabled or no permission for location.");
      return;
    }

    await locationService.updateLocation();
    if (locationService.lat == null || locationService.lon == null) {
      return;
    }

    Weather w = await wf.currentWeatherByLocation(locationService.lat!, locationService.lon!);
    String? temp = w.temperature?.celsius?.toInt().toString();
    if (temp != null) {
      temperatureNotifier.value = "$temp°C";
      print("New Temperature value: ${temperatureNotifier.value}");
    }
  }

  void askForPermission() async{
    // TODO ask for permission, call when enabling weather
    await locationService.checkPermission();
  }
}
