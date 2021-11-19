import 'package:flutter_mars_launcher/home_page/notifiers/apps_notifier.dart';
import 'package:flutter_mars_launcher/home_page/notifiers/shortcut_apps_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppsManager {
  final appsNotifier = AppsNotifier();
  final shortcutAppsNotifier = ShortcutAppsNotifier();

  AppsManager() {
    syncInstalledApps();
  }

  syncInstalledApps() { appsNotifier.syncInstalledApps(); }

  saveShortcutsToDisk() async {
    final prefs = await SharedPreferences.getInstance();
  }

  getShortcutsFromDisk() async{
    final prefs = await SharedPreferences.getInstance();

  }




}