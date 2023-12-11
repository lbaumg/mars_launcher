import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/pages/fragments/app_shortcuts_fragment.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/pages/fragments/top_row/top_row.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/settings.dart';
import 'package:mars_launcher/services/service_locator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final sensitivity = 8;

  final ValueNotifier<bool> searchAppsNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive && mounted) {
      searchAppsNotifier.value = false;
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope( /// Detect back button to close app search
      canPop: false,
      onPopInvoked: (didPop) {_onWillPop(didPop);},
      child: GestureDetector(
        /// SWIPE DETECTION
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopRow(),
                SizedBox(height: 50,),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                      valueListenable: searchAppsNotifier,
                      builder: (context, searchApps, child) {
                      return !searchApps
                          ? Align(
                          alignment:
                          Alignment.centerLeft, // Center only vertically
                          child: AppShortcutsFragment())
                          : AppSearchFragment();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onWillPop(didPop) async {
    searchAppsNotifier.value = false;
    return;
  }

  _horizontalDragHandler(details) {
    if (searchAppsNotifier.value) {
      return;
    }

    if (details.delta.dx > sensitivity) {
      /// Right Swipe
      appShortcutsManager.swipeRightAppNotifier.value.open();
    } else if (details.delta.dx < -sensitivity) {
      /// Left Swipe
      appShortcutsManager.swipeLeftAppNotifier.value.open();
    }
  }

  _verticalDragHandler(details) {
    if (details.delta.dy > sensitivity) { /// Down Swipe
      searchAppsNotifier.value = false; /// Close app search
    } else if (details.delta.dy < -sensitivity) { /// Up Swipe
      searchAppsNotifier.value = true; /// Open app search
    }
  }
}
