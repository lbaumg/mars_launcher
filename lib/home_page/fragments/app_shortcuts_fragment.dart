/// Shortcut apps fragment in middle of home screen

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/home_page/fragments/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/home_page/home_logic.dart';


class AppShortcutsFragment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appsManager = getIt<AppsManager>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(22.0, 100.0, 0, 0),
      child: ValueListenableBuilder<List<AppInfo>>(
        valueListenable: appsManager.shortcutAppsNotifier,
        builder: (context, shortcutApps, child) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: shortcutApps.map((app) => AppCard(
                appInfo: app,
                isShortcutItem: true,
              openApp: (AppInfo appinfo) {
                  appinfo.open();
              },
            )).toList(),
          );
        }
      ),
    );
  }
}