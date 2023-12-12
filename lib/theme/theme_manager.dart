/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';
import 'package:mars_launcher/theme/theme_constants.dart';


class ThemeManager {
  final themeModeNotifier = ThemeModeNotifier<ThemeMode>(
    SharedPrefsManager.readDataWithDefault(Keys.themeMode, true) ? ThemeMode.dark : ThemeMode.light
  );

  Color lightBackground = Color(SharedPrefsManager.readData(Keys.lightBackground) ?? Colors.white.value);
  Color darkBackground = Color(SharedPrefsManager.readData(Keys.darkBackground) ?? Colors.black.value);
  Color searchTextColor = Color(SharedPrefsManager.readData(Keys.lightSearchColor) ?? COLOR_ACCENT.value);

  bool get isDarkMode {
    print("ThemeMode: ${themeModeNotifier.value}, isDarkMode: ${themeModeNotifier.value == ThemeMode.dark}");
    return themeModeNotifier.value == ThemeMode.dark;
  }

  ThemeData get lightTheme {
    return basicLightTheme.copyWith(scaffoldBackgroundColor: lightBackground);
  }

  ThemeData get darkTheme {
    return basicDarkTheme.copyWith(scaffoldBackgroundColor: darkBackground);
  }

  get systemUiOverlayStyle {
    final systemUiOverlayStyle = isDarkMode ?
    lightSystemUiOverlayStyle.copyWith(systemNavigationBarColor: darkBackground, statusBarColor: darkBackground) :
    darkSystemUiOverlayStyle.copyWith(systemNavigationBarColor: lightBackground, statusBarColor: lightBackground);

    return systemUiOverlayStyle;
  }

  void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.light) {
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      themeModeNotifier.value = ThemeMode.light;
    }
    SharedPrefsManager.saveData(Keys.themeMode, isDarkMode);
    print("Changed themeMode to ${themeModeNotifier.value}");
  }

  void setBackgroundColor(bool isDarkMode, Color color) {
    if (isDarkMode) {
      darkBackground = color;
      SharedPrefsManager.saveData(Keys.darkBackground, color.value);
    } else {
      lightBackground = color;
      SharedPrefsManager.saveData(Keys.lightBackground, color.value);
    }
    themeModeNotifier.notify();
  }
}

class ThemeModeNotifier<T> extends ValueNotifier<T> {
  ThemeModeNotifier(T value) : super(value);

  void notify() {
    notifyListeners();
  }
}
