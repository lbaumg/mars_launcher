import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';

class CalenderLogic {
  final eventNotifier = ValueNotifier("no events");
  final _deviceCalendarPlugin = DeviceCalendarPlugin();
  final permissionService = getIt<PermissionService>();
  var _calendars = <Calendar>[];
  var _lastUpdatedCalendars = DateTime.now();
  late Timer timer;

  CalenderLogic() {
    updateEvents();
    timer = Timer.periodic(Duration(minutes: 1), (timer) => updateEvents());
    permissionService.calendarActivated.addListener(initializeEvents);
  }

  void initializeEvents() {
    if (permissionService.calendarActivated.value) {
      print("[$runtimeType] initializing events");
      permissionService.calendarActivated.removeListener(initializeEvents);
      updateEvents();
    }
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
      print("[$runtimeType] $e");
    }
  }

  /// Reads calendar events
  /// returns next occuring event
  Future<String> _retrieveCalendarEvents() async {
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
