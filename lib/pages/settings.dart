import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/logic/temperature_logic.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:flutter_mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();
  final temperatureLogic = getIt<TemperatureLogic>();
  bool currentlyPopping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && mounted && !currentlyPopping) {
      currentlyPopping = true;
      Navigator.of(context).pop();
    }
    super.didChangeAppLifecycleState(state);
  }

  void pushAppSearch(ValueNotifierWithKey<AppInfo> specialAppNotifier) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (_) => Scaffold(
                  body: SafeArea(
                      child: AppSearchFragment(
                appSearchMode: AppSearchMode.chooseSpecialShortcut,
                specialShortcutAppNotifier: specialAppNotifier,
              )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textStyleTitle = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
    var textStyleItems = TextStyle(fontSize: 22, height: 1);

    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleDarkMode();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 50.0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("settings", style: textStyleTitle),
                    SizedBox(
                      height: 20,
                      width: double.infinity,
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        marsLauncherAppInfo.openSettings();
                      },
                      child: Text(
                        "permissions",
                        style: textStyleItems,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        // TODO open settings for setting default launcher
                      },
                      child: Text(
                        "set default launcher",
                        style: textStyleItems,
                      ),
                    ),

                    // TextButton(
                    //   onPressed: () {
                    //     appShortcutsManager.toggleEnabled("shortcutMode", appShortcutsManager.shortcutMode);
                    //   },
                    //   child: ValueListenableBuilder<bool>(
                    //       valueListenable: appShortcutsManager.shortcutMode,
                    //       builder: (context, mode, child){
                    //       return Text(
                    //         mode ? "shortcut mode" : "search mode",
                    //         style: textStyleItems,
                    //       );
                    //     }
                    //   ),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            appShortcutsManager.setNotifierValueAndSave(appShortcutsManager.numberOfShortcutItemsNotifier);
                          },
                          child: Text(
                            "shortcut apps",
                            style: textStyleItems,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ValueListenableBuilder<int>(
                            valueListenable: appShortcutsManager.numberOfShortcutItemsNotifier,
                            builder: (context, numOfShortcutItems, child) {
                              return Text(numOfShortcutItems.toString(),
                                  style: textStyleItems);
                            }),
                      ],
                    ),

                    TextButton(
                      onLongPress: () {
                        appShortcutsManager.setNotifierValueAndSave(appShortcutsManager.clockEnabledNotifier);
                      },
                      onPressed: () {
                        pushAppSearch(
                            appShortcutsManager.clockAppNotifier);
                      },
                      child: ValueListenableBuilder<bool>(
                          valueListenable:
                              appShortcutsManager.clockEnabledNotifier,
                          builder: (context, clockEnabled, child) {
                            return Text(
                              clockEnabled ? "clock" : "hide clock",
                              style: textStyleItems,
                            );
                          }),
                    ),
                    TextButton(
                      onLongPress: () {
                        appShortcutsManager.setNotifierValueAndSave(appShortcutsManager.weatherEnabledNotifier);
                        temperatureLogic.askForPermission();
                      },
                      onPressed: () {
                        pushAppSearch(
                            appShortcutsManager.weatherAppNotifier);
                      },
                      child: ValueListenableBuilder<bool>(
                          valueListenable:
                              appShortcutsManager.weatherEnabledNotifier,
                          builder: (context, clockEnabled, child) {
                            return Text(
                              clockEnabled ? "weather" : "hide weather",
                              style: textStyleItems,
                            );
                          }),
                    ),
                    TextButton(
                      onLongPress: () {
                        appShortcutsManager.setNotifierValueAndSave(appShortcutsManager.calendarEnabledNotifier);
                      },
                      onPressed: () {
                        pushAppSearch(
                            appShortcutsManager.calendarAppNotifier);
                      },
                      child: ValueListenableBuilder<bool>(
                          valueListenable:
                              appShortcutsManager.calendarEnabledNotifier,
                          builder: (context, clockEnabled, child) {
                            return Text(
                              clockEnabled ? "calendar" : "hide calendar",
                              style: textStyleItems,
                            );
                          }),
                    ),
                    TextButton(
                        onLongPress: () {},
                        onPressed: () {
                          pushAppSearch(
                              appShortcutsManager.swipeLeftAppNotifier);
                        },
                        child: Text(
                          "swipe left",
                          style: textStyleItems,
                        )),
                    TextButton(
                        onLongPress: () {},
                        onPressed: () {
                          pushAppSearch(
                              appShortcutsManager.swipeRightAppNotifier);
                        },
                        child: Text(
                          "swipe right",
                          style: textStyleItems,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
