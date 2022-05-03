import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:sizer/sizer.dart';

const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 60.0;

const NAME_TOP_BAR_LEFT = "clock app";
const NAME_TOP_BAR_MIDDLE = "weather app";
const NAME_TOP_BAR_RIGHT = "calendar app";
const NAME_SWIPE_LEFT = "swipe left";
const NAME_SWIPE_RIGHT = "swipe right";

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
                  padding: const EdgeInsets.fromLTRB(50, 50.0, ROW_PADDING_RIGHT, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("settings", style: TEXT_STYLE_TITLE),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),
                      SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          // TODO open settings for setting default launcher
                          marsLauncherAppInfo.openSettings();
                        },
                        child: Text(
                          "set default launcher",
                          style: TEXT_STYLE_ITEMS,
                        ),
                      ),

                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => ColorDialog(darkMode: false),
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
                                builder: (_) => ColorDialog(darkMode: true),
                              );
                            },
                            child: Text(
                              "dark color",
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                        ],
                      ),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(settingsLogic.numberOfShortcutItemsNotifier);
                            },
                            child: Text(
                              "shortcut apps",
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                          Expanded(child: Container()),
                          ValueListenableBuilder<int>(
                              valueListenable: settingsLogic.numberOfShortcutItemsNotifier,
                              builder: (context, numOfShortcutItems, child) {
                                return SizedBox(
                                    width: 86,
                                    child: Center(
                                        child: Text(numOfShortcutItems.toString(),
                                            style: TEXT_STYLE_ITEMS)));
                              }),
                        ],
                      ),

                      Row(
                        children: [
                          TextButton(
                              onLongPress: () {},
                              onPressed: () {
                                pushAppSearch(appShortcutsManager.clockAppNotifier);
                              },
                              child: Text(
                                NAME_TOP_BAR_LEFT,
                                style: TEXT_STYLE_ITEMS,
                              )),
                          Expanded(child: Container(),),
                          ShowHideButton(
                            notifier: settingsLogic.clockEnabledNotifier,
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(settingsLogic.clockEnabledNotifier);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                              onLongPress: () {},
                              onPressed: () {
                                pushAppSearch(appShortcutsManager.weatherAppNotifier);
                              },
                              child: Text(
                                NAME_TOP_BAR_MIDDLE,
                                style: TEXT_STYLE_ITEMS,
                              )),
                          Expanded(child: Container()),
                          ShowHideButton(
                            notifier: settingsLogic.weatherEnabledNotifier,
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(settingsLogic.weatherEnabledNotifier);
                              if (settingsLogic.weatherEnabledNotifier.value) {
                                permissionService.ensureLocationPermission();
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onLongPress: () {},
                            onPressed: () {
                              pushAppSearch(appShortcutsManager.calendarAppNotifier);
                            },
                            child: Text(
                              NAME_TOP_BAR_RIGHT,
                              style: TEXT_STYLE_ITEMS,
                            ),
                          ),
                          Expanded(child: Container()),
                          ShowHideButton(
                            notifier: settingsLogic.calendarEnabledNotifier,
                            onPressed: () {
                              settingsLogic.setNotifierValueAndSave(settingsLogic.calendarEnabledNotifier);
                            },
                          ),
                        ],
                      ),
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
                      TextButton(
                          onLongPress: () {},
                          onPressed: () {
                            pushAppSearch(
                                appShortcutsManager.swipeRightAppNotifier);
                          },
                          child: Text(
                            NAME_SWIPE_RIGHT,
                            style: TEXT_STYLE_ITEMS,
                          )),
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
      onPressed: () {onPressed();},
      child: ValueListenableBuilder<bool>(
          valueListenable: notifier,
          builder: (context, enabled, child) {
            return SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  enabled ? "show" : "hide",
                  style: TEXT_STYLE_ITEMS,
                ),
              ),
            );
          }),
    );
  }
}

class ColorDialog extends StatelessWidget {
  ColorDialog({
    Key? key,
    required bool darkMode
  }) : this.darkMode = darkMode, super(key: key);
  final themeManager = getIt<ThemeManager>();
  final darkMode;

  @override
  Widget build(BuildContext context) {
    final dialogWidth = 50.w;
    final backgroundColor = Colors.white; //darkMode ?  Colors.white : Colors.black;
    const edgeInsets = 5.0;
    const crossAxisCount = 3;

    return AlertDialog(
      backgroundColor: backgroundColor,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(edgeInsets + 7),
      content: Container(
        width: dialogWidth,
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (
                childAspectRatio: 1,
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: edgeInsets,
                mainAxisSpacing: edgeInsets
            ),
            itemCount: LIGHT_BACKGROUND_COLORS.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  themeManager.setBackgroundColor(darkMode, index);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(darkMode
                        ? DARK_BACKGROUND_COLORS[index]
                        : LIGHT_BACKGROUND_COLORS[index])),
                child: Container(),
              );
        }),
      ),
    );
  }
}
