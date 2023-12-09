import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/dialogs/dialog_rename_app.dart';
import 'package:mars_launcher/services/service_locator.dart';

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
    final titleColor = Theme.of(context).primaryColor; // Color(0xffa4133c);
    final actionColor = Colors.redAccent; //Color(0xffc9184a); // Theme.of(context).primaryColor;
    final buttonStyle = ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent));

    return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          appInfo.appName,
          style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      // TODO open new screen to rename app
                      final result = await showDialog(
                        context: context,
                        builder: (_) => RenameAppDialog(appInfo: appInfo),
                      );
                      // TODO trigger reload of app search
                      if (result != null) {
                        appsManager.addOrUpdateRenamedApp(appInfo, result);
                        Navigator.pop(context, result);
                      }
                    },
                    child: Text(
                      "Rename",
                      style: TextStyle(color: actionColor),
                    ),
                    style: buttonStyle,
                  ),
                  TextButton(
                      onPressed: () {
                        appsManager.updateHiddenApps(appInfo.packageName, true);
                        Fluttertoast.showToast(
                            msg: "${appInfo.appName} is now hidden!",
                            backgroundColor:
                            themeManager.themeModeNotifier.value
                                ? Colors.white
                                : Colors.black,
                            textColor: themeManager.themeModeNotifier.value
                                ? Colors.black
                                : Colors.white);

                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Hide",
                        style: TextStyle(color: actionColor),
                      ),
                      style: buttonStyle),
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
                      style: TextStyle(color: actionColor),
                    ),
                    style: buttonStyle,
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
                      style: TextStyle(color: actionColor),
                    ),
                    style: buttonStyle,
                  ),
                ])
          ],
        ));
  }
}
