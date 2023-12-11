/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';



// const FONT_LIGHT = "TitilliemWebLight";
// const FONT_REGULAR = "TitilliemWebRegular";

const FONT_LIGHT = "NotoSansLight";
const FONT_REGULAR = "NotoSansRegular";

const COLOR_ACCENT = Color(0xffc9184a);

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
      background: Color(SharedPrefsManager.readData(Keys.lightBackground) ?? Colors.white.value),
      textColor: Colors.black,
      searchTextColor:
          Color(SharedPrefsManager.readData(Keys.lightSearchColor) ?? COLOR_ACCENT.value) // Colors.deepOrange.value)
      );

  final darkMode = ThemeColors(
      background: Color(SharedPrefsManager.readData(Keys.darkBackground) ?? Colors.black.value),
      textColor: Colors.white,
      searchTextColor:
          Color(SharedPrefsManager.readData(Keys.darkSearchColor) ?? COLOR_ACCENT.value) // Colors.deepOrange.value)
      );

  ThemeManager() {
    themeModeNotifier = ThemeModeNotifier<bool>(SharedPrefsManager.readData(Keys.themeMode) ?? true);
  }

  ThemeData get theme {
    final isDarkMode = themeModeNotifier.value;

    late final backgroundTextColor;
    late final searchItemColor;
    late final backgroundColor;
    late final brightness;
    late final colorScheme;

    if (isDarkMode) {
      backgroundTextColor = darkMode.textColor;
      searchItemColor = darkMode.searchTextColor;
      backgroundColor = darkMode.background;
      brightness = Brightness.light;
      colorScheme = ColorScheme.light(primary: Colors.white);
    } else {
      backgroundTextColor = lightMode.textColor;
      searchItemColor = lightMode.searchTextColor;
      backgroundColor = lightMode.background;
      brightness = Brightness.dark;
      colorScheme =  ColorScheme.dark(primary: Colors.white);
    }

    final dialogBackgroundColor = backgroundColor;

    return ThemeData(
      dialogBackgroundColor: dialogBackgroundColor,
      colorScheme: colorScheme,
      primaryColor: backgroundTextColor,
      disabledColor: searchItemColor,
      // search item color
      fontFamily: FONT_LIGHT,
      scaffoldBackgroundColor: backgroundColor,
      brightness: brightness,
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
              overlayColor: MaterialStateProperty.all<Color>(backgroundColor))),
    );
  }

  get systemUiOverlayStyle {
    final backgroundColor = themeModeNotifier.value ? darkMode.background : lightMode.background;
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
    SharedPrefsManager.saveData(Keys.themeMode, themeModeNotifier.value);
  }

  void setBackgroundColor(bool isDarkMode, Color color) {
    if (isDarkMode) {
      darkMode.background = color;
      SharedPrefsManager.saveData(Keys.darkBackground, color.value);
    } else {
      lightMode.background = color;
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
