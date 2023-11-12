import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mars_launcher/pages/home.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  prefs = await SharedPreferences.getInstance();
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
      builder: (context, themeMode, homeScreen) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
              value: themeManager.systemUiOverlayStyle,
              child: Sizer(
                  builder: (context, orientation, deviceType) {
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: themeManager.theme,
                      home: homeScreen!);
                }
              )),
      child: Home(),
    );
  }
}
