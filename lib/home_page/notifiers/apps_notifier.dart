import 'dart:collection';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';

class AppsNotifier extends ValueNotifier<List<AppInfo>> {

  AppsNotifier() : super([]) {
    syncInstalledApps();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  final List<AppInfo> _apps = [];


  UnmodifiableListView<AppInfo> get apps => UnmodifiableListView(_apps);



  void removeAll() {
    value.clear();
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
      value.add(appInfo);
    }
    value.sort((a, b) =>
        a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    notifyListeners();
  }
}