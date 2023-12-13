/// Shortcut apps fragment in middle of home screen

import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/fragments/cards/app_card.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';

var num2topPad = {
  0: 0.0,
  1: 250.0,
  2: 180.0,
  3: 150.0,
  4: 100.0,
  5: 80.0,
  6: 30.0,
  7: 0.0
};

class AppShortcutsFragment extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsManager>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: settingsLogic.numberOfShortcutItemsNotifier,
        builder: (context, numOfShortcutItems, child){
        return Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0, 0, 20),
          // padding: EdgeInsets.fromLTRB(22.0, num2topPad[numOfShortcutItems]!, 0, 0),
          child: ValueListenableBuilder<List<AppInfo>>(
            valueListenable: appShortcutsManager.shortcutAppsNotifier,
            builder: (context, shortcutApps, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: shortcutApps.getRange(0, numOfShortcutItems).map((app) => AppCard(
                    appInfo: app,
                    isShortcutItem: true,
                  openApp: (AppInfo appInfo) {
                    appInfo.open();
                  },
                )).toList(),
              );
            }
          ),
        );
      }
    );
  }
}
