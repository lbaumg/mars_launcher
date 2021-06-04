import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/custom_widgets/top_row.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/fragments/shortcut_apps.dart';
import 'package:flutter_mars_launcher/fragments/apps_list.dart';
import 'package:flutter_mars_launcher/models/app_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:device_apps/device_apps.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  bool searchApps = false;


  @override
  void initState() {
    super.initState();
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
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        // SWIPE DETECTION

        onHorizontalDragUpdate: _horizontalDragHandler,
        onVerticalDragUpdate: _verticalDragHandler,
        onDoubleTap: () {
          // TODO Toggle dark mode
        },
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

                  Expanded(
                      flex: 1,
                      child: Center(
                        // alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Fluttertoast.showToast(msg: "syncing apps..");
                            Provider.of<AppModel>(context).syncInstalledApps();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black
                          ),
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
                        : AppsList(),
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
