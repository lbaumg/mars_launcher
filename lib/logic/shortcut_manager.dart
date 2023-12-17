import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';

class AppShortcutsManager {

  final sharedPrefsManager = getIt<SharedPrefsManager>();

  late final ValueNotifierWithKey<AppInfo> clockAppNotifier;
  late final ValueNotifierWithKey<AppInfo> calendarAppNotifier;
  late final ValueNotifierWithKey<AppInfo> weatherAppNotifier;
  late final ValueNotifierWithKey<AppInfo> swipeLeftAppNotifier;
  late final ValueNotifierWithKey<AppInfo> swipeRightAppNotifier;
  late final ShortcutAppsNotifier shortcutAppsNotifier;

  final genericAppInfo = AppInfo(packageName: "", appName: Strings.uninitializedAppName);

  final appsManager = getIt<AppsManager>();

  AppShortcutsManager() {
    print("[$runtimeType] INITIALIZING");

    if (sharedPrefsManager.readData(Keys.appsAreSaved) ?? false) {
      loadShortcutAppsFromSharedPrefs();
    } else {
      generateGenericShortcutApps();
      if (LOAD_APPS_FROM_JSON) {
        loadShortcutAppsFromJson();
      }
    }

    appsManager.renamedAppsUpdatedNotifier.addListener(() {
      updateDisplayNames();
    });
  }

  void generateGenericShortcutApps() async {
    shortcutAppsNotifier = ShortcutAppsNotifier(List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (index) => genericAppInfo));
    clockAppNotifier = ValueNotifierWithKey(genericAppInfo, Keys.clockApp);
    calendarAppNotifier = ValueNotifierWithKey(genericAppInfo, Keys.calendarApp);
    weatherAppNotifier = ValueNotifierWithKey(genericAppInfo, Keys.weatherApp);
    swipeLeftAppNotifier = ValueNotifierWithKey(genericAppInfo, Keys.swipeLeftApp);
    swipeRightAppNotifier = ValueNotifierWithKey(genericAppInfo, Keys.swipeRightApp);
  }

  void loadShortcutAppsFromJson() async {
    print("[$runtimeType] LOADING APPS FROM JSON");
    try {
      final String response = await rootBundle.loadString('assets/apps.json');
      final shortcutAppsJson = await json.decode(response);

      shortcutAppsNotifier.value = List.generate(
          MAX_NUM_OF_SHORTCUT_ITEMS,
          (index) => AppInfo(
              packageName: shortcutAppsJson["shortcutApps"][index][JsonKeys.packageName],
              appName: shortcutAppsJson["shortcutApps"][index]["name"]));
      clockAppNotifier.value = AppInfo(
          packageName: shortcutAppsJson["clock"][JsonKeys.packageName],
          appName: shortcutAppsJson["clock"][JsonKeys.appName]);
      calendarAppNotifier.value = AppInfo(
          packageName: shortcutAppsJson["calendar"][JsonKeys.packageName],
          appName: shortcutAppsJson["calendar"][JsonKeys.appName]);
      weatherAppNotifier.value = AppInfo(
          packageName: shortcutAppsJson["weather"][JsonKeys.packageName],
          appName: shortcutAppsJson["weather"][JsonKeys.appName]);
      swipeLeftAppNotifier.value = AppInfo(
          packageName: shortcutAppsJson["camera"][JsonKeys.packageName],
          appName: shortcutAppsJson["camera"][JsonKeys.appName]);
      swipeRightAppNotifier.value = AppInfo(
          packageName: shortcutAppsJson["contacts"][JsonKeys.packageName],
          appName: shortcutAppsJson["contacts"][JsonKeys.appName]);
    } catch (e) {
      print("[$runtimeType] error loading from json: $e");
    }
    saveShortcutAppsToSharedPrefs();
  }

  Future<void> loadShortcutAppsFromSharedPrefs() async {
    print("[$runtimeType] LOADING APPS FROM SHARED PREFS");
    shortcutAppsNotifier = ShortcutAppsNotifier(List.generate(
        MAX_NUM_OF_SHORTCUT_ITEMS, (index) => AppInfo.fromJsonString(sharedPrefsManager.readData("shortcut$index"))));
    clockAppNotifier =
        ValueNotifierWithKey(AppInfo.fromJsonString(sharedPrefsManager.readData(Keys.clockApp)), Keys.clockApp);
    calendarAppNotifier =
        ValueNotifierWithKey(AppInfo.fromJsonString(sharedPrefsManager.readData(Keys.calendarApp)), Keys.calendarApp);
    weatherAppNotifier =
        ValueNotifierWithKey(AppInfo.fromJsonString(sharedPrefsManager.readData(Keys.weatherApp)), Keys.weatherApp);
    swipeLeftAppNotifier =
        ValueNotifierWithKey(AppInfo.fromJsonString(sharedPrefsManager.readData(Keys.swipeLeftApp)), Keys.swipeLeftApp);
    swipeRightAppNotifier = ValueNotifierWithKey(
        AppInfo.fromJsonString(sharedPrefsManager.readData(Keys.swipeRightApp)), Keys.swipeRightApp);
  }

  void saveShortcutAppsToSharedPrefs() {
    int i = 0;
    for (var appInfo in shortcutAppsNotifier.value) {
      sharedPrefsManager.saveData("shortcut$i", appInfo.toJsonString());
      i++;
    }
    sharedPrefsManager.saveData(clockAppNotifier.key, clockAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(calendarAppNotifier.key, calendarAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(weatherAppNotifier.key, weatherAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(swipeLeftAppNotifier.key, swipeLeftAppNotifier.value.toJsonString());
    sharedPrefsManager.saveData(swipeRightAppNotifier.key, swipeRightAppNotifier.value.toJsonString());

    sharedPrefsManager.saveData(Keys.appsAreSaved, true);
  }

  void setSpecialShortcutValue(ValueNotifierWithKey notifier, AppInfo appInfo) {
    notifier.value = appInfo;
    sharedPrefsManager.saveData(notifier.key, notifier.value.toJsonString());
  }

  void updateDisplayNames() {
    for (int index = 0; index < shortcutAppsNotifier.value.length; index++) {
      final shortcutApp = shortcutAppsNotifier.value[index];
      final displayName = appsManager.renamedApps[shortcutApp.packageName];

      final isDisplayNameNew = displayName != null && displayName != shortcutApp.displayName;
      final hasDisplayNameBeenReset = displayName == null && shortcutApp.appName != shortcutApp.displayName; /// Check if display name has been reset
      if (isDisplayNameNew || hasDisplayNameBeenReset) {
        shortcutApp.displayName = displayName;
        shortcutAppsNotifier.replaceShortcut(index, shortcutApp);
      }
    }
  }
}

class ShortcutAppsNotifier extends ValueNotifier<List<AppInfo>> {
  final sharedPrefsManager = getIt<SharedPrefsManager>();
  ShortcutAppsNotifier(List<AppInfo> initialShortcutApps) : super(initialShortcutApps);

  void replaceShortcut(int index, AppInfo newShortcutApp) async {
    print("[$runtimeType] replacing index: $index");

    if (List.generate(MAX_NUM_OF_SHORTCUT_ITEMS, (i) => i).contains(index)) {
      value[index] = newShortcutApp;
      print("[$runtimeType] replaced shortcut");
      notifyListeners();
    }
    sharedPrefsManager.saveData("shortcut$index", newShortcutApp.toJsonString());
  }
}
