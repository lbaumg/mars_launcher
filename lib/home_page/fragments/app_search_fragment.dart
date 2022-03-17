/// App search fragment that appears on swipe up

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/home_page/fragments/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/home_page/home_logic.dart';


class AppSearchFragment extends StatefulWidget {
  final bool shortcutSelectionMode;
  final int shortcutIndex;

  AppSearchFragment(
      {this.shortcutSelectionMode = false, this.shortcutIndex = -1});

  @override
  _AppSearchFragmentState createState() => _AppSearchFragmentState();
}

class _AppSearchFragmentState extends State<AppSearchFragment> {
  TextEditingController _textController = TextEditingController();
  List<AppInfo> filteredApps = [];
  final appsManager = getIt<AppsManager>();

  onItemChanged(String value) {
    setState(() {
      filteredApps = appsManager.appsNotifier.value
          .where(
              (app) => app.appName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
    if (filteredApps.length == 1) {
      openApp(filteredApps.first);
      /*if (widget.shortcutSelectionMode) {
        appsManager.shortcutAppsNotifier.replaceShortcut(widget.shortcutIndex, filteredApps.first);
        Navigator.pop(context);
      } else {
        print("OPEN APP");
        filteredApps.first.open();
      }*/
    }
  }

  openApp(AppInfo appInfo) {
    if (widget.shortcutSelectionMode) {
      appsManager.shortcutAppsNotifier
          .replaceShortcut(widget.shortcutIndex, appInfo);
      Navigator.pop(context);
    } else {
      appInfo.open();
    }
  }

  @override
  void initState() {
    super.initState();
    filteredApps = appsManager.appsNotifier.value;
    print("Shortcut selection mode:");
    print(widget.shortcutSelectionMode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Colors.white,
                cursorWidth: 0,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor))),
                controller: _textController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
                onChanged: onItemChanged,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 20.0, 0, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredApps
                      .map((app) => AppCard(
                            appInfo: app,
                            isShortcutItem: false,
                            openApp: openApp,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}