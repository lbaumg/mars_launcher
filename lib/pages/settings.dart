import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/logic/theme_logic.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:flutter_mars_launcher/services/storage_service/shared_prefs_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();

  @override
  Widget build(BuildContext context) {
    var textStyleTitle = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
    var textStyleSubTitle =
        TextStyle(fontSize: 22, height: 1, fontWeight: FontWeight.bold);
    var textStyleItems = TextStyle(fontSize: 18, height: 1);

    var switchHeight = 30.0;

    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleDarkMode();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("settings", style: textStyleTitle),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                ),
                Text(
                  "general",
                  style: textStyleSubTitle,
                ),
                SizedBox(height: 10),
                Table(
                    // border: TableBorder.all(color: Colors.black),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(180),
                      1: FixedColumnWidth(100),
                    },
                    children: <TableRow>[
                      TableRow(children: <Widget> [
                        Text(
                          "number of\nshortcut items",
                          style: textStyleItems,
                        ),
                        ValueListenableBuilder<int>(
                            valueListenable:
                            appShortcutsManager.numberOfShortcutItemsNotifier,
                            builder: (context, numOfShortcutItems, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    width: 40,
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        appShortcutsManager.decNumberOfShortcutItems();
                                      },
                                    ),
                                  ),
                                  Text(numOfShortcutItems.toString()),
                                  SizedBox(
                                    width: 35,
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        appShortcutsManager.incNumberOfShortcutItems();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          "enable clock app",
                          style: textStyleItems,
                        ),
                        ValueListenableBuilder<bool>(
                            valueListenable:
                                appShortcutsManager.clockEnabledNotifier,
                            builder: (context, isSwitched, child) {
                              return SizedBox(
                                height: switchHeight,
                                child: Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    appShortcutsManager.toggleEnable(
                                        "isSwitchedClock", value);
                                  },
                                  activeTrackColor: Colors.grey[600],
                                  activeColor: Colors.grey[800],
                                  inactiveThumbColor: Colors.grey[400],
                                  inactiveTrackColor: Colors.grey[200],
                                  focusColor: Colors.transparent,
                                ),
                              );
                            }),
                      ]),
                      TableRow(children: <Widget>[
                        Text(
                          "enable weather app",
                          style: textStyleItems,
                        ),
                        ValueListenableBuilder<bool>(
                            valueListenable:
                                appShortcutsManager.weatherEnabledNotifier,
                            builder: (context, isSwitched, child) {
                              return SizedBox(
                                height: switchHeight,
                                child: Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    appShortcutsManager.toggleEnable(
                                        "isSwitchedWeather", value);
                                  },
                                  activeTrackColor: Colors.grey[600],
                                  activeColor: Colors.grey[800],
                                  inactiveThumbColor: Colors.grey[400],
                                  inactiveTrackColor: Colors.grey[200],
                                  focusColor: Colors.transparent,
                                ),
                              );
                            }),
                      ]),
                      TableRow(children: <Widget>[
                        Text(
                          "enable calendar app",
                          style: textStyleItems,
                        ),
                        ValueListenableBuilder<bool>(
                            valueListenable:
                                appShortcutsManager.calendarEnabledNotifier,
                            builder: (context, isSwitched, child) {
                              return SizedBox(
                                height: switchHeight,
                                child: Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    appShortcutsManager.toggleEnable(
                                        "isSwitchedCalendar", value);
                                  },
                                  activeTrackColor: Colors.grey[600],
                                  activeColor: Colors.grey[800],
                                  inactiveThumbColor: Colors.grey[400],
                                  inactiveTrackColor: Colors.grey[200],
                                  focusColor: Colors.transparent,
                                ),
                              );
                            }),
                      ]),
                    ]),
                SizedBox(height: 100),
                Text(
                  "select apps",
                  style: textStyleSubTitle,
                ),
                SizedBox(height: 5),
                Table(
                  // border: TableBorder.all(color: Colors.white),
                  defaultColumnWidth: FixedColumnWidth(150),
                  children: <TableRow>[
                    TableRow(children: <Widget>[
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "swipe left app",
                            style: textStyleItems,
                          )),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "swipe right app",
                            style: textStyleItems,
                          )),
                    ]),
                    TableRow(children: <Widget>[
                      ValueListenableBuilder<bool>(
                          valueListenable:
                              appShortcutsManager.clockEnabledNotifier,
                          builder: (context, isSwitched, child) {
                            return isSwitched
                                ? TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "clock app",
                                      style: textStyleItems,
                                    ))
                                : Container();
                          }),
                      ValueListenableBuilder<bool>(
                          valueListenable:
                              appShortcutsManager.calendarEnabledNotifier,
                          builder: (context, isSwitched, child) {
                            return isSwitched
                                ? TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "calendar app",
                                      style: textStyleItems,
                                    ))
                                : Container();
                          }),
                    ]),
                    TableRow(children: <Widget>[
                      ValueListenableBuilder<bool>(
                          valueListenable:
                              appShortcutsManager.weatherEnabledNotifier,
                          builder: (context, isSwitched, child) {
                            return isSwitched
                                ? TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "weather app",
                                      style: textStyleItems,
                                    ))
                                : Container();
                          }),
                      Container()
                    ])
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
