import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/services/location_service.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

const KEY_API_KEY = "apiKey";

class TemperatureLogic {
  final temperatureNotifier = ValueNotifier("-°C");
  final locationService = LocationService();
  final appShortcutManager = getIt<AppShortcutsManager>();
  final permissionService = getIt<PermissionService>();
  final settingsLogic = getIt<SettingsLogic>();

  WeatherFactory? wf;
  String? apiKey;
  Timer? timer;
  int lastTemperatureUpdateMillis = 0;


  TemperatureLogic() {
    print("[$runtimeType] INITIALIZING");

    apiKey = SharedPrefsManager.readData(KEY_API_KEY);

    /// If weather is enabled and working apiKey exists
    if (apiKey != null) {
      wf = WeatherFactory(apiKey!);
    }

    if (settingsLogic.weatherWidgetEnabledNotifier.value) {
      updateTemperature();
    }

    /// Setup timer to update temperature every 5min only when weatherWidget is enabled
    timer = Timer.periodic(Duration(minutes: UPDATE_TEMPERATURE_EVERY), (timer) {
      if (settingsLogic.weatherWidgetEnabledNotifier.value && apiKey != null && wf != null) {
        updateTemperature();
      }
    });

    settingsLogic.weatherWidgetEnabledNotifier.addListener(() {

      if (settingsLogic.weatherWidgetEnabledNotifier.value) {
        if (apiKey != null && wf != null) {
          updateTemperature();
        } else {

          Fluttertoast.showToast(msg: "OpenWeather API key not set. Set under settings -> more -> OpenWeather API key",
              toastLength: Toast.LENGTH_LONG,);
        }
      }
    });
  }

  /// Must/Will only be called with valid ApiKey
  void addApiKey(String newApiKey) {
    print("[$runtimeType] add new api key: $newApiKey");
    apiKey = newApiKey;
    SharedPrefsManager.saveData(KEY_API_KEY, apiKey);
    wf = WeatherFactory(apiKey!);
    updateTemperature();
  }

  void deleteAPIKey() {
    SharedPrefsManager.deleteData(KEY_API_KEY);
    apiKey = null;
    wf = null;
  }

  void updateTemperature() async {
    /// Check if WeatherFactory is initialized
    if (wf == null) {
      return couldNotRetrieveNewTemperature("wf == null");
    }

    /// Check if weather is enabled
    if (!settingsLogic.weatherWidgetEnabledNotifier.value) {
      return couldNotRetrieveNewTemperature("[$runtimeType] weather widget disabled");
    }
    /// Check if permission for location is granted
    if (!await locationService.checkPermission()) {
      return couldNotRetrieveNewTemperature("[$runtimeType] no permission for location.");
    }

    await locationService.updateLocation();
    if (locationService.locationData.latitude == null || locationService.locationData.longitude == null) {
      return couldNotRetrieveNewTemperature("[$runtimeType] latitude or longitude == null");
    }

    print("[$runtimeType] Check new weather");
    Weather w = await wf!.currentWeatherByLocation(locationService.locationData.latitude!, locationService.locationData.longitude!);
    String? temp = w.temperature?.celsius?.toInt().toString();
    if (temp != null) {
      setNewTemperature(temp);
    } else {
      couldNotRetrieveNewTemperature("Temp == null");
    }
  }

  void setNewTemperature(temp) {
    temperatureNotifier.value = "$temp°C";
    lastTemperatureUpdateMillis = DateTime.now().millisecondsSinceEpoch;

    print("[$runtimeType] new Temperature value: ${temperatureNotifier.value}");
  }

  void couldNotRetrieveNewTemperature(String cause) {
    print("[$runtimeType] $cause");

    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    int differenceMillis = currentTimeMillis - lastTemperatureUpdateMillis;
    int differenceSeconds = differenceMillis ~/ 1000;
    bool isMoreThanThreeHours = differenceSeconds > (3 * 60 * 60); /// > (3 h * 60 min * 60 sec)?
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


  Future<bool> isApiKeyValid(String apiKey) async {
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
    final cityName = 'London'; // You can change this to a valid city name.

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?q=$cityName&appid=$apiKey'),
      );

      if (response.statusCode == 200) {
        // API key is valid, and the request was successful.
        return true;
      } else {
        final error = jsonDecode(response.body);//['message'];
        print('API Key Validation Error: $error');
        return false;
      }
    } catch (e) {
      // An error occurred while making the request.
      print('API Key Validation Error: $e');
      return false;
    }
  }
}
