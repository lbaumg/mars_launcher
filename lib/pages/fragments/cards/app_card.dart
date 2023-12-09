import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/pages/fragments/dialogs/dialog_app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';

typedef OpenAppCallback = Function(AppInfo appInfo);

class AppCard extends StatelessWidget {
  final AppInfo appInfo;
  final bool isShortcutItem;
  final OpenAppCallback openApp;
  final allowDialog;

  AppCard(
      {required this.appInfo,
      required this.isShortcutItem,
      required this.openApp,
      this.allowDialog = false});

  @override
  Widget build(BuildContext context) {
    final appShortcutsManager = getIt<AppShortcutsManager>();

    var fontFamily = isShortcutItem ? FONT_REGULAR : FONT_LIGHT;
    var letterSpacing = isShortcutItem ? 1.0 : 0.0;
    var textColor = isShortcutItem
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: TextButton(
        onPressed: () {
          openApp(appInfo);
        },
        onLongPress: () async {
          if (isShortcutItem) {
            int shortcutIndex =
                appShortcutsManager.shortcutAppsNotifier.value.indexOf(appInfo);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                      body: SafeArea(
                          child: AppSearchFragment(
                              appSearchMode: AppSearchMode.chooseShortcut,
                              shortcutIndex: shortcutIndex)))),
            );
          } else {
            if (allowDialog) {
              final result = await showDialog(
                context: context,
                builder: (_) => AppInfoDialog(appInfo: appInfo),
              );

              // Handle the result
              if (result != null) {
                print('Dialog result: $result');
                // TODO change name somehow or reload
                // appInfo.displayName = result;
              }
            }
          }
        },
        child: Text(
          appInfo.getDisplayName(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w100,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder()),
          foregroundColor: MaterialStateProperty.all(textColor),
        ),
      ),
    );
  }
}


