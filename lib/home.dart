import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/custom_widgets/top_row.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/fragments/shortcut_apps.dart';
import 'package:flutter_mars_launcher/fragments/apps_list.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:device_apps/device_apps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<AppInfo> apps = [];
  bool searchApps = false;

  getInstalledApps() async {
    List<Application> applications = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    for (int i = 0; i < applications.length; i++) {
      Application app = applications[i];
      AppInfo appInfo =
          AppInfo(packageName: app.packageName, appName: app.appName);
      apps.add(appInfo);
    }
    apps.sort((a, b) => a.appName.compareTo(b.appName));
  }

  @override
  void initState() {
    super.initState();
    getInstalledApps();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        searchApps = false;
      });
      // Hide status bar
      // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hide status bar
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);

    // Set navigation bar color
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.white,
    // ));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        // SWIPE DETECTION
        onHorizontalDragUpdate: _horizontalDragHandler,
        onVerticalDragUpdate: _verticalDragHandler,
        child: Scaffold(
          // backgroundColor: primaryColor,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopRow(),
                  SizedBox(height:60 //MediaQuery.of(context).size.height / 5,
                      ),

                  // Container(),

                  Expanded(
                    // flex: 6,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: !searchApps
                          ? ShortcutApps()
                          : AppsList(
                              apps: apps,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (searchApps) {
      setState(() {
        searchApps = false;
      });
    }
    return false;
  }

  _horizontalDragHandler(details) {
    if (searchApps) {
      return;
    }

    int sensivity = 8;
    if (details.delta.dx > sensivity) {
      // Right Swipe
      contactsApp.open();
    } else if (details.delta.dx < -sensivity) {
      // Left Swipe
      cameraApp.open();
    }
  }

  _verticalDragHandler(details) {
    int sensitivity = 8;
    if (details.delta.dy > sensitivity) {
      // Down Swipe
      if (searchApps) {
        setState(() {
          searchApps = false;
        }); // Close app search
      } else {
        // TODO open status bar
      }
    } else if (details.delta.dy < -sensitivity) {
      // Up Swipe
      if (!searchApps) {
        setState(() {
          searchApps = true;
        }); // Open app search
      }
    }
  }
}
