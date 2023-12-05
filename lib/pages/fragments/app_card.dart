import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
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
                appInfo.displayName = result;
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

class AppInfoDialog extends StatelessWidget {
  AppInfoDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  final AppInfo appInfo;
  final themeManager = getIt<ThemeManager>();
  final appsManager = getIt<AppsManager>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          appInfo.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // contentPadding: EdgeInsets.zero, // Adjust content padding
        // actionsPadding: EdgeInsets.only(left: 10, bottom: 10, right: 0), // Align actions to the left
        // insetPadding: EdgeInsets.all(10),
        // actionsAlignment: MainAxisAlignment.start,

        // actionsPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 10), // Adjust content padding
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      // TODO open new screen to rename app

                      // TODO trigger reload of app search
                      Navigator.pop(context, "newName");
                    },
                    child: Text(
                      "Rename",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      appInfo.hide(true);
                      appsManager.addOrUpdateRenamedOrHiddenApp(appInfo);
                      Fluttertoast.showToast(
                          msg: "${appInfo.appName} is now hidden!",
                          backgroundColor: themeManager.themeModeNotifier.value
                              ? Colors.white
                              : Colors.black,
                          textColor: themeManager.themeModeNotifier.value
                              ? Colors.black
                              : Colors.white);

                      Navigator.pop(context, null);
                    },
                    child: Text(
                      "Hide",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              TextButton(
                onPressed: () {
                  appInfo.openSettings();
                  Navigator.pop(context, null);
                },
                child: Text(
                  "Info",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              appInfo.systemApp
                  ? SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        appInfo.uninstall();
                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Uninstall",
                        style: TextStyle(color: Colors.blue),
                      )),
            ])
          ],
        ));
  }
}
