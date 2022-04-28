import 'package:mars_launcher/logic/apps_logic.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/temperature_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<SettingsLogic>(SettingsLogic());
  getIt.registerSingleton<PermissionService>(PermissionService());
  getIt.registerSingleton<AppsManager>(AppsManager());
  getIt.registerSingleton<ThemeManager>(ThemeManager());
  getIt.registerSingleton<AppShortcutsManager>(AppShortcutsManager());
  getIt.registerSingleton<TemperatureLogic>(TemperatureLogic());
}
