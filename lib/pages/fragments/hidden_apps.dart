import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/hidden_app_card.dart';
import 'package:mars_launcher/services/service_locator.dart';

const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 60.0;

class HiddenApps extends StatefulWidget {
  const HiddenApps({Key? key}) : super(key: key);

  @override
  State<HiddenApps> createState() => _HiddenAppsState();
}

class _HiddenAppsState extends State<HiddenApps> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();
  final appsManager = getIt<AppsManager>();

  // final temperatureLogic = getIt<TemperatureLogic>();
  var currentlyPopping = false;

  // final settingsLogic = getIt<SettingsLogic>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && mounted && !currentlyPopping) {
      currentlyPopping = true;
      Navigator.of(context).pop();
    }
    super.didChangeAppLifecycleState(state);
  }

  void callbackRemoveFromHiddenApps(appInfo) {
    appsManager.removeHiddenApp(appInfo);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        currentlyPopping = true;
        return true;
      },
      child: GestureDetector(
        onDoubleTap: () {
          themeManager.toggleDarkMode();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(40),
                      child: ValueListenableBuilder<List<AppInfo>>(
                          valueListenable: appsManager.hiddenAppsNotifier,
                          builder: (context, renamedOrHiddenApps, child) {
                            final hiddenApps = renamedOrHiddenApps
                                .where((app) => app.isHidden);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: hiddenApps
                                  .map<Widget>((app) => HiddenAppCard(
                                      appInfo: app,
                                      callbackRemoveFromHiddenApps:
                                          callbackRemoveFromHiddenApps))
                                  .toList(),
                            );
                          }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
