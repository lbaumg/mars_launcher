import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

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
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6
          ),
          child: TextButton(
            onPressed: () {},
            child: Text(
              appInfo.displayName,
              overflow: TextOverflow.ellipsis, // Specify how to handle overflow
              maxLines: 2,
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
