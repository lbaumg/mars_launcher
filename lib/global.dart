import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';

const List<String> IGNORED_APPS = ["mars launcher"];

Color primaryColor = Colors.black;
Color textColor = Colors.white;


AppInfo clockApp = AppInfo(packageName: "com.sec.android.app.clockpackage", appName: "Uhr");
AppInfo calenderApp = AppInfo(packageName: "com.samsung.android.calendar", appName: "Kalender");
AppInfo cameraApp = AppInfo(packageName: "com.sec.android.app.camera", appName: "Kamera");
AppInfo contactsApp = AppInfo(packageName: "com.samsung.android.app.contacts", appName: "Kontakte");
