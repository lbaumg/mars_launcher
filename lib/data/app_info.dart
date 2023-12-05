import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:mars_launcher/global.dart';


class AppInfo {
  final String packageName;
  final String appName;
  final bool systemApp;

  String? displayName;
  var isHidden;

  AppInfo({
    required this.packageName,
    required this.appName,
    this.systemApp = false,
    this.isHidden = false,
    this.displayName
  });

  String getDisplayName() {
    return displayName ?? appName;
  }

  void open() {
    if (this.packageName.isNotEmpty) {
      DeviceApps.openApp(this.packageName);
    } else {
      print("[$runtimeType] Could not open app: packageName is empty");
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
      systemApp = json[JSON_KEY_SYSTEM_APP],
      isHidden = json[JSON_KEY_APP_IS_HIDDEN],
      displayName = json[JSON_KEY_DISPLAY_NAME];

  Map<String, dynamic> toJson() => {
    JSON_KEY_PACKAGE_NAME: packageName,
    JSON_KEY_APP_NAME: appName,
    JSON_KEY_SYSTEM_APP: systemApp,
    JSON_KEY_APP_IS_HIDDEN: isHidden,
    JSON_KEY_DISPLAY_NAME: displayName,
  };

  static AppInfo fromJsonString(String? jsonString) {
    jsonString = jsonString ?? jsonEncode({JSON_KEY_PACKAGE_NAME: "", JSON_KEY_APP_NAME: UNINITIALIZED_APP_NAME, JSON_KEY_SYSTEM_APP: false});
    Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppInfo(
      packageName: json[JSON_KEY_PACKAGE_NAME],
      appName: json[JSON_KEY_APP_NAME],
      systemApp: json[JSON_KEY_SYSTEM_APP],
      isHidden: json[JSON_KEY_APP_IS_HIDDEN],
      displayName: json[JSON_KEY_DISPLAY_NAME],
    );
  }

  String toJsonString() => jsonEncode({
    JSON_KEY_PACKAGE_NAME: packageName,
    JSON_KEY_APP_NAME: appName,
    JSON_KEY_SYSTEM_APP: systemApp,
    JSON_KEY_APP_IS_HIDDEN: isHidden,
    JSON_KEY_DISPLAY_NAME: displayName
  });

  void changeDisplayName(newName) {
    displayName = newName;
  }

  void hide(bool value) {
    isHidden = value;
  }
}
