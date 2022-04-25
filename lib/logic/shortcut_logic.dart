import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/services/shared_prefs_manager.dart';


class AppShortcutsManager {
  static const KEY_APPS_ARE_SAVED = "appsAreSaved";
  static const KEY_WEATHER_ENABLED = "weatherEnabled";
  static const KEY_CLOCK_ENABLED = "clockEnabled";
  static const KEY_CALENDAR_ENABLED = "calendarEnabled";
  static const KEY_NUM_OF_SHORTCUT_ITEMS = "numOfShortcutItems";
  static const KEY_SHORTCUT_MODE = "shortcutMode";
  static const KEY_CLOCK_APP = "clockApp";
  static const KEY_CALENDAR_APP = "calendarApp";
  static const KEY_WEATHER_APP = "weatherApp";
  static const KEY_SWIPE_LEFT_APP = "swipeLeftApp";
  static const KEY_SWIPE_RIGHT_APP = "swipeRightApp";

  final ValueNotifierWithKey<bool> weatherEnabledNotifier = ValueNotifierWithKey(true, KEY_WEATHER_ENABLED);
  final ValueNotifierWithKey<bool> clockEnabledNotifier = ValueNotifierWithKey(true, KEY_CLOCK_ENABLED);
  final ValueNotifierWithKey<bool> calendarEnabledNotifier = ValueNotifierWithKey(true, KEY_CALENDAR_ENABLED);

  final ValueNotifierWithKey<int> numberOfShortcutItemsNotifier = ValueNotifierWithKey(4, KEY_NUM_OF_SHORTCUT_ITEMS);

  late final ShortcutAppsNotifier shortcutAppsNotifier;
  late final ValueNotifierWithKey<AppInfo> clockAppNotifier;
  late final ValueNotifierWithKey<AppInfo> calendarAppNotifier;
  late final ValueNotifierWithKey<AppInfo> weatherAppNotifier;
  late final ValueNotifierWithKey<AppInfo> swipeLeftAppNotifier;
  late final ValueNotifierWithKey<AppInfo> swipeRightAppNotifier;

  final ValueNotifierWithKey<bool> shortcutMode = ValueNotifierWithKey(true, KEY_SHORTCUT_MODE);

  late bool appsAreSaved;


  AppShortcutsManager() {
    print("INITIALIZING AppShortcutsManager");
    generateGenericShortcutApps();
    loadSharedPreferences();

    if (appsAreSaved) {
      loadShortcutAppsFromSharedPrefs();
    } else {
      loadShortcutAppsFromJson();
    }
  }


