import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';

class AppCard extends StatelessWidget {
  final AppInfo appInfo;
  final bool isShortcutItem;

  AppCard({required this.appInfo, required this.isShortcutItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: TextButton(
        onPressed: () {
          appInfo.open();
        },
        onLongPress: () {
          if (!isShortcutItem) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(appInfo.appName, style: TextStyle(fontWeight: FontWeight.bold),),
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
              ),
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
