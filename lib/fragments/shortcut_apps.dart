import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/custom_widgets/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';

class ShortcutApps extends StatelessWidget {

  final List<AppInfo> shortcuts = [
    AppInfo(packageName: "com.wetter.androidclient", appName: "wetter.com"),
    AppInfo(packageName: "com.huawei.health", appName: "Health"),
    AppInfo(packageName: "com.spotify.music", appName: "Spotify"),
    AppInfo(packageName: "com.brave.browser", appName: "Brave"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22.0, 100.0, 0, 0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: shortcuts.map((app) => AppCard(appInfo: app, isShortcutItem: true)).toList(),
      ),
    );
  }
}