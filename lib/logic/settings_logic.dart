
import 'package:flutter/services.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';

const KEY_WEATHER_ENABLED = "weatherEnabled";
const KEY_CLOCK_ENABLED = "clockEnabled";
const KEY_BATTERY_ENABLED = "batteryEnabled";
const KEY_CALENDAR_ENABLED = "calendarEnabled";
const KEY_NUM_OF_SHORTCUT_ITEMS = "numOfShortcutItems";
const KEY_SHORTCUT_MODE = "shortcutMode";

class SettingsLogic {
  final ValueNotifierWithKey<bool> weatherWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(KEY_WEATHER_ENABLED) ?? false, KEY_WEATHER_ENABLED);
  final ValueNotifierWithKey<bool> clockWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(KEY_CLOCK_ENABLED) ?? true, KEY_CLOCK_ENABLED);
  final ValueNotifierWithKey<bool> batteryWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(KEY_BATTERY_ENABLED) ?? true, KEY_BATTERY_ENABLED);
  final ValueNotifierWithKey<bool> calendarWidgetEnabledNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(KEY_CALENDAR_ENABLED) ?? true, KEY_CALENDAR_ENABLED);
  final ValueNotifierWithKey<int> numberOfShortcutItemsNotifier = ValueNotifierWithKey(SharedPrefsManager.readData(KEY_NUM_OF_SHORTCUT_ITEMS) ?? 6, KEY_NUM_OF_SHORTCUT_ITEMS);
  final ValueNotifierWithKey<bool> shortcutMode = ValueNotifierWithKey(SharedPrefsManager.readData(KEY_SHORTCUT_MODE) ?? true, KEY_SHORTCUT_MODE);

  void setNotifierValueAndSave(ValueNotifierWithKey notifier) {
    switch (notifier.key) {
      case KEY_SHORTCUT_MODE:
      case KEY_WEATHER_ENABLED:
      case KEY_CLOCK_ENABLED:
      case KEY_CALENDAR_ENABLED:
      case KEY_BATTERY_ENABLED:
        notifier.value = !notifier.value;
        break;
      case KEY_NUM_OF_SHORTCUT_ITEMS:
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