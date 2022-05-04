/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';

const KEY_THEME_MODE = "themeMode";
const KEY_LIGHT_COLOR_INDEX = "light_color_index";
const KEY_DARK_COLOR_INDEX = "dark_color_index";

class ColorTup {
  final Color background;
  final Color search;
  const ColorTup(this.background, this.search);
}

const LIGHT_COLORS = [
  ColorTup(const Color(0xffffffff), const Color(0xff14333E)),
  ColorTup(const Color(0xffedf6f9), const Color(0xff14343E)),
  ColorTup(const Color(0xffFFE9D6), const Color(0xff291400)),
  ColorTup(const Color(0xffDBF5FA), const Color(0xff072E36)),
  ColorTup(const Color(0xffe9f5db), const Color(0xff162009)),
  ColorTup(const Color(0xfffad2e1), const Color(0xff370618)),
  ColorTup(const Color(0xfff0efeb), const Color(0xff23211A)),
  ColorTup(const Color(0xffc9e4de), const Color(0xff152823)),
  ColorTup(const Color(0xffffcbf2), const Color(0xff29001F))
];
const DARK_COLORS = [
  ColorTup(const Color(0xff000000), Colors.deepOrange),
  ColorTup(const Color(0xff00111c), const Color(0xffD6EFFF)), // 0xff00141,
  ColorTup(const Color(0xff11001c), const Color(0xffF6EBFF)),
  ColorTup(const Color(0xff140008), const Color(0xffFFC2D9)),
  ColorTup(const Color(0xff0d060f), const Color(0xffF7F1F9)),
  ColorTup(const Color(0xff00020b), const Color(0xffEBEFFF)),
  ColorTup(const Color(0xff000b14), const Color(0xffEBF5FF)),
  ColorTup(const Color(0xff272316), const Color(0xffE9E5D8)),
  ColorTup(const Color(0xff001609), const Color(0xffD6FFE7))
];

const lightSearchColor = Colors.deepOrange;
const lightBackgroundTextColor = Colors.black;
const darkSearchColor = Colors.white70;
const darkBackgroundTextColor = Colors.white;

class ThemeManager {
  late final ThemeModeNotifier<bool> themeModeNotifier;
  late var lightColorIndex;
  late var darkColorIndex;

  ThemeManager() {
    themeModeNotifier = ThemeModeNotifier<bool>(SharedPrefsManager.readData(KEY_THEME_MODE) ?? true);
    lightColorIndex = SharedPrefsManager.readData(KEY_LIGHT_COLOR_INDEX) ?? 0;
    darkColorIndex = SharedPrefsManager.readData(KEY_DARK_COLOR_INDEX) ?? 0;
  }

  get theme {
    final backgroundTextColor = themeModeNotifier.value ? darkBackgroundTextColor : lightBackgroundTextColor;
    final searchItemColor = themeModeNotifier.value ? DARK_COLORS[darkColorIndex].search : LIGHT_COLORS[lightColorIndex].search;
    final backgroundColor = themeModeNotifier.value ? DARK_COLORS[darkColorIndex].background : LIGHT_COLORS[lightColorIndex].background;

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
    final backgroundColor = themeModeNotifier.value ? DARK_COLORS[darkColorIndex].background : LIGHT_COLORS[lightColorIndex].background;
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
      darkColorIndex = colorIndex;
      SharedPrefsManager.saveData(KEY_DARK_COLOR_INDEX, colorIndex);
    } else {
      lightColorIndex = colorIndex;
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
