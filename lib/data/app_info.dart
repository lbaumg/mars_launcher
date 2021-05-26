
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:intent/intent.dart' as androidIntent;
import 'package:intent/action.dart' as androidAction;

class AppInfo {

  String packageName;
  String appName;
  bool systemApp;

  AppInfo({required this.packageName, required this.appName, this.systemApp=false});

  void open() {
    DeviceApps.openApp(this.packageName);
  }

  void uninstall() {
    androidIntent.Intent()
      ..setAction(androidAction.Action.ACTION_DELETE)
      ..setData(Uri.parse("package:${this.packageName}"))
      ..startActivityForResult().then((data) {
        print(data);
      }, onError: (e) {
        print(e);
      });
  }

  void openSettings() {
    DeviceApps.openAppSettings(this.packageName);
  }

}

