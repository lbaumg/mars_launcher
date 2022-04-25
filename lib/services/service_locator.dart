import 'package:flutter_mars_launcher/logic/apps_logic.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/logic/temperature_logic.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<AppsManager>(AppsManager());
  getIt.registerSingleton<ThemeManager>(ThemeManager());
  getIt.registerSingleton<AppShortcutsManager>(AppShortcutsManager());
  getIt.registerSingleton<TemperatureLogic>(TemperatureLogic());
}
