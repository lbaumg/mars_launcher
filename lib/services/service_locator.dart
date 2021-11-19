
import 'package:flutter_mars_launcher/home_page/home_logic.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AppsManager>(
          () => AppsManager()
  );
}