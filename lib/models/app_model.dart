import 'dart:collection';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';


class AppModel extends ChangeNotifier {

  final List<AppInfo> _apps = [];
  final List<AppInfo> _shortcutApps = [
    AppInfo(packageName: "com.wetter.androidclient", appName: "wetter.com"),
    AppInfo(packageName: "com.huawei.health", appName: "Health"),
    AppInfo(packageName: "com.spotify.music", appName: "Spotify"),
    AppInfo(packageName: "com.brave.browser", appName: "Brave"),
  ];

  UnmodifiableListView<AppInfo> get apps => UnmodifiableListView(_apps);
  UnmodifiableListView<AppInfo> get shortcutApps => UnmodifiableListView(_shortcutApps);

  AppModel() {
    syncInstalledApps();
  }

/*    void add(AppInfo appInfo) {
    _apps.add(appInfo);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }*/

  void replaceShortcut(int index, AppInfo newShortcutApp) {
    if (0 < index && index > 3) {
      return;
    }

    _shortcutApps[index] = newShortcutApp;
    notifyListeners();
  }


  void removeAll() {
    _apps.clear();
    notifyListeners();
  }

  syncInstalledApps() async {
    // _apps.clear();
    removeAll();
    List<Application> applications = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    for (int i = 0; i < applications.length; i++) {
      Application app = applications[i];

      if (IGNORED_APPS.contains(app.appName)) {
        continue;
      }
      AppInfo appInfo = AppInfo(
          packageName: app.packageName,
          appName: app.appName,
          systemApp: app.systemApp
      );
      _apps.add(appInfo);
    }
    _apps.sort((a, b) =>
        a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    notifyListeners();
  }
}
