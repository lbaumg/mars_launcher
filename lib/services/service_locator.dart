import 'package:flutter_mars_launcher/logic/apps_logic.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AppsManager>(() => AppsManager());
  getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());
  getIt.registerLazySingleton<AppShortcutsManager>(() => AppShortcutsManager());
}
