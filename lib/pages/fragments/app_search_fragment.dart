/// App search fragment that appears on swipe up

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/pages/fragments/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/logic/apps_logic.dart';

enum AppSearchMode {
  openApp, chooseShortcut, chooseSpecialShortcut
}

class AppSearchFragment extends StatefulWidget {
  final AppSearchMode appSearchMode;
  final ValueNotifierWithKey<AppInfo>? specialShortcutAppNotifier;
  final int? shortcutIndex;

  AppSearchFragment({this.appSearchMode = AppSearchMode.openApp, this.specialShortcutAppNotifier, this.shortcutIndex});

  @override
  _AppSearchFragmentState createState() => _AppSearchFragmentState();
}

class _AppSearchFragmentState extends State<AppSearchFragment> with WidgetsBindingObserver{
  TextEditingController _textController = TextEditingController();
  late final appSearchLogic;
  bool currentlyPopping = false;

  callbackPop() {
    Navigator.pop(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive && mounted && !currentlyPopping) {
      currentlyPopping = true;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void initState() {
    print("INITIALISING AppSearchFragment");
    appSearchLogic = AppSearchLogic(callbackPop: callbackPop, appSearchMode: widget.appSearchMode, specialShortcutAppNotifier: widget.specialShortcutAppNotifier, shortcutIndex: widget.shortcutIndex);
    print("Shortcut selection mode: ${widget.appSearchMode}");
    WidgetsBinding.instance?.addObserver(this);
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
  final ValueNotifierWithKey? specialShortcutAppNotifier;
  final int? shortcutIndex;
  final Function callbackPop;
  final AppSearchMode appSearchMode;

  AppSearchLogic({required this.callbackPop, required this.appSearchMode, this.specialShortcutAppNotifier, this.shortcutIndex}) {
    filteredAppsNotifier = ValueNotifier(appsManager.appsNotifier.value);
  }

  handleAppSelected(AppInfo appInfo) {
    /// if appSearchMode: open app
    /// else if chooseShortcut: replace shortcut
    /// else if chooseSpecialShortcut: replace special shortcut

    if (appSearchMode == AppSearchMode.openApp) {
      appInfo.open();
    } else if (appSearchMode == AppSearchMode.chooseShortcut) {
      print("Replacing shortcut app with index $shortcutIndex with ${appInfo.appName}");
      appShortcutsManager.shortcutAppsNotifier
          .replaceShortcut(shortcutIndex ?? -1, appInfo);
      callbackPop();
    } else if (appSearchMode == AppSearchMode.chooseSpecialShortcut) {
      print("Replacing special shortcut app ${specialShortcutAppNotifier?.key} with ${appInfo.appName}");
      if (specialShortcutAppNotifier != null) {
        appShortcutsManager.setSpecialShortcutValue(specialShortcutAppNotifier!, appInfo);
      }
      callbackPop();
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
