import 'package:flutter_mars_launcher/logic/notifiers/apps_notifier.dart';
import 'package:flutter_mars_launcher/logic/notifiers/shortcut_apps_notifier.dart';

class AppsManager {
  final appsNotifier = AppsNotifier();
  final shortcutAppsNotifier = ShortcutAppsNotifier();

  AppsManager() {
    syncInstalledApps();
  }

  syncInstalledApps() {
    appsNotifier.syncInstalledApps();
  }
}
