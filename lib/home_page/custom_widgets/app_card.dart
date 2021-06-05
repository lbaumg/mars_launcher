import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/home_page/fragments/app_search_fragment.dart';
import 'package:flutter_mars_launcher/home_page/fragments/select_app.dart';
import 'package:flutter_mars_launcher/models/app_model.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:provider/provider.dart';

class AppCard extends StatelessWidget {
  final AppInfo appInfo;
  final bool isShortcutItem;

  AppCard({required this.appInfo, required this.isShortcutItem});

  @override
  Widget build(BuildContext context) {
    final appsManager = getIt<AppsManager>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: TextButton(
        onPressed: () {
          appInfo.open();
        },
        onLongPress: () {

          if (isShortcutItem) {
            int shortcutIndex = appsManager.shortcutAppsNotifier.value.indexOf(appInfo);

            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) =>
                    Scaffold(body: SafeArea(child: AppSearchFragment(shortcutSelectionMode: true, shortcutIndex: shortcutIndex)))
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (_) => AppInfoDialog(appInfo: appInfo),
            );
          }
        },
        child: Text(
          appInfo.appName,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w100,
            fontFamily: isShortcutItem ? "NotoSansRegular" : "NotoSansLight",
            letterSpacing: isShortcutItem ? 1 : 0,
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.black),
          foregroundColor: MaterialStateProperty.all(
              isShortcutItem ? Colors.white : Colors.deepOrange),
        ),
      ),
    );
  }
}

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  final AppInfo appInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        appInfo.appName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        appInfo.systemApp
            ? Container()
            : TextButton(
                onPressed: () {
                  appInfo.uninstall();
                  Navigator.of(context).pop();
                },
                child: Text("Uninstall")),
        TextButton(
            onPressed: () {
              appInfo.openSettings();
              Navigator.of(context).pop();
            },
            child: Text("Info")),
      ],
    );
  }
}
