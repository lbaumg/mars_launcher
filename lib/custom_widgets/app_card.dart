import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/fragments/apps_list.dart';
import 'package:flutter_mars_launcher/fragments/select_app.dart';
import 'package:flutter_mars_launcher/models/app_model.dart';
import 'package:provider/provider.dart';

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
          var apps = Provider.of<AppModel>(context, listen: false).apps;
          if (isShortcutItem) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    body: SelectApps(apps: apps),
                  );
                },
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
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
