import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/battery_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/logic/temperature_manager.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/logic/todo_manager.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<SettingsManager>(SettingsManager());
  getIt.registerSingleton<PermissionService>(PermissionService());
  getIt.registerSingleton<AppsManager>(AppsManager());
  getIt.registerSingleton<ThemeManager>(ThemeManager());
  getIt.registerSingleton<AppShortcutsManager>(AppShortcutsManager());
  getIt.registerSingleton<TemperatureManager>(TemperatureManager());
  getIt.registerSingleton<BatteryManager>(BatteryManager());
  getIt.registerSingleton<TodoManager>(TodoManager());
}
