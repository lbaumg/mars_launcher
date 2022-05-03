/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';

const KEY_THEME_MODE = "themeMode";
const KEY_LIGHT_COLOR_INDEX = "light_color_index";
const KEY_DARK_COLOR_INDEX = "dark_color_index";

const LIGHT_BACKGROUND_COLORS = [
  const Color(0xffffffff),
  const Color(0xffffdab9),
  const Color(0xffedf6f9),
  const Color(0xffcaf0f8),
  const Color(0xffe9f5db),
  const Color(0xfffad2e1),
  const Color(0xfff0efeb),
  const Color(0xffc9e4de),
  const Color(0xffffcbf2)
];
const DARK_BACKGROUND_COLORS = [
  const Color(0xff000000),
  const Color(0xff00111c), // 0xff00141f
  const Color(0xff11001c),
  const Color(0xff25000e),
  const Color(0xff0d060f),
  const Color(0xff00020b), //
  const Color(0xff000b14), //
  const Color(0xff001609),
  const Color(0xff001609),
];

const lightSearchColor = Colors.deepOrange;
const lightBackgroundTextColor = Colors.black;
const darkSearchColor = Colors.white70;
const darkBackgroundTextColor = Colors.white;

class ThemeManager {
  late final ThemeModeNotifier<bool> themeModeNotifier;
  late var darkBackgroundColor;
  late var lightBackgroundColor;

  ThemeManager() {
    themeModeNotifier = ThemeModeNotifier<bool>(SharedPrefsManager.readData(KEY_THEME_MODE) ?? true);
    lightBackgroundColor = LIGHT_BACKGROUND_COLORS[SharedPrefsManager.readData(KEY_LIGHT_COLOR_INDEX) ?? 0];
    darkBackgroundColor = DARK_BACKGROUND_COLORS[SharedPrefsManager.readData(KEY_DARK_COLOR_INDEX) ?? 0];
  }

  get theme {
    final backgroundTextColor = themeModeNotifier.value ? darkBackgroundTextColor : lightBackgroundTextColor;
    final searchItemColor = themeModeNotifier.value ? Colors.white70 : Colors.deepOrange;
    final backgroundColor = themeModeNotifier.value ? darkBackgroundColor : lightBackgroundColor;

    return ThemeData(
      primaryColor: backgroundTextColor,
      disabledColor: searchItemColor, // search item color
      fontFamily: 'NotoSansLight',
      scaffoldBackgroundColor: backgroundColor,
      iconTheme: IconThemeData(
        color: backgroundTextColor,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: backgroundTextColor,
        displayColor: backgroundTextColor,
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  backgroundTextColor),
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.transparent))),
    );
  }

  get systemUiOverlayStyle {
    final backgroundColor = themeModeNotifier.value ? darkBackgroundColor : lightBackgroundColor;
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

  void setBackgroundColor(bool darkMode, int colorIndex) {
    if (darkMode) {
      darkBackgroundColor = DARK_BACKGROUND_COLORS[colorIndex];
      SharedPrefsManager.saveData(KEY_DARK_COLOR_INDEX, colorIndex);
    } else {
      lightBackgroundColor = LIGHT_BACKGROUND_COLORS[colorIndex];
      SharedPrefsManager.saveData(KEY_LIGHT_COLOR_INDEX, colorIndex);
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
