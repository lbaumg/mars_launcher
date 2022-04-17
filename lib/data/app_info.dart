import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';


class AppInfo {
  String packageName;
  String appName;
  bool systemApp;

  AppInfo(
      {required this.packageName,
      required this.appName,
      this.systemApp = false});

  void open() {
    DeviceApps.openApp(this.packageName);
  }

  void uninstall() async {
      final AndroidIntent intent = AndroidIntent(
        action: "android.intent.action.DELETE",
        data: "package:${this.packageName}",
      );
      await intent.launch();
  }

  void openSettings() {
    DeviceApps.openAppSettings(this.packageName);
  }

  AppInfo.fromJson(Map<String, dynamic> json)
      : packageName = json['packageName'],
        appName = json['appName'],
        systemApp = json['systemApp'];

  Map<String, dynamic> toJson() =>
      {'packageName': packageName, 'appName': appName, 'systemApp': systemApp};
}
