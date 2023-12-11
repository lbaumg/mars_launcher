import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';



class AppsManager {
  /// LIST of INSTALLED APPs
  final appsNotifier = ValueNotifier<List<AppInfo>>([]);

  /// LIST of HIDDEN APPs (as packageName)
  final ValueNotifier<Set<String>> hiddenAppsNotifier = ValueNotifier((SharedPrefsManager.readStringList(Keys.hiddenApps) ?? []).toSet());

  /// MAP of RENAMED APPs
  final Map<String, String> renamedApps = {}; /// {"packageName": "displayName"}
  final ValueNotifier<bool> renamedAppsUpdatedNotifier = ValueNotifier(false);

  var currentlySyncing = false;

  AppsManager() {
    print("[$runtimeType] INITIALISING");

    loadRenamedAppsFromSharedPrefs();

    syncInstalledApps();

    /// Listen to change of apps (install/uninstall)
    DeviceApps.listenToAppsChanges().where((event) => event.event != ApplicationEventType.updated).listen((event) {handleAppEvent(event);});
  }

  void addOrUpdateRenamedApp(AppInfo appInfo, String newName) {
    if (appInfo.appName == newName) {
      renamedApps.remove(appInfo.packageName);
    } else {
      renamedApps[appInfo.packageName] = newName;
    }

    int appNotifierIndex = appsNotifier.value.indexWhere(
          (oldAppInfo) => oldAppInfo.packageName == appInfo.packageName,
    );
    if (appNotifierIndex != -1) {
      appsNotifier.value[appNotifierIndex].changeDisplayName(newName);
      appsNotifier.value.sort((a, b) => a.getDisplayName().toLowerCase().compareTo(b.getDisplayName().toLowerCase()));
      appsNotifier.value = List.from(appsNotifier.value); // Trigger update
    }

    /// Notify that renamedApps have been updated
    renamedAppsUpdatedNotifier.value = !renamedAppsUpdatedNotifier.value;

    saveRenamedAppsToSharedPrefs();
  }

  void updateHiddenApps(String packageName, bool hide) {
    var updatedHiddenApps = Set.of(hiddenAppsNotifier.value);

    if (hide) { /// Add to hiddenApps if hide==true
      updatedHiddenApps.add(packageName);
    } else { /// Remove from hiddenApps if hide==false
      updatedHiddenApps.remove(packageName);
    }
    hiddenAppsNotifier.value = updatedHiddenApps;

    /// Save to shared prefs
    SharedPrefsManager.saveData(Keys.hiddenApps, hiddenAppsNotifier.value.toList());

    /// Update appsNotifier
    updateAppsNotifierWithHideStatus(packageName, hide);
  }

  updateAppsNotifierWithHideStatus(String hiddenAppPackageName, bool hideStatus)  {
    /// Update appsNotifier by replacing the element
    var appsCopy = List.of(appsNotifier.value);
    int appNotifierIndex = appsCopy.indexWhere(
          (appInfo) => appInfo.packageName == hiddenAppPackageName,
    );
    if (appNotifierIndex != -1) {
      appsCopy[appNotifierIndex].isHidden = hideStatus;
      appsNotifier.value = appsCopy; /// Trigger update
    }
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
      if (app.packageName == PACKAGE_NAME) {
        continue;
      }

      AppInfo appInfo = AppInfo(
        packageName: app.packageName,
        appName: app.appName,
        systemApp: app.systemApp,
        isHidden: hiddenAppsNotifier.value.contains(app.packageName), /// If in hiddenApps set hide status true else false
        displayName: renamedApps[app.packageName] /// Get display name if in renamedApps else null
      );

      apps.add(appInfo);
    }

    /// Sort from A-Z
    apps.sort((a, b) => a.getDisplayName().toLowerCase().compareTo(b.getDisplayName().toLowerCase()));
    appsNotifier.value = apps;
    print("[$runtimeType] syncInstalledApps() executed in ${stopwatch.elapsed.inMilliseconds}ms");
  }

  loadRenamedAppsFromSharedPrefs() {
    final jsonString = SharedPrefsManager.readData(Keys.renamedApps);

    if (jsonString != null) {
      final Map<String, dynamic> loadedMap = json.decode(jsonString);
      renamedApps.clear();
      loadedMap.forEach((key, value) {
        renamedApps[key] = value;
      });
    }
  }

  saveRenamedAppsToSharedPrefs() {
    final jsonString = json.encode(renamedApps);
    SharedPrefsManager.saveData(Keys.renamedApps, jsonString);
  }
}
