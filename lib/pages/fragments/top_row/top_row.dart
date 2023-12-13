/// Top row of home screen, contains widgets from pages/fragments/top_row

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:mars_launcher/logic/battery_manager.dart';
import 'package:mars_launcher/logic/settings_manager.dart';
import 'package:mars_launcher/logic/shortcut_manager.dart';
import 'package:mars_launcher/pages/fragments/top_row/battery.dart';
import 'package:mars_launcher/pages/fragments/top_row/event.dart';
import 'package:mars_launcher/pages/fragments/top_row/clock.dart';
import 'package:mars_launcher/pages/fragments/top_row/temperature.dart';
import 'package:mars_launcher/services/service_locator.dart';

class TopRow extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsManager>();
  final batteryLogic = getIt<BatteryManager>();

  TopRow({
    Key? key,
  }) : super(key: key) {
    batteryLogic.updateBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CLOCK WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.clockWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            // padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                            // minimumSize: Size(0, 25.0), // Adjust minimum height
                            alignment: Alignment.center,
                            // backgroundColor: Colors.blue
                        ),
                        onPressed: () =>
                            appShortcutsManager.clockAppNotifier.value.open(),
                        onLongPress: () {
                          openCreateAlarmDialog(
                              context, isDarkMode);
                        },
                        child: Clock())
                    : TextButton(onPressed: () {}, child: SizedBox.shrink());
              }),

          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.batteryWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return Expanded(
                  child: Container(),
                  flex: isEnabled ? 1 : 0,
                );
              }),

          /// BATTERY WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.batteryWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                  onPressed: () {}, //TODO battery
                  child: ValueListenableBuilder<int>(
                      valueListenable:
                      batteryLogic.batteryLevelNotifier,
                      builder: (context, batteryLevel, child) {
                        print("BUILDING BATTERYICON AGAIN: $batteryLevel");
                        return BatteryIcon(
                            batteryLevel: batteryLevel,
                            paintColor: Theme.of(context).primaryColor);
                      }),
                )
                    : SizedBox.shrink();
              }),


          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.weatherWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return Expanded(
                  child: Container(),
                  flex: isEnabled ? 1 : 0,
                );
              }),

          /// WEATHER WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.weatherWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            // padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                            // minimumSize: Size(0, 25.0), // Adjust minimum height
                            alignment: Alignment.center,
                            // backgroundColor: Colors.blue
                        ),
                        onPressed: () =>
                            appShortcutsManager.weatherAppNotifier.value.open(),
                        child: Temperature(),
                      )
                    : SizedBox.shrink();
              }),


          Expanded(
            child: Container(),
          ),

          /// CALENDAR WIDGET
          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.calendarWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? EventView()
                    : TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                        ),
                        child: SizedBox.shrink(),
                      ); // SizedBox.shrink();
              }),
        ],
      ),
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
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: child!,
      );
    },
  );
  if (time != null) {
    FlutterAlarmClock.createAlarm(hour: time.hour, minutes: time.minute);
  }
}
