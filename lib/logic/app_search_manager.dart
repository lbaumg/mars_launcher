import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/services/service_locator.dart';

enum AppSearchMode { openApp, chooseShortcut, chooseSpecialShortcut }

class AppSearchManager {
  final appsManager = getIt<AppsManager>();
  final appShortcutsManager = getIt<AppShortcutsManager>();
  late final ValueNotifier<List<AppInfo>> filteredAppsNotifier;

  /// Temporary parameters that are set when AppSearchFragment is initialized
  BuildContext? currentContext;
  AppSearchMode? appSearchMode;
  int? shortcutIndex;
  ValueNotifierWithKey<AppInfo>? specialShortcutAppNotifier;

  AppSearchManager() {
    filteredAppsNotifier = ValueNotifier(appsManager.appsNotifier.value.where((app) => !app.isHidden).toList());
    appsManager.appsNotifier.addListener(() {
      filteredAppsNotifier.value = appsManager.appsNotifier.value.where((app) => !app.isHidden).toList();
    });
  }

  setTemporaryParameters(BuildContext context, AppSearchMode appSearchMode, int? shortcutIndex,
      ValueNotifierWithKey<AppInfo>? specialShortcutAppNotifier) {
    this.currentContext = context;
    this.appSearchMode = appSearchMode;
    this.shortcutIndex = shortcutIndex;
    this.specialShortcutAppNotifier = specialShortcutAppNotifier;
  }

  resetFilteredList() async {
    filteredAppsNotifier.value = appsManager.appsNotifier.value.where((app) => !app.isHidden).toList();

    appSearchMode = currentContext = shortcutIndex = specialShortcutAppNotifier = null;
  }

  handleOnTap(AppInfo appInfo) {
    switch (appSearchMode) {
      case AppSearchMode.openApp:
        openApp(appInfo);
        break;
      case AppSearchMode.chooseShortcut:
        replaceShortcut(appInfo);
        break;
      case AppSearchMode.chooseSpecialShortcut:
        replaceSpecialShortcut(appInfo);
        break;
      case null:
        break;
    }

    if (currentContext != null) Navigator.popUntil(currentContext!, (route) => route.isFirst);
  }

  openApp(AppInfo appInfo) {
    appInfo.open();
  }

  replaceShortcut(AppInfo appInfo) {
    if (shortcutIndex != null) {
      print("[$runtimeType] Replacing shortcut app with index $shortcutIndex with ${appInfo.appName}");
      appShortcutsManager.shortcutAppsNotifier.replaceShortcut(shortcutIndex!, appInfo);
      if (currentContext != null) {
        Navigator.of(currentContext!).pop();
      }
    }
  }

  replaceSpecialShortcut(AppInfo appInfo) {
    if (specialShortcutAppNotifier != null) {
      print("[$runtimeType] Replacing special shortcut app ${specialShortcutAppNotifier!.key} with ${appInfo.appName}");
      appShortcutsManager.setSpecialShortcutValue(specialShortcutAppNotifier!, appInfo);
      if (currentContext != null) {
        Navigator.of(currentContext!).pop();
      }
    }
  }

  updateFilteredApps(String searchValue) {
    List<AppInfo> filteredApps = appsManager.appsNotifier.value
        .where((app) => app.appName.toLowerCase().contains(searchValue.toLowerCase()) && !app.isHidden)
        .toList();
    if (filteredApps.length == 1) {
      handleOnTap(filteredApps.first);
    }
    filteredAppsNotifier.value = filteredApps;
  }
}
