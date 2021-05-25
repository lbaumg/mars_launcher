import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/custom_widgets/top_row.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/fragments/shortcut_apps.dart';
import 'package:flutter_mars_launcher/fragments/apps_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:device_apps/device_apps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<AppInfo> apps = [];
  bool searchApps = false;

  late DeviceCalendarPlugin _deviceCalendarPlugin;
  late List<Calendar> _calendars;

  // List<Calendar> get _readOnlyCalendars => _calendars?.where((c) => c.isReadOnly).toList() ?? List.filled (0, 0);

  _CalendarsPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }


  getInstalledApps() async {
    apps.clear();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        // SWIPE DETECTION

        onHorizontalDragUpdate: _horizontalDragHandler,
        onVerticalDragUpdate: _verticalDragHandler,
        onPanDown: (details) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },

        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: primaryColor,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: TopRow(),
                      )),
                  // SizedBox(
                  //     height: screenHeight/12 ),//MediaQuery.of(context).size.height / 5,
                  Expanded(
                      flex: 1,
                      child: Center(
                        // alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Fluttertoast.showToast(msg: "syncing apps..");
                            getInstalledApps();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black
                          ),
                          // color: Colors.white,

                          // style: ButtonStyle(
                          //
                          // ),
                          child: SizedBox(
                            width: 10,
                            height: 20,
                          ),
                        ),
                      )),

                  Expanded(
                    flex: 8,
                    child: !searchApps
                        ? ShortcutApps()
                        : AppsList(
                            apps: apps,
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


  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult.data;
      });
    } on PlatformException catch (e) {
      print(e);
    }
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
/*    if (searchApps) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus &&
          currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }*/

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
