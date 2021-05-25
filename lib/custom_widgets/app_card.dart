import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';

class AppCard extends StatelessWidget {
  AppInfo appInfo;
  Color textColor;
  AppCard({ required this.appInfo, required this.textColor });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: TextButton(
        onPressed: () {
          appInfo.open();
        },
        child: Text(
          appInfo.appName,
          style: TextStyle(
            color: textColor,
            fontSize: 30,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.7,
            // fontWeight: FontWeight.w00
          ),
        ),
      ),
    );
  }
}

