
import 'package:flutter/services.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';



class SettingsManager {
  final ValueNotifierWithKey<bool> weatherWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(Keys.weatherEnabled) ?? false, Keys.weatherEnabled);
  final ValueNotifierWithKey<bool> clockWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(Keys.clockEnabled) ?? true, Keys.clockEnabled);
  final ValueNotifierWithKey<bool> batteryWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(Keys.batteryEnabled) ?? true, Keys.batteryEnabled);
  final ValueNotifierWithKey<bool> calendarWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(Keys.calendarEnabled) ?? true, Keys.calendarEnabled);
  final ValueNotifierWithKey<int> numberOfShortcutItemsNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(Keys.numOfShortcutItems) ?? 6, Keys.numOfShortcutItems);
  final ValueNotifierWithKey<bool> shortcutMode = ValueNotifierWithKey(SharedPrefsManager.readData(Keys.shortcutMode) ?? true, Keys.shortcutMode);

  bool isFirstStartup = SharedPrefsManager.readData(Keys.isFirstStartup) ?? true;

  SettingsManager() {
    /// Ask on first startup to be default launcher
    if (isFirstStartup) {
      isFirstStartup = false;
      SharedPrefsManager.saveData(Keys.isFirstStartup, false);

      openDefaultLauncherSettings();
    }
  }

  void setNotifierValueAndSave(ValueNotifierWithKey notifier) {
    switch (notifier.key) {
      case Keys.shortcutMode:
      case Keys.weatherEnabled:
      case Keys.clockEnabled:
      case Keys.calendarEnabled:
      case Keys.batteryEnabled:
        notifier.value = !notifier.value;
        break;
      case Keys.numOfShortcutItems:
        notifier.value = (notifier.value + 1) % (MAX_NUM_OF_SHORTCUT_ITEMS+1);
    }
    SharedPrefsManager.saveData(notifier.key, notifier.value);
  }


  Future<void> openDefaultLauncherSettings() async {
    const platform = MethodChannel('com.cloudcatcher.launcher/settings');
    try {
      await platform.invokeMethod('openLauncherSettings');
    } on PlatformException catch (e) {
      throw 'Could not launch launcher settings: ${e.message}';
    }
  }
}