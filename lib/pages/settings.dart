import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/dialogs/dialog_color_picker.dart';
import 'package:mars_launcher/pages/dialogs/dialog_open_weather_api_key.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/pages/hidden_apps.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';



const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 50.0; // TODO look for overflow

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();
  final permissionService = getIt<PermissionService>();
  final settingsLogic = getIt<SettingsManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, ROW_PADDING_RIGHT, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Strings.settingsTitle, style: TEXT_STYLE_TITLE),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: SingleChildScrollView(
                    child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// SET DEFAULT LAUNCHER
                            TextButton(
                              onPressed: () {
                                settingsLogic.openDefaultLauncherSettings();
                              },
                              child: Text(
                                Strings.settingsChangeDefaultLauncher,
                                style: TEXT_STYLE_ITEMS,
                              ),
                            ),

                            /// LIGHT COLOR / DARK COLOR
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColorPickerDialog(changeDarkModeColor: false);
                                      },
                                    );
                                  },
                                  child: Text(
                                    Strings.settingsLightColor,
                                    style: TEXT_STYLE_ITEMS,
                                  ),
                                ),
                                // Expanded(child: Container()),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ColorPickerDialog(changeDarkModeColor: true);
                                        }
                                    );
                                  },
                                  child: Text(
                                    Strings.settingsDarkColor,
                                    style: TEXT_STYLE_ITEMS,
                                  ),
                                ),
                              ],
                            ),

                            /// APPS NUMBER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    settingsLogic.setNotifierValueAndSave(
                                        settingsLogic
                                            .numberOfShortcutItemsNotifier);
                                  },
                                  child: Text(
                                    Strings.settingsAppNumber,
                                    style: TEXT_STYLE_ITEMS,
                                  ),
                                ),
                                Expanded(child: Container()),
                                ValueListenableBuilder<int>(
                                    valueListenable: settingsLogic
                                        .numberOfShortcutItemsNotifier,
                                    builder:
                                        (context, numOfShortcutItems, child) {
                                      return SizedBox(
                                          width: 86,
                                          child: TextButton(
                                            onPressed: () {
                                              settingsLogic.setNotifierValueAndSave(
                                                  settingsLogic
                                                      .numberOfShortcutItemsNotifier);
                                            },
                                            child: Center(
                                                child: Text(
                                                    numOfShortcutItems
                                                        .toString(),
                                                    style: TEXT_STYLE_ITEMS)),
                                          ));
                                    }),
                              ],
                            ),

                            /// CLOCK APP
                            Row(
                              children: [
                                TextButton(
                                    onLongPress: () {},
                                    onPressed: () {
                                      pushAppSearch(
                                          appShortcutsManager.clockAppNotifier);
                                    },
                                    child: Text(
                                      Strings.settingsClockApp,
                                      style: TEXT_STYLE_ITEMS,
                                    )),
                                Expanded(
                                  child: Container(),
                                ),
                                ShowHideButton(
                                  notifier:
                                      settingsLogic.clockWidgetEnabledNotifier,
                                  onPressed: () {
                                    settingsLogic.setNotifierValueAndSave(
                                        settingsLogic
                                            .clockWidgetEnabledNotifier);
                                  },
                                ),
                              ],
                            ),


                            /// WEATHER APP
                            Row(
                              children: [
                                TextButton(
                                    onLongPress: () {},
                                    onPressed: () {
                                      pushAppSearch(appShortcutsManager
                                          .weatherAppNotifier);
                                    },
                                    child: Text(
                                      Strings.settingsWeatherApp,
                                      style: TEXT_STYLE_ITEMS,
                                    )),
                                Expanded(child: Container()),
                                ShowHideButton(
                                  notifier: settingsLogic
                                      .weatherWidgetEnabledNotifier,
                                  onPressed: () {
                                    settingsLogic.setNotifierValueAndSave(
                                        settingsLogic
                                            .weatherWidgetEnabledNotifier);
                                  },
                                ),
                              ],
                            ),

                            /// CALENDAR APP
                            Row(
                              children: [
                                TextButton(
                                  onLongPress: () {},
                                  onPressed: () {
                                    pushAppSearch(appShortcutsManager
                                        .calendarAppNotifier);
                                  },
                                  child: Text(
                                    Strings.settingsCalendarApp,
                                    style: TEXT_STYLE_ITEMS,
                                  ),
                                ),
                                Expanded(child: Container()),
                                ShowHideButton(
                                  notifier: settingsLogic
                                      .calendarWidgetEnabledNotifier,
                                  onPressed: () {
                                    settingsLogic.setNotifierValueAndSave(
                                        settingsLogic
                                            .calendarWidgetEnabledNotifier);
                                  },
                                ),
                              ],
                            ),

                            /// BATTERY
                            Row(
                              children: [
                                TextButton(
                                    onLongPress: () {},
                                    onPressed: () {},
                                    child: Text(
                                      Strings.settingsBattery,
                                      style: TEXT_STYLE_ITEMS,
                                    )),
                                Expanded(
                                  child: Container(),
                                ),
                                ShowHideButton(
                                  notifier: settingsLogic
                                      .batteryWidgetEnabledNotifier,
                                  onPressed: () {
                                    settingsLogic.setNotifierValueAndSave(
                                        settingsLogic
                                            .batteryWidgetEnabledNotifier);
                                  },
                                ),
                              ],
                            ),

                            /// SWIPE LEFT
                            TextButton(
                                onLongPress: () {},
                                onPressed: () {
                                  pushAppSearch(
                                      appShortcutsManager.swipeLeftAppNotifier);
                                },
                                child: Text(
                                  Strings.settingsSwipeLeft,
                                  style: TEXT_STYLE_ITEMS,
                                )),

                            /// SWIPE RIGHT
                            TextButton(
                                onLongPress: () {},
                                onPressed: () {
                                  pushAppSearch(appShortcutsManager
                                      .swipeRightAppNotifier);
                                },
                                child: Text(
                                  Strings.settingsSwipeRight,
                                  style: TEXT_STYLE_ITEMS,
                                )),

                            /// HIDDEN APPS
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HiddenApps()),
                                  );
                                },
                                child: Text(
                                  Strings.settingsHiddenApps,
                                  style: TEXT_STYLE_ITEMS,
                                )),

                            /// SET API KEY
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OpenWeatherAPIDialog();
                                    // return buildAddOpenWeatherAPIDialog(context);
                                  },
                                );
                              },
                              child: Text(
                                "OpenWeather API key",
                                style: TEXT_STYLE_ITEMS,
                              ),
                            ),
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class ShowHideButton extends StatelessWidget {
  const ShowHideButton(
      {Key? key, required this.notifier, required this.onPressed})
      : super(key: key);

  final ValueNotifierWithKey<bool> notifier;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: notifier,
          builder: (context, enabled, child) {
            return SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  enabled ? "hide" : "show",
                  style: TEXT_STYLE_ITEMS,
                ),
              ),
            );
          }),
    );
  }
}


