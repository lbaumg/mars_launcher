import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/pages/home.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

late SharedPreferences prefs;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // ensurePermissions();
  setupGetIt();

  runApp(MarsLauncher());
}

class MarsLauncher extends StatelessWidget {
  final themeManager = getIt<ThemeManager>();

  MarsLauncher({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeManager.themeModeNotifier,
      builder: (context, themeMode, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeMode ? themeManager.darkTheme : themeManager.lightTheme,
          home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: themeMode ? themeManager.darkSystemUiOverlayStyle : themeManager.lightSystemUiOverlayStyle,
              child: child!),
        ),
      child: Home(),
    );
  }
}
