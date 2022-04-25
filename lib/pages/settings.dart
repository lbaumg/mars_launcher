import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:flutter_mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';

var switchHeight = 30.0;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();
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
                    // Text(
                    //   "general",
                    //   style: textStyleSubTitle,
                    // ),
                    SizedBox(height: 10),
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

              // SizedBox(height: 20),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     "select apps",
              //     style: textStyleSubTitle,
              //   ),
              // ),
              // SizedBox(height: 0, width: double.infinity),
              // Table(
              //   // border: TableBorder.all(color: Colors.white),
              //   defaultColumnWidth: FixedColumnWidth(150),
              //   children: <TableRow>[
              //     TableRow(children: <Widget>[
              //       TextButton(
              //           onPressed: () {
              //             pushAppSearch(
              //                 appShortcutsManager.swipeLeftAppNotifier);
              //           },
              //           child: Text(
              //             "swipe left",
              //             style: textStyleItems,
              //           )),
              //       TextButton(
              //           onPressed: () {
              //             pushAppSearch(
              //                 appShortcutsManager.swipeRightAppNotifier);
              //           },
              //           child: Text(
              //             "swipe right",
              //             style: textStyleItems,
              //           )),
              //     ]),
              //     TableRow(children: <Widget>[
              //       ValueListenableBuilder<bool>(
              //           valueListenable:
              //               appShortcutsManager.clockEnabledNotifier,
              //           builder: (context, isSwitched, child) {
              //             return isSwitched
              //                 ? TextButton(
              //                     onPressed: () {
              //                       pushAppSearch(
              //                           appShortcutsManager.clockAppNotifier);
              //                     },
              //                     child: Text(
              //                       "clock",
              //                       style: textStyleItems,
              //                     ))
              //                 : Container();
              //           }),
              //       ValueListenableBuilder<bool>(
              //           valueListenable:
              //               appShortcutsManager.calendarEnabledNotifier,
              //           builder: (context, isSwitched, child) {
              //             return isSwitched
              //                 ? TextButton(
              //                     onPressed: () {
              //                       pushAppSearch(appShortcutsManager
              //                           .calendarAppNotifier);
              //                     },
              //                     child: Text(
              //                       "calendar",
              //                       style: textStyleItems,
              //                     ))
              //                 : Container();
              //           }),
              //     ]),
              //     TableRow(children: <Widget>[
              //       ValueListenableBuilder<bool>(
              //           valueListenable:
              //               appShortcutsManager.weatherEnabledNotifier,
              //           builder: (context, isSwitched, child) {
              //             return isSwitched
              //                 ? TextButton(
              //                     onPressed: () {
              //                       pushAppSearch(
              //                           appShortcutsManager.weatherAppNotifier);
              //                     },
              //                     child: Text(
              //                       "weather",
              //                       style: textStyleItems,
              //                     ))
              //                 : Container();
              //           }),
              //       Container()
              //     ])
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

/*GestureDetector(
                      onDoubleTap: () {},
                      child: Table(
                          // border: TableBorder.all(color: Colors.black),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(180),
                            1: FixedColumnWidth(100),
                          },
                          children: <TableRow>[
                            TableRow(children: <Widget>[
                              Text(
                                "shortcut apps",
                                style: textStyleItems,
                              ),
                              IncDecButton(),
                            ]),
                            TableRow(children: <Widget>[
                              Text(
                                "enable clock app",
                                style: textStyleItems,
                              ),
                              SwitchButton(
                                appShortcutsManager: appShortcutsManager,
                                enabledNotifier:
                                    appShortcutsManager.clockEnabledNotifier,
                                setting: "clockEnabled",
                              ),
                            ]),
                            TableRow(children: <Widget>[
                              Text(
                                "enable weather app",
                                style: textStyleItems,
                              ),
                              SwitchButton(
                                appShortcutsManager: appShortcutsManager,
                                enabledNotifier:
                                    appShortcutsManager.weatherEnabledNotifier,
                                setting: "weatherEnabled",
                              ),
                            ]),
                            TableRow(children: <Widget>[
                              Text(
                                "enable calendar app",
                                style: textStyleItems,
                              ),
                              SwitchButton(
                                appShortcutsManager: appShortcutsManager,
                                enabledNotifier:
                                    appShortcutsManager.calendarEnabledNotifier,
                                setting: "calendarEnabled",
                              ),
                            ]),
                          ]),
                    ),*/
