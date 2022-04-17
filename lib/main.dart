import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/home_page/home.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';

void main() {
  setupGetIt();
  final themeManager = getIt<ThemeManager>();

  runApp(ValueListenableBuilder<bool>(
    valueListenable: themeManager.darkModeNotifier,
    builder: (context, themeMode, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeMode ? themeManager.darkTheme : themeManager.lightTheme,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: themeMode ? themeManager.darkSystemUiOverlayStyle : themeManager.lightSystemUiOverlayStyle,
            child: Home()),
      );
    },
  ));
}
