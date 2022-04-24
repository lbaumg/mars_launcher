import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter_mars_launcher/global.dart';


class AppInfo {
  String packageName;
  String appName;
  bool systemApp;


  AppInfo({
    required this.packageName,
    required this.appName,
    this.systemApp = false
  });

  void open() {
    if (this.packageName.isNotEmpty) {
      DeviceApps.openApp(this.packageName);
    } else {
      print("Could not open app: packageName is empty");
    }
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
      : packageName = json[JSON_KEY_PACKAGE_NAME],
        appName = json[JSON_KEY_APP_NAME],
        systemApp = json[JSON_KEY_SYSTEM_APP];

  Map<String, dynamic> toJson() => {
          JSON_KEY_PACKAGE_NAME: packageName,
          JSON_KEY_APP_NAME: appName,
          JSON_KEY_SYSTEM_APP: systemApp
        };

  static AppInfo fromJsonString(String? jsonString) {
    jsonString = jsonString ?? jsonEncode({JSON_KEY_PACKAGE_NAME: "", JSON_KEY_APP_NAME: "select", JSON_KEY_SYSTEM_APP: false});
    Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppInfo(packageName: json[JSON_KEY_PACKAGE_NAME], appName: json[JSON_KEY_APP_NAME], systemApp: json[JSON_KEY_SYSTEM_APP]);
  }

  String toJsonString() => jsonEncode({
    JSON_KEY_PACKAGE_NAME: packageName,
    JSON_KEY_APP_NAME: appName,
    JSON_KEY_SYSTEM_APP: systemApp
  });
}
