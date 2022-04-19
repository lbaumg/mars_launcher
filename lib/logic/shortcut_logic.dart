import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/services/storage_service/shared_prefs_manager.dart';


class AppShortcutsManager {
  final ValueNotifier<bool> weatherEnabledNotifier = ValueNotifier(false);
  final ValueNotifier<bool> clockEnabledNotifier = ValueNotifier(false);
  final ValueNotifier<bool> calendarEnabledNotifier = ValueNotifier(false);

  final ValueNotifier<int> numberOfShortcutItemsNotifier = ValueNotifier(4);

  late final ShortcutAppsNotifier shortcutAppsNotifier;
  late final ValueNotifier<AppInfo> clockAppNotifier;
  late final ValueNotifier<AppInfo> calendarAppNotifier;
  late final ValueNotifier<AppInfo> weatherAppNotifier;
  late final ValueNotifier<AppInfo> cameraAppNotifier;
  late final ValueNotifier<AppInfo> contactsAppNotifier;


  AppShortcutsManager() {
    print("INITIALISING AppShortcutsManager");

    List<AppInfo> initialShortcutApps = List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => AppInfo(packageName: "", appName: "select"));
    AppInfo genericApp = AppInfo(packageName: "", appName: "select");

    shortcutAppsNotifier = ShortcutAppsNotifier(initialShortcutApps);
    clockAppNotifier = ValueNotifier(genericApp);
    calendarAppNotifier = ValueNotifier(genericApp);
    weatherAppNotifier = ValueNotifier(genericApp);
    cameraAppNotifier = ValueNotifier(genericApp);
    contactsAppNotifier = ValueNotifier(genericApp);

    SharedPrefsManager.readData('isSwitchedWeather').then((value) {
      print('isSwitchedWeather: $value  (read from storage)');
      weatherEnabledNotifier.value = value ?? true;
    });
    SharedPrefsManager.readData('isSwitchedClock').then((value) {
      print('isSwitchedClock: $value  (read from storage)');
      clockEnabledNotifier.value = value ?? true;
    });
    SharedPrefsManager.readData('isSwitchedCalendar').then((value) {
      print('isSwitchedCalendar: $value  (read from storage)');
      calendarEnabledNotifier.value = value ?? true;
    });

    SharedPrefsManager.readData('numOfShortcutItems').then((value) {
      print('numOfShortcutItems: $value  (read from storage)');
      numberOfShortcutItemsNotifier.value = value ?? 4;
    });
    if (LOAD_FROM_JSON) {
      loadShortcutAppsFromJson();
    } else {
      // TODO load from SQL database
    }
  }

  void loadShortcutAppsFromJson() async {

    try {
      final String response = await rootBundle.loadString('assets/apps.json');
      final shortcutAppsJson = await json.decode(response);

      shortcutAppsNotifier.value = List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => AppInfo(packageName: shortcutAppsJson["shortcutApps"][index]["packageName"], appName: shortcutAppsJson["shortcutApps"][index]["name"]));
      clockAppNotifier.value = AppInfo(packageName: shortcutAppsJson["clock"]["packageName"], appName: shortcutAppsJson["clock"]["appName"]);
      calendarAppNotifier.value = AppInfo(packageName: shortcutAppsJson["calendar"]["packageName"], appName: shortcutAppsJson["calendar"]["appName"]);
      weatherAppNotifier.value = AppInfo(packageName: shortcutAppsJson["weather"]["packageName"], appName: shortcutAppsJson["weather"]["appName"]);
      cameraAppNotifier.value = AppInfo(packageName: shortcutAppsJson["camera"]["packageName"], appName: shortcutAppsJson["camera"]["appName"]);
      contactsAppNotifier.value = AppInfo(packageName: shortcutAppsJson["contacts"]["packageName"], appName: shortcutAppsJson["contacts"]["appName"]);
    } catch (e) {
      print("ERROR: $e");
    }


  }

  void toggleEnable(String setting) {
    if (setting == "isSwitchedWeather") {
      weatherEnabledNotifier.value = !weatherEnabledNotifier.value;
      SharedPrefsManager.saveData(setting, weatherEnabledNotifier.value);
    } else if (setting == "isSwitchedClock") {
      clockEnabledNotifier.value = !clockEnabledNotifier.value;
      SharedPrefsManager.saveData(setting, clockEnabledNotifier.value);
    } else if (setting == "isSwitchedCalendar") {
      calendarEnabledNotifier.value = !calendarEnabledNotifier.value;
      SharedPrefsManager.saveData(setting, calendarEnabledNotifier.value);
    }

  }

  void incNumberOfShortcutItems() {
    numberOfShortcutItemsNotifier.value = (numberOfShortcutItemsNotifier.value + 1) % (MAX_NUM_OF_SHORTCUT_ITEMS+1);
    saveNumberOfShortcutItems();
  }

  void decNumberOfShortcutItems() {
    if (numberOfShortcutItemsNotifier.value > MIN_NUM_OF_SHORTCUT_ITEMS) {
        numberOfShortcutItemsNotifier.value--;
        saveNumberOfShortcutItems();
    }
  }

  void saveNumberOfShortcutItems() async {
    SharedPrefsManager.saveData("numOfShortcutItems", numberOfShortcutItemsNotifier.value);
  }
}

class ShortcutAppsNotifier extends ValueNotifier<List<AppInfo>> {
  ShortcutAppsNotifier(List<AppInfo> initialShortcutApps) : super(initialShortcutApps);

  void replaceShortcut(int index, AppInfo newShortcutApp) {
    print("INDEX: $index");
    if ([0,1,2,3,4,5].contains(index)) {
      value[index] = newShortcutApp;
      print("REPLACED SHORTCUT");
      notifyListeners();
    }
  }
}

