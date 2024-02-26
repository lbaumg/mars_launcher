import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
import 'package:mars_launcher/logic/battery_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/logic/todo_manager.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future setupGetIt() async {
  getIt.registerSingleton<SharedPrefsManager>(await SharedPrefsManager.getInstance());
  getIt.registerSingleton<SettingsManager>(SettingsManager());
  getIt.registerSingleton<PermissionService>(PermissionService());
  getIt.registerSingleton<AppsManager>(AppsManager());
  getIt.registerSingleton<ThemeManager>(ThemeManager());
  getIt.registerSingleton<AppShortcutsManager>(AppShortcutsManager());
  getIt.registerSingleton<AppSearchManager>(AppSearchManager());
  /* WEATHER_DISABLED
   getIt.registerSingleton<TemperatureManager>(TemperatureManager());
  */
  getIt.registerSingleton<BatteryManager>(BatteryManager());
  getIt.registerSingleton<TodoManager>(TodoManager());
}
