import 'package:flutter_mars_launcher/logic/notifiers/apps_notifier.dart';

class AppsManager {
  final appsNotifier = AppsNotifier();

  AppsManager() {
    print("INITIALISING AppsManager");
    syncInstalledApps();
  }

  syncInstalledApps() {
    appsNotifier.syncInstalledApps();
  }


}
