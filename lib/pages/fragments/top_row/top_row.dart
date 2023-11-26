/// Top row of home screen, contains widgets from pages/fragments/top_row

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:mars_launcher/logic/battery_logic.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/top_row/battery.dart';
import 'package:mars_launcher/pages/fragments/top_row/event.dart';
import 'package:mars_launcher/pages/fragments/top_row/clock.dart';
import 'package:mars_launcher/pages/fragments/top_row/temperature.dart';
import 'package:mars_launcher/services/service_locator.dart';

class TopRow extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsLogic>();
  final themeManager = getIt<ThemeManager>();
  final batteryLogic = getIt<BatteryLogic>();

  TopRow({
    Key? key,
  }) : super(key: key) {
    batteryLogic.updateBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: Stack(alignment: Alignment.topCenter, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// CLOCK WIDGET
                ValueListenableBuilder<bool>(
                    valueListenable: settingsLogic.clockWidgetEnabledNotifier,
                    builder: (context, isEnabled, child) {
                      return SizedBox(
                        height: 30,
                        child: isEnabled
                            ? TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(),
                                  // padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                  // minimumSize: Size(0, 25.0), // Adjust minimum height
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.blue
                                ),
                                onPressed: () => appShortcutsManager
                                    .clockAppNotifier.value
                                    .open(),
                                onLongPress: () {
                                  openCreateAlarmDialog(context, themeManager.themeModeNotifier.value);
                                },
                                child: Clock())
                            : TextButton(onPressed: () {}, child: SizedBox.shrink()),
                      );
                    }),

                /// CALENDAR WIDGET
                SizedBox(
                  height: 50,
                  child: ValueListenableBuilder<bool>(
                      valueListenable:
                          settingsLogic.calendarWidgetEnabledNotifier,
                      builder: (context, isEnabled, child) {
                        return isEnabled
                            ? EventView()
                            : TextButton( onPressed: () {},     style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            backgroundColor: Colors.blue
                        ), child: SizedBox.shrink(),); // SizedBox.shrink();
                      }),
                ),
              ],
            ),
            Expanded(child: Container()),

            /// WEATHER WIDGET
            ValueListenableBuilder<bool>(
                valueListenable: settingsLogic.weatherWidgetEnabledNotifier,
                builder: (context, isEnabled, child) {
                  return isEnabled
                      ? TextButton(
                          onPressed: () => appShortcutsManager
                              .weatherAppNotifier.value
                              .open(),
                          child: Temperature(),
                        )
                      : SizedBox.shrink();
                }),
          ],
        ),
        /// BATTERY WIDGET
        ValueListenableBuilder<bool>(
            valueListenable: settingsLogic.batteryWidgetEnabledNotifier,
            builder: (context, isEnabled, child) {
              return isEnabled
                  ? Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: themeManager.themeModeNotifier,
                        builder: (context, themeMode, child) {
                          return ValueListenableBuilder<int>(
                              valueListenable: batteryLogic.batteryLevelNotifier,
                              builder: (context, batteryLevel, child) {
                                print("BUILDING BATTERYICON AGAIN: $batteryLevel");
                                final paintColor = themeMode ? themeManager.darkMode.textColor : themeManager.lightMode.textColor;
                                return BatteryIcon(batteryLevel: batteryLevel, paintColor: paintColor);
                              });
                        }
                      ),
                    )
                  : SizedBox.shrink();
            })
      ]),
    );
  }
}


void openCreateAlarmDialog(context, isDarkMode) async {
  // TODO maybe adjust theme?
  var time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: "Create a new alarm",
    builder: (context, child) {
      return Theme(
        data: isDarkMode
            ? ThemeData.dark()
            : ThemeData.light(),
        child: child!,
      );
    },
  );
  if (time != null) {
    FlutterAlarmClock.createAlarm(
        time.hour, time.minute);
  }
}