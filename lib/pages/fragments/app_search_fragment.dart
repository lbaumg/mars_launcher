/// App search fragment that appears on swipe up

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/pages/fragments/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/logic/apps_logic.dart';

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
  late final appSearchLogic;

  callbackPop () {
    Navigator.pop(context);
  }

  @override
  void initState() {
    appSearchLogic = AppSearchLogic(callbackPop, widget.shortcutSelectionMode, widget.shortcutIndex);
    print("Shortcut selection mode:");
    print(widget.shortcutSelectionMode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              TextField(
                cursorColor: Colors.white,
                cursorWidth: 0,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent))),
                controller: _textController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                ),
                onChanged: (value) {
                  appSearchLogic.getFilteredApps(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 20.0, 0, 0),
                child: ValueListenableBuilder<List<AppInfo>>(
                  valueListenable: appSearchLogic.filteredAppsNotifier,
                  builder: (context, filteredApps, child) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredApps
                          .map((app) => AppCard(
                                appInfo: app,
                                isShortcutItem: false,
                                openApp: appSearchLogic.handleAppSelected,
                              ))
                          .toList(),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSearchLogic {
  final appsManager = getIt<AppsManager>();
  final appShortcutsManager = getIt<AppShortcutsManager>();
  late final ValueNotifier<List<AppInfo>> filteredAppsNotifier;
  final Function callbackPop;
  final bool shortcutSelectionMode;
  final int shortcutIndex;

  AppSearchLogic(this.callbackPop, this.shortcutSelectionMode, this.shortcutIndex) {
    filteredAppsNotifier = ValueNotifier(appsManager.appsNotifier.value);
  }


  handleAppSelected(AppInfo appInfo) {
    /// Opens app if not in selectionMode else replace shortcut
    if (shortcutSelectionMode) {
      // TODO return as result
      appShortcutsManager.shortcutAppsNotifier
          .replaceShortcut(shortcutIndex, appInfo);
      callbackPop();
    } else {
      appInfo.open();
    }
  }

  getFilteredApps(String searchValue) {
    List<AppInfo> filteredApps = appsManager.appsNotifier.value
        .where((app) =>
        app.appName.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    if (filteredApps.length == 1) {
      handleAppSelected(filteredApps.first);
    }
    filteredAppsNotifier.value = filteredApps;
  }

}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
