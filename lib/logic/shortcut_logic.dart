import 'package:flutter/widgets.dart';
import 'package:flutter_mars_launcher/services/storage_service/shared_prefs_manager.dart';

class AppShortcutsManager {
  final ValueNotifier<bool> weatherEnabledNotifier = ValueNotifier(false);
  final ValueNotifier<bool> clockEnabledNotifier = ValueNotifier(false);
  final ValueNotifier<bool> calendarEnabledNotifier = ValueNotifier(false);

  final ValueNotifier<int> numberOfShortcutItemsNotifier = ValueNotifier(4);

  AppShortcutsManager() {
    SharedPrefsManager.readData('isSwitchedWeather').then((value) {
      print('isSwitchedWeather value read from storage: ' + value.toString());
      weatherEnabledNotifier.value = value ?? true;
    });
    SharedPrefsManager.readData('isSwitchedClock').then((value) {
      print('isSwitchedClock value read from storage: ' + value.toString());
      clockEnabledNotifier.value = value ?? true;
    });
    SharedPrefsManager.readData('isSwitchedCalendar').then((value) {
      print('isSwitchedCalendar value read from storage: ' + value.toString());
      calendarEnabledNotifier.value = value ?? true;
    });

    SharedPrefsManager.readData('numOfShortcutItems').then((value) {
      print('numOfShortcutItems value read from storage: ' + value.toString());
      numberOfShortcutItemsNotifier.value = value ?? 4;
    });
  }

  void toggleEnable(String setting, bool value) {
    SharedPrefsManager.saveData(setting, value);
    if (setting == "isSwitchedWeather") {
      weatherEnabledNotifier.value = value;
    } else if (setting == "isSwitchedClock") {
      clockEnabledNotifier.value = value;
    } else if (setting == "isSwitchedCalendar") {
      calendarEnabledNotifier.value = value;
    }
  }

  void incNumberOfShortcutItems() {
    if (numberOfShortcutItemsNotifier.value < 7) {
      numberOfShortcutItemsNotifier.value++;
      SharedPrefsManager.saveData("numOfShortcutItems", numberOfShortcutItemsNotifier.value);
    }
  }

  void decNumberOfShortcutItems() {
    if (numberOfShortcutItemsNotifier.value > 0) {
        numberOfShortcutItemsNotifier.value--;
        SharedPrefsManager.saveData("numOfShortcutItems", numberOfShortcutItemsNotifier.value);
    }
  }
}
