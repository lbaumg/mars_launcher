/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/services/shared_prefs_manager.dart';

const KEY_THEME_MODE = "themeMode";



class ThemeManager {
  late final themeModeNotifier;

  final darkTheme = ThemeData(
    primaryColor: Colors.white,
    fontFamily: 'NotoSansLight',
    scaffoldBackgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent))),
  );
  final lightTheme = ThemeData(
    primaryColor: Colors.black,
    fontFamily: 'NotoSansLight',
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent))),
  );
  final darkSystemUiOverlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.dark,
  );
  final lightSystemUiOverlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.light,
  );

  get currentTheme => themeModeNotifier.value ? darkTheme : lightTheme;
  get currentSystemUiOverlayStyle => themeModeNotifier.value ? darkSystemUiOverlayStyle : lightSystemUiOverlayStyle;

  ThemeManager() {
    themeModeNotifier = ValueNotifier<bool>(SharedPrefsManager.readData(KEY_THEME_MODE) ?? true);
  }

  void toggleDarkMode() {
    themeModeNotifier.value = !themeModeNotifier.value;
    SharedPrefsManager.saveData(KEY_THEME_MODE, themeModeNotifier.value);
  }

  void setBackgroundColor(Color color) {
    // TODO set color of current theme and systemUiOverlayStyle
  }
}
