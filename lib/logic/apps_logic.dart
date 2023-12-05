

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';

const KEY_NUMBER_OF_RENAMED_OR_HIDDEN_APPS = "numberOfRenamedOrHiddenApps";
const KEY_HIDDEN_APPS = "renamedApps";
const PREFIX_RENAMED_OR_HIDDEN_APPS = "renamedOrHiddenApp";

class AppsManager {
  /// LIST OF INSTALLED APPs
  final appsNotifier = ValueNotifier<List<AppInfo>>([]);

  /// LIST OF RENAMED OR HIDDEN APPS
  late final ValueNotifier<List<AppInfo>> hiddenAppsNotifier;
  int numberOfHiddenApps = SharedPrefsManager.readData(KEY_NUMBER_OF_RENAMED_OR_HIDDEN_APPS) ?? 0;

  // late final Map<String, String> renamedApps;

  var currentlySyncing = false;

  AppsManager() {
    print("[$runtimeType] INITIALISING");

    loadHiddenAppsFromSharedPrefs();

    syncInstalledApps();

    /// Listen to change of apps (install/uninstall)
    DeviceApps.listenToAppsChanges().where((event) => event.event != ApplicationEventType.updated).listen((event) {handleAppEvent(event);});
  }

  void addOrUpdateRenamedOrHiddenApp(AppInfo updatedAppInfo) {
    /// Check if the appInfo with the same packageName already exists in the list
    var updatedList = List.of(hiddenAppsNotifier.value);

    int existingIndex = updatedList.indexWhere(
          (appInfo) => appInfo.packageName == updatedAppInfo.packageName,
    );

    if (existingIndex == -1) {
      /// If the appInfo is not found, add it to the list
      updatedList.add(updatedAppInfo);
      saveNewHiddenAppToSharedPrefs(updatedAppInfo);

    } else {
      /// If the appInfo is found, update its values
      updatedList[existingIndex] = updatedAppInfo;
      updateHiddenAppInSharedPrefs(updatedAppInfo, existingIndex);
    }

    updateAppsNotifierWithHideStatus(updatedAppInfo);


    hiddenAppsNotifier.value = updatedList;
  }

  updateAppsNotifierWithHideStatus(updatedAppInfo)  {
    /// Update appsNotifier by replacing the element
    int appNotifierIndex = appsNotifier.value.indexWhere(
          (appInfo) => appInfo.packageName == updatedAppInfo.packageName,
    );

    if (appNotifierIndex != -1) {
      appsNotifier.value[appNotifierIndex] = updatedAppInfo;
      appsNotifier.value = List.from(appsNotifier.value); // Trigger update
    }
  }

  removeHiddenApp(AppInfo appInfo) {
    // TODO check again if correct
    appInfo.hide(false);
    var appsList = List.of(hiddenAppsNotifier.value);
    appsList.removeWhere((element) => element.packageName == appInfo.packageName);
    hiddenAppsNotifier.value = appsList;
    updateAppsNotifierWithHideStatus(appInfo);
  }

  handleAppEvent(ApplicationEvent event) async {
    print("[$runtimeType] received app event: ${event.event}, packageName: ${event.packageName}");
    if (!currentlySyncing) {
      currentlySyncing = true;
      await syncInstalledApps();
      currentlySyncing = false;
    }
  }

  syncInstalledApps() async {
    print("START SYNCING APPS");
    final stopwatch = Stopwatch()..start();
    List<Application> applications = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    List<AppInfo> apps = [];
    for (var app in applications) {
      if (IGNORED_APPS.contains(app.packageName)) {
        continue;
      }
      /// Check if the app is in hiddenAppsNotifier.value
      AppInfo hiddenApp = hiddenAppsNotifier.value
          .firstWhere((element) => element.packageName == app.packageName,
              orElse: () => AppInfo(packageName: "null", appName: "null"));

      if (hiddenApp.packageName != "null") {
        /// If found, use the stored AppInfo
        apps.add(hiddenApp);
      } else {
        /// If not found, create a new AppInfo
        apps.add(AppInfo(
          packageName: app.packageName,
          appName: app.appName,
          systemApp: app.systemApp,
        ));
      }
    }

    /// Sort from A-Z
    apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    appsNotifier.value = apps;
    print("[$runtimeType] syncInstalledApps() executed in ${stopwatch.elapsed.inMilliseconds}ms");
  }


  /// Load renamed or hidden apps from shared prefs
  loadHiddenAppsFromSharedPrefs() {
    hiddenAppsNotifier = ValueNotifier(List.generate(numberOfHiddenApps,
          (index) => AppInfo.fromJsonString(
        SharedPrefsManager.readData("renamedOrHiddenApp$index"),
      ),
    ));
  }

  /// Save renamed or hidden apps to shared prefs
  void saveAllHiddenAppsToSharedPrefs() {
    int i = 0;
    for (var appInfo in hiddenAppsNotifier.value) {
      SharedPrefsManager.saveData("renamedOrHiddenApp$i", appInfo.toJsonString());
      i++;
    }

    /// Save number of apps into shared prefs
    SharedPrefsManager.saveData(KEY_NUMBER_OF_RENAMED_OR_HIDDEN_APPS, hiddenAppsNotifier.value.length);
  }

  /// Save a new renamed or hidden app in shared prefs
  void saveNewHiddenAppToSharedPrefs(newAppInfo) {
    SharedPrefsManager.saveData(PREFIX_RENAMED_OR_HIDDEN_APPS + numberOfHiddenApps.toString(), newAppInfo.toJsonString());

    /// Update count of renamed or hidden apps
    numberOfHiddenApps += 1;
    SharedPrefsManager.saveData(KEY_NUMBER_OF_RENAMED_OR_HIDDEN_APPS, numberOfHiddenApps);
  }

  /// Update existing renamed or hidden app in shared prefs
  void updateHiddenAppInSharedPrefs(updatedAppInfo, index) {
    SharedPrefsManager.saveData(PREFIX_RENAMED_OR_HIDDEN_APPS + index.toString(), updatedAppInfo.toJsonString());
  }
}
