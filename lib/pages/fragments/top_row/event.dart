/// Queries the device calendars and events for the day and displays the next event in a Text widget

import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/logic/shortcut_logic.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';

class EventView extends StatefulWidget {
  const EventView({
    Key? key,
  }) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  late CalenderLogic calenderLogic = CalenderLogic();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: appShortcutsManager.weatherEnabledNotifier,
        builder: (context, isWeatherEnabled, child) {
          var letterLength = isWeatherEnabled ? 15 : 21;
          return Container(
            constraints: BoxConstraints(maxWidth: isWeatherEnabled ? 140 : 180),
            child: TextButton(
              onPressed: () {
                calenderApp.open();
              },
              onLongPress: () {
                // TODO create new event
              },
              child: ValueListenableBuilder<String>(
                  valueListenable: calenderLogic.eventNotifier,
                  builder: (context, event, child) {
                    return Text(
                      event.length > letterLength
                          ? ".." + event.substring(event.length - letterLength)
                          : event,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    );
                  }),
            ),
          );
        });
  }

  @override
  void dispose() {
    calenderLogic.stopTimer();
    super.dispose();
  }
}

class CalenderLogic {
  final ValueNotifier<String> eventNotifier = ValueNotifier("no events");
  late Timer timer;

  String _nextEvent = "no events";
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> _calendars = [];
  DateTime _lastUpdatedCalendars = DateTime.now();

  List<Calendar> get _defaultCalendars =>
      _calendars.where((c) => c.isDefault == true).toList();

  String get nextEvent => _nextEvent;

  CalenderLogic() {
    updateEvents();
    timer = Timer.periodic(Duration(minutes: 1), (timer) => updateEvents());
  }

  Future updateEvents() async {
    DateTime now = DateTime.now();
    if (now.compareTo(_lastUpdatedCalendars) >= 0) {
      await _retrieveCalendars();
      _lastUpdatedCalendars = now.add(Duration(days: 7));
    }
    eventNotifier.value = await _retrieveCalendarEvents();
  }

  Future _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult.data as List<Calendar>;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<String> _retrieveCalendarEvents() async {
    /// Reads calendar events
    /// returns next occuring event
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day + 1);

    List<Event> events = [];
    for (Calendar calendar in _calendars) {
      var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendar.id, RetrieveEventsParams(startDate: now, endDate: midnight));
      events.addAll(calendarEventsResult.data as List<Event>);
    }
    String newNextEvent = "no events";
    if (events.isNotEmpty) {
      events.sort((a, b) => a.start!.compareTo(b.start!));
      if (events.length > 1 && events.any((element) => !element.allDay!)) {
        events.removeWhere((element) => element.allDay!);
      }

      var nextEvent = events.first;
      if (nextEvent.allDay!) {
        newNextEvent = nextEvent.title!;
      } else {
        String startTime =
            "${nextEvent.start!.hour.toString().padLeft(2, '0')}:${nextEvent.start!.minute.toString().padLeft(2, '0')}";
        newNextEvent = "${nextEvent.title!} ($startTime)";
      }
    }
    return newNextEvent;
  }

  void stopTimer() {
    timer.cancel();
  }
}
