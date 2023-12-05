import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/main.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/services/service_locator.dart';

typedef OpenAppCallback = Function(AppInfo appInfo);

class HiddenAppCard extends StatelessWidget {
  final AppInfo appInfo;
  final callbackRemoveFromHiddenApps;

  HiddenAppCard({required this.appInfo, required this.callbackRemoveFromHiddenApps});

  @override
  Widget build(BuildContext context) {
    var fontFamily = FONT_LIGHT;
    var textColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            appInfo.getDisplayName(),
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w100,
              fontFamily: fontFamily,
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(textColor),
          ),
        ),
        IconButton(
            onPressed: () {
              callbackRemoveFromHiddenApps(appInfo);
            },
            icon: Icon(
              Icons.remove,
              size: 15,
            )
        )
      ],
    );
  }
}
