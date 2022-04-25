import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/pages/fragments/app_shortcuts_fragment.dart';
import 'package:flutter_mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:flutter_mars_launcher/pages/fragments/top_row/top_row.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:flutter_mars_launcher/pages/settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/logic/apps_logic.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  bool searchApps = false;
  final themeManager = getIt<ThemeManager>();
  final appShortcutsManager = getIt<AppShortcutsManager>();

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
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Settings()),
          );
        },
        onDoubleTap: () {
          themeManager.toggleDarkMode();
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
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: TopRow()),

                Expanded(
                    flex: 1,
                    child: Container()),

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
      appShortcutsManager.swipeRightAppNotifier.value.open();
    } else if (details.delta.dx < -sensivity) {
      // Left Swipe
      appShortcutsManager.swipeLeftAppNotifier.value.open();
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
      child: TextButton(
        onPressed: () {
          Fluttertoast.showToast(msg: "syncing apps..");
          appsManager.syncInstalledApps();
        },
        child: SizedBox(
          width: 10,
          height: 20,
        ),
      ),
    );
  }
}


