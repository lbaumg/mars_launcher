import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/home_page/fragments/clock.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/home_page/fragments/app_shortcuts_fragment.dart';
import 'package:flutter_mars_launcher/home_page/fragments/app_search_fragment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/home_page/home_logic.dart';


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
                      child: TopRow()),

                  Expanded(
                      flex: 1,
                      child: SyncAppsButton()),

                  Expanded(
                    flex: 8,
                    child: !searchApps
                        ? AppShortcutsFragment()
                        : AppSearchFragment(),
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

class SyncAppsButton extends StatelessWidget {
  const SyncAppsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appsManager = getIt<AppsManager>();
    return Center(
      // alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: () {
          Fluttertoast.showToast(msg: "syncing apps..");
          appsManager.appsNotifier.syncInstalledApps();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.black
        ),
        child: SizedBox(
          width: 10,
          height: 20,
        ),
      ),
    );
  }
}


class TopRow extends StatelessWidget {
  const TopRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              clockApp.open();
            },
            child: Clock(),
          ),
          Expanded(
            child: Container(),
          ),
          TextButton(
            onPressed: () {
              calenderApp.open();
            },
            child: Text(
              "no events",
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}