/// App search fragment that appears on swipe up

import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/app_search_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/fragments/cards/app_card.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/services/service_locator.dart';

class AppSearchFragment extends StatefulWidget {
  final AppSearchMode appSearchMode;
  final ValueNotifierWithKey<AppInfo>? specialShortcutAppNotifier;
  final int? shortcutIndex;

  late final allowDialog;


  AppSearchFragment({required this.appSearchMode, this.specialShortcutAppNotifier, this.shortcutIndex}) {
    allowDialog = appSearchMode == AppSearchMode.openApp;
  }

  @override
  _AppSearchFragmentState createState() => _AppSearchFragmentState();
}

class _AppSearchFragmentState extends State<AppSearchFragment> with WidgetsBindingObserver {
  final _textController = TextEditingController();
  final appSearchManager = getIt<AppSearchManager>();


  final Map<AppInfo, AppCard> memorizedWidgets = {};

  AppCard getMemorizedAppCard(AppInfo appInfo) {
    return memorizedWidgets.putIfAbsent(
      appInfo,
          () => AppCard(
            appInfo: appInfo,
            isShortcutItem: false,
            callbackHandleOnPress: callbackHandleOnTap,
            allowDialog: widget.allowDialog,
      ),
    );
  }

  @override
  void initState() {
    print("[$runtimeType] INITIALISING");
    appSearchManager.setTemporaryParameters(
      context,
      widget.appSearchMode,
      widget.shortcutIndex,
      widget.specialShortcutAppNotifier,
    );

    print("[$runtimeType] Shortcut selection mode: ${widget.appSearchMode}");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    appSearchManager.resetFilteredList();
    super.dispose();
  }

  callbackHandleOnTap(AppInfo appInfo) {
    appSearchManager.handleOnTap(appInfo);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                cursorColor: Colors.white,
                cursorWidth: 0,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                controller: _textController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                ),
                onChanged: (value) {
                  appSearchManager.updateFilteredApps(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 20.0, 0, 0),
                child: ValueListenableBuilder<List<AppInfo>>(
                    valueListenable: appSearchManager.filteredAppsNotifier,
                    builder: (context, filteredApps, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredApps.map((app) => getMemorizedAppCard(app)).toList(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyScrollBehavior extends ScrollBehavior {
  // Removes animation when arriving at top or bottom of scrollview
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails scrollableDetails) {
    return child;
  }
}
