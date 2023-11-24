/// Top row of home screen, contains widgets from pages/fragments/top_row

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/top_row/event.dart';
import 'package:mars_launcher/pages/fragments/top_row/clock.dart';
import 'package:mars_launcher/pages/fragments/top_row/temperature.dart';
import 'package:mars_launcher/services/service_locator.dart';

class TopRow extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final settingsLogic = getIt<SettingsLogic>();
  final themeManager = getIt<ThemeManager>();

  TopRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<bool>(
                  valueListenable: settingsLogic.clockWidgetEnabledNotifier,
                  builder: (context, isEnabled, child) {
                    return isEnabled
                        ? TextButton(
                        style: ButtonStyle(
                          // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Adjust the radius to control the roundness
                            ),
                          ),
                        ),


                            onPressed: () => appShortcutsManager.clockAppNotifier.value.open(),
                            onLongPress: () async {
                              var time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                helpText: "Create a new alarm",
                                builder: (context, child) {
                                    return Theme(
                                      data: themeManager.themeModeNotifier.value ? ThemeData.dark() : ThemeData.light(),
                                      child: child!,
                                    );
                                },
                              );
                              if (time != null) {
                                FlutterAlarmClock.createAlarm(time.hour, time.minute);
                              }
                            },
                            child: Clock())
                        : TextButton(onPressed: () {}, child: Text(""));
                  }),

              ValueListenableBuilder<bool>(
                  valueListenable: settingsLogic.calendarWidgetEnabledNotifier,
                  builder: (context, isEnabled, child) {
                    return isEnabled
                        ? EventView()
                        : TextButton(
                      onPressed: () {},
                      child: Text(""),
                    );
                  }),
            ],
          ),
          Expanded(child: Container()),
          ValueListenableBuilder<bool>(
              valueListenable: settingsLogic.weatherWidgetEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        onPressed: () => appShortcutsManager.weatherAppNotifier.value.open(),
                        child: Temperature(),
                      )
                    : SizedBox.shrink();
              }),
          // Expanded(child: Container()),

        ],
      ),
    );
  }
}
