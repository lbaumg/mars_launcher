import 'package:flutter_mars_launcher/home_page/notifiers/apps_notifier.dart';
import 'package:flutter_mars_launcher/home_page/notifiers/shortcut_apps_notifier.dart';


class AppsManager {
  final appsListNotifier = AppsNotifier();
  final shortcutAppsNotifier = ShortcutAppsNotifier();

  syncInstalledApps() { appsListNotifier.syncInstalledApps(); }
}