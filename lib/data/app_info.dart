
import 'package:device_apps/device_apps.dart';

class AppInfo {

  String packageName;
  String appName;

  AppInfo({required this.packageName, required this.appName});
  
  void open() {
    DeviceApps.openApp(this.packageName);
  }

}

