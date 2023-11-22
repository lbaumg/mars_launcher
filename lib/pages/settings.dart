import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';

import 'more_settings.dart';

const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 60.0;

const NAME_TOP_BAR_LEFT = "clock app";
const NAME_TOP_BAR_MIDDLE = "weather app";
const NAME_TOP_BAR_RIGHT = "calendar app";
const NAME_SWIPE_LEFT = "swipe left";
const NAME_SWIPE_RIGHT = "swipe right";
const NAME_MORE = "more";

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();
  final permissionService = getIt<PermissionService>();
  final settingsLogic = getIt<SettingsLogic>();
  var currentlyPopping = false;

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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(50, 50.0, ROW_PADDING_RIGHT, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("settings", style: TEXT_STYLE_TITLE),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),
                      SizedBox(height: 10),

                      // SET DEFAULT LAUNCHER
                      TextButton(
                        onPressed: () {
                           settingsLogic.openDefaultLauncherSettings();
                        },
                        child: Text(
                          "set default launcher",
                          style: TEXT_STYLE_ITEMS,
                        ),
                      ),

                      // LIGHT COLOR / DARK COLOR
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return buildColorPickerDialog(context, false);
                                },
                              );
                            },
                            child: Text(
                              "light color",
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                          Expanded(child: Container()),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return buildColorPickerDialog(context, true);
                                },
                              );
                            },
                            child: Text(
                              "dark color",
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                        ],
                      ),

                      // APPS NUMBER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(
                                  settingsLogic.numberOfShortcutItemsNotifier);
                            },
                            child: Text(
                              "app number",
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                          Expanded(child: Container()),
                          ValueListenableBuilder<int>(
                              valueListenable:
                                  settingsLogic.numberOfShortcutItemsNotifier,
                              builder: (context, numOfShortcutItems, child) {
                                return SizedBox(
                                    width: 86,
                                    child: TextButton(
                                      onPressed: () {
                                        settingsLogic.setNotifierValueAndSave(
                                            settingsLogic.numberOfShortcutItemsNotifier);
                                      },
                                      child: Center(
                                          child: Text(
                                              numOfShortcutItems.toString(),
                                              style: TEXT_STYLE_ITEMS)),
                                    ));
                              }),
                        ],
                      ),

                      // CLOCK APP
                      Row(
                        children: [
                          TextButton(
                              onLongPress: () {},
                              onPressed: () {
                                pushAppSearch(
                                    appShortcutsManager.clockAppNotifier);
                              },
                              child: Text(
                                NAME_TOP_BAR_LEFT,
                                style: TEXT_STYLE_ITEMS,
                              )),
                          Expanded(
                            child: Container(),
                          ),
                          ShowHideButton(
                            notifier: settingsLogic.clockWidgetEnabledNotifier,
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(
                                  settingsLogic.clockWidgetEnabledNotifier);
                            },
                          ),
                        ],
                      ),

                      // WEATHER APP
                      Row(
                        children: [
                          TextButton(
                              onLongPress: () {},
                              onPressed: () {
                                pushAppSearch(
                                    appShortcutsManager.weatherAppNotifier);
                              },
                              child: Text(
                                NAME_TOP_BAR_MIDDLE,
                                style: TEXT_STYLE_ITEMS,
                              )),
                          Expanded(child: Container()),
                          ShowHideButton(
                            notifier: settingsLogic.weatherWidgetEnabledNotifier,
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(settingsLogic.weatherWidgetEnabledNotifier);
                            },
                          ),
                        ],
                      ),

                      // CALENDAR APP
                      Row(
                        children: [
                          TextButton(
                            onLongPress: () {},
                            onPressed: () {
                              pushAppSearch(
                                  appShortcutsManager.calendarAppNotifier);
                            },
                            child: Text(
                              NAME_TOP_BAR_RIGHT,
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                          Expanded(child: Container()),
                          ShowHideButton(
                            notifier: settingsLogic.calendarWidgetEnabledNotifier,
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(
                                  settingsLogic.calendarWidgetEnabledNotifier);
                            },
                          ),
                        ],
                      ),

                      // SWIPE LEFT
                      TextButton(
                          onLongPress: () {},
                          onPressed: () {
                            pushAppSearch(
                                appShortcutsManager.swipeLeftAppNotifier);
                          },
                          child: Text(
                            NAME_SWIPE_LEFT,
                            style: TEXT_STYLE_ITEMS,
                          )),

                      // SWIPE RIGHT
                      TextButton(
                          onLongPress: () {},
                          onPressed: () {
                            pushAppSearch(
                                appShortcutsManager.swipeRightAppNotifier);
                          },
                          child: Text(
                            NAME_SWIPE_RIGHT,
                            style: TEXT_STYLE_ITEMS,
                          )
                      ),



                      // MORE SETTINGS
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MoreSettings()),
                            );
                          },
                          child: Text(
                            NAME_MORE,
                            style: TEXT_STYLE_ITEMS,
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildColorPickerDialog(BuildContext context, bool isDarkMode) {
    var selectedColor = isDarkMode ? themeManager.darkMode.background : themeManager.lightMode.background;

    return AlertDialog(
      title: const Text('Pick a background color',
        style: TextStyle(
        fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              labelTypes: [],
              pickerAreaHeightPercent: 0.8,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: const Text('APPLY'),
                onPressed: () {
                  print(selectedColor);
                  themeManager.setBackgroundColor(isDarkMode, selectedColor);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
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
