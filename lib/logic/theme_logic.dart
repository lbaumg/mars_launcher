/// All logic according to dark and light theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/services/storage_service/shared_prefs_manager.dart';

class ThemeManager {
  final darkModeNotifier = DarkModeNotifier();

  final darkTheme = ThemeData(
    primaryColor: Colors.white,
    fontFamily: 'NotoSansLight',
    scaffoldBackgroundColor: Colors.black,
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
            overlayColor:
                MaterialStateProperty.all<Color>(Colors.transparent))),
  );
  final lightTheme = ThemeData(
    primaryColor: Colors.black,
    fontFamily: 'NotoSansLight',
    scaffoldBackgroundColor: Colors.white,
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
            overlayColor:
                MaterialStateProperty.all<Color>(Colors.transparent))),
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

  ThemeManager() {
    SharedPrefsManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? true;
      darkModeNotifier.setMode(themeMode);
    });
  }

  void toggleDarkMode() {
    bool newMode = !darkModeNotifier.isDarkMode();
    SharedPrefsManager.saveData('themeMode', newMode);
    darkModeNotifier.toggleMode();
  }
}

class DarkModeNotifier extends ValueNotifier<bool> {
  DarkModeNotifier() : super(true);

  bool isDarkMode() => value;

  void setMode(bool mode) {
    value = mode;
  }

  void toggleMode() {
    value = !value;
  }
}
