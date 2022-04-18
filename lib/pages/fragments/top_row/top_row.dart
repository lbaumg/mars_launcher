/// Top row of home screen, contains widgets from pages/fragments/top_row

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/pages/fragments/top_row/event.dart';
import 'package:flutter_mars_launcher/pages/fragments/top_row/clock.dart';
import 'package:flutter_mars_launcher/pages/fragments/top_row/temperature.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';

class TopRow extends StatelessWidget {
  final appShortcutsManager = getIt<AppShortcutsManager>();

  TopRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: appShortcutsManager.clockEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        onPressed: () {
                          clockApp.open();
                        },
                        onLongPress: () {
                          // TODO create alarm
                        },
                        child: Clock())
                    : TextButton(onPressed: () {}, child: Text(""));
              }),
          Expanded(child: Container()),
          ValueListenableBuilder<bool>(
              valueListenable: appShortcutsManager.weatherEnabledNotifier,
              builder: (context, isEnabled, child) {
                return isEnabled
                    ? TextButton(
                        onPressed: () {
                          weatherApp.open();
                        },
                        child: Temperature(),
                      )
                    : Container();
              }),
          Expanded(child: Container()),
          ValueListenableBuilder<bool>(
              valueListenable: appShortcutsManager.calendarEnabledNotifier,
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
    );
  }
}
