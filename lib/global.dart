import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';

const List<String> IGNORED_APPS = ["mars launcher"];

Color primaryColor = Colors.black;
Color textColor = Colors.white;

AppInfo weatherApp = AppInfo(packageName: "com.wetter.androidclient", appName: "wetter.com");
AppInfo clockApp = AppInfo(packageName: "com.sec.android.app.clockpackage", appName: "Uhr");
AppInfo calenderApp = AppInfo(packageName: "com.samsung.android.calendar", appName: "Kalender");
AppInfo cameraApp = AppInfo(packageName: "com.sec.android.app.camera", appName: "Kamera");
AppInfo contactsApp = AppInfo(packageName: "com.samsung.android.dialer", appName: "Telefon");

final List<AppInfo> initialShortcutApps = [
  AppInfo(packageName: "com.ichi2.anki", appName: "Anki"),
  AppInfo(packageName: "com.github.jamesgay.fitnotes", appName: "Training"),
  AppInfo(packageName: "com.spotify.music", appName: "Spotify"),
  AppInfo(packageName: "com.brave.browser", appName: "Brave"),
];