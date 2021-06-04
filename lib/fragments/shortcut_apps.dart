import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/custom_widgets/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/models/app_model.dart';
import 'package:provider/provider.dart';

class ShortcutApps extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22.0, 100.0, 0, 0),
      child: Consumer<AppModel>(
        builder: (context, appModel, child) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: appModel.shortcutApps.map((app) => AppCard(appInfo: app, isShortcutItem: true)).toList(),
          );
        }
      ),
    );
  }
}