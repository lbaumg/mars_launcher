/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';

const KEY_THEME_MODE = "themeMode";

const KEY_LIGHT_BACKGROUND = "light_background";
const KEY_LIGHT_SEARCH_COLOR = "light_search_color";
const KEY_DARK_BACKGROUND = "dark_background";
const KEY_DARK_SEARCH_COLOR = "dark_search_color";

// const FONT_LIGHT = "TitilliemWebLight";
// const FONT_REGULAR = "TitilliemWebRegular";

const FONT_LIGHT = "NotoSansLight";
const FONT_REGULAR = "NotoSansRegular";


class ThemeColors {
  Color background;
  final Color textColor;
  final Color searchTextColor;

  ThemeColors({
    required this.background,
    required this.textColor,
    required this.searchTextColor,
  });
}

class ThemeManager {
  late final ThemeModeNotifier<bool> themeModeNotifier;

  final lightMode = ThemeColors(
    background: Color(SharedPrefsManager.readData(KEY_LIGHT_BACKGROUND) ?? Colors.white.value),
    textColor: Colors.black,
    searchTextColor: Color(SharedPrefsManager.readData(KEY_LIGHT_SEARCH_COLOR) ?? Colors.deepOrange.value)
  );

  final darkMode = ThemeColors(
    background: Color(SharedPrefsManager.readData(KEY_DARK_BACKGROUND) ?? Colors.black.value),
    textColor: Colors.white,
    searchTextColor: Color(SharedPrefsManager.readData(KEY_DARK_SEARCH_COLOR) ?? Colors.deepOrange.value)
  );

  ThemeManager() {
    themeModeNotifier = ThemeModeNotifier<bool>(SharedPrefsManager.readData(KEY_THEME_MODE) ?? true);
  }

  get theme {
    final backgroundTextColor = themeModeNotifier.value ? darkMode.textColor : lightMode.textColor;
    final searchItemColor = themeModeNotifier.value ? darkMode.searchTextColor : lightMode.searchTextColor;
    final backgroundColor = themeModeNotifier.value ? darkMode.background: lightMode.background;

    return ThemeData(
      primaryColor: backgroundTextColor,
      disabledColor: searchItemColor, // search item color
      fontFamily: 'NotoSansLight',
      scaffoldBackgroundColor: backgroundColor,
      iconTheme: IconThemeData(
        color: backgroundTextColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
      ).apply(
        bodyColor: backgroundTextColor,
        displayColor: backgroundTextColor,
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(backgroundTextColor),
              overlayColor: MaterialStateProperty.all<Color>(backgroundColor)
          )
      ),
    );
  }

  get systemUiOverlayStyle {
    final backgroundColor = themeModeNotifier.value ? darkMode.background: lightMode.background;
    final brightness = themeModeNotifier.value ? Brightness.light : Brightness.dark;
    final brightnessInverted = themeModeNotifier.value ? Brightness.dark : Brightness.light;

    return SystemUiOverlayStyle(
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: brightness,
      statusBarColor: backgroundColor,
      statusBarIconBrightness: brightnessInverted,
    );
  }

  void toggleDarkMode() {
    themeModeNotifier.value = !themeModeNotifier.value;
    SharedPrefsManager.saveData(KEY_THEME_MODE, themeModeNotifier.value);
  }

  void setBackgroundColor(bool isDarkMode, Color color) {
    if (isDarkMode) {
      darkMode.background = color;
      SharedPrefsManager.saveData(KEY_DARK_BACKGROUND, color.value);
    } else {
      lightMode.background = color;
      SharedPrefsManager.saveData(KEY_LIGHT_BACKGROUND, color.value);
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