  void generateGenericShortcutApps() {
    AppInfo genericApp = AppInfo(packageName: "", appName: "select");
    List<AppInfo> initialShortcutApps = List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => genericApp);
    shortcutAppsNotifier = ShortcutAppsNotifier(initialShortcutApps);
    clockAppNotifier = ValueNotifierWithKey(genericApp, KEY_CLOCK_APP);
    calendarAppNotifier = ValueNotifierWithKey(genericApp, KEY_CALENDAR_APP);
    weatherAppNotifier = ValueNotifierWithKey(genericApp, KEY_WEATHER_APP);
    swipeLeftAppNotifier = ValueNotifierWithKey(genericApp, KEY_SWIPE_LEFT_APP);
    swipeRightAppNotifier = ValueNotifierWithKey(genericApp, KEY_SWIPE_RIGHT_APP);
  }


  void loadSharedPreferences() {
    appsAreSaved = SharedPrefsManager.readData(KEY_APPS_ARE_SAVED) ?? false;
    weatherEnabledNotifier.value = SharedPrefsManager.readData(KEY_WEATHER_ENABLED) ?? true;
    clockEnabledNotifier.value = SharedPrefsManager.readData(KEY_CLOCK_ENABLED) ?? true;
    calendarEnabledNotifier.value = SharedPrefsManager.readData(KEY_CALENDAR_ENABLED) ?? true;
    numberOfShortcutItemsNotifier.value = SharedPrefsManager.readData(KEY_NUM_OF_SHORTCUT_ITEMS) ?? 4;
    shortcutMode.value = SharedPrefsManager.readData(KEY_SHORTCUT_MODE) ?? true;
  }


  void loadShortcutAppsFromJson() async {
    print("LOADING APPS FROM JSON");

    try {
      final String response = await rootBundle.loadString('assets/apps.json');
      final shortcutAppsJson = await json.decode(response);

      shortcutAppsNotifier.value = List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => AppInfo(packageName: shortcutAppsJson["shortcutApps"][index][JSON_KEY_PACKAGE_NAME], appName: shortcutAppsJson["shortcutApps"][index]["name"]));
      clockAppNotifier.value = AppInfo(packageName: shortcutAppsJson["clock"][JSON_KEY_PACKAGE_NAME], appName: shortcutAppsJson["clock"][JSON_KEY_APP_NAME]);
      calendarAppNotifier.value = AppInfo(packageName: shortcutAppsJson["calendar"][JSON_KEY_PACKAGE_NAME], appName: shortcutAppsJson["calendar"][JSON_KEY_APP_NAME]);
      weatherAppNotifier.value = AppInfo(packageName: shortcutAppsJson["weather"][JSON_KEY_PACKAGE_NAME], appName: shortcutAppsJson["weather"][JSON_KEY_APP_NAME]);
      swipeLeftAppNotifier.value = AppInfo(packageName: shortcutAppsJson["camera"][JSON_KEY_PACKAGE_NAME], appName: shortcutAppsJson["camera"][JSON_KEY_APP_NAME]);
      swipeRightAppNotifier.value = AppInfo(packageName: shortcutAppsJson["contacts"][JSON_KEY_PACKAGE_NAME], appName: shortcutAppsJson["contacts"][JSON_KEY_APP_NAME]);
    } catch (e) {
      print("ERROR: $e");
    }
    saveShortcutAppsToSharedPrefs();
  }

  void loadShortcutAppsFromSharedPrefs() {
    print("LOADING APPS FROM SHARED PREFS");

    List<String> keysShortcutApps = List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => "shortcut$index");
    List<dynamic> objList = SharedPrefsManager.readMultiData(keysShortcutApps);

    shortcutAppsNotifier.value = List.generate(objList.length, (index) => AppInfo.fromJsonString(objList[index]));
    clockAppNotifier.value = AppInfo.fromJsonString(SharedPrefsManager.readData(clockAppNotifier.key));
    calendarAppNotifier.value = AppInfo.fromJsonString(SharedPrefsManager.readData(calendarAppNotifier.key));
    weatherAppNotifier.value = AppInfo.fromJsonString(SharedPrefsManager.readData(weatherAppNotifier.key));
    swipeLeftAppNotifier.value = AppInfo.fromJsonString(SharedPrefsManager.readData(swipeLeftAppNotifier.key));
    swipeRightAppNotifier.value = AppInfo.fromJsonString(SharedPrefsManager.readData(swipeRightAppNotifier.key));
  }


  void saveShortcutAppsToSharedPrefs() {
    int i = 0;
    for (var appInfo in shortcutAppsNotifier.value) {
      SharedPrefsManager.saveData("shortcut$i", appInfo.toJsonString());
      i++;
    }
    SharedPrefsManager.saveData(clockAppNotifier.key, clockAppNotifier.value.toJsonString());
    SharedPrefsManager.saveData(calendarAppNotifier.key, calendarAppNotifier.value.toJsonString());
    SharedPrefsManager.saveData(weatherAppNotifier.key, weatherAppNotifier.value.toJsonString());
    SharedPrefsManager.saveData(swipeLeftAppNotifier.key, swipeLeftAppNotifier.value.toJsonString());
    SharedPrefsManager.saveData(swipeRightAppNotifier.key, swipeRightAppNotifier.value.toJsonString());

    SharedPrefsManager.saveData(KEY_APPS_ARE_SAVED, true);
  }


  void setNotifierValueAndSave(ValueNotifierWithKey notifier) {
    switch (notifier.key) {
      case KEY_SHORTCUT_MODE:
      case KEY_WEATHER_ENABLED:
      case KEY_CLOCK_ENABLED:
      case KEY_CALENDAR_ENABLED:
        notifier.value = !notifier.value;
        break;
      case KEY_NUM_OF_SHORTCUT_ITEMS:
        notifier.value = (notifier.value + 1) % (MAX_NUM_OF_SHORTCUT_ITEMS+1);
    }
    SharedPrefsManager.saveData(notifier.key, notifier.value);
  }


  void setSpecialShortcutValue(ValueNotifierWithKey notifier, AppInfo appInfo) {
    notifier.value = appInfo;
    SharedPrefsManager.saveData(notifier.key, notifier.value.toJsonString());
  }
}

class ValueNotifierWithKey<T> extends ValueNotifier<T> {
  final String key;

  ValueNotifierWithKey(T value, String key) : this.key = key, super(value);
}


class ShortcutAppsNotifier extends ValueNotifier<List<AppInfo>> {
  ShortcutAppsNotifier(List<AppInfo> initialShortcutApps) : super(initialShortcutApps);

  void replaceShortcut(int index, AppInfo newShortcutApp) async {
    print("INDEX: $index");

    if (List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (i) => i).contains(index)) {
      value[index] = newShortcutApp;
      print("REPLACED SHORTCUT");
      notifyListeners();
    }
    SharedPrefsManager.saveData("shortcut$index", newShortcutApp.toJsonString());
  }
}
