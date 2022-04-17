/// Queries the device calendars and events for the day and displays the next event in a Text widget

import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/global.dart';

class EventView extends StatefulWidget {
  const EventView({
    Key? key,
  }) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

// TODO long press on calendar -> create new event
class _EventViewState extends State<EventView> {
  Timer? timer;
  late CalenderLogic calenderLogic = CalenderLogic();

  @override
  Widget build(BuildContext context) {
    return Text(
      calenderLogic.nextEvent.length > 15 ? ".." + calenderLogic.nextEvent.substring(calenderLogic.nextEvent.length - 15)
          : calenderLogic.nextEvent,
      softWrap: false,
      style: TextStyle(
        fontSize: 15,
      ),
    );
  }

  _updateEvents() async {
    calenderLogic.updateEvents().then((bool nextEventUpdated) {
      if (nextEventUpdated) {
        setState(() {});
      }
    });
  }

  _triggerUpdate() {
    timer = Timer.periodic(Duration(minutes: 1), (timer) => _updateEvents());
  }

  @override
  void initState() {
    super.initState();
    _triggerUpdate();
    _updateEvents();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}

class CalenderLogic {
  String _nextEvent = "no events";
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars = [];
  DateTime _lastUpdatedCalendars = DateTime.now();

  List<Calendar> get _defaultCalendars =>
      _calendars.where((c) => c.isDefault == true).toList();

  String get nextEvent => _nextEvent;

  CalenderLogic() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  Future<bool> updateEvents() async {
    DateTime now = DateTime.now();
    if (now.compareTo(_lastUpdatedCalendars) >= 0) {
      await _retrieveCalendars();
      _lastUpdatedCalendars = now.add(Duration(days: 7));
    }
    return await _retrieveCalendarEvents();
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

  Future<bool> _retrieveCalendarEvents() async {
    /// Reads calendar events
    /// return true if next retrieved event != currently stored event else false
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day + 1);

    List<Event> events = [];
    for (Calendar calendar in _defaultCalendars) {
      var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendar.id, RetrieveEventsParams(startDate: now, endDate: midnight));
      events.addAll(calendarEventsResult.data as List<Event>);
    }
    String newNextEvent = "no events";
    if (events.isNotEmpty && events.last.title != null && events.last.start != null) {
      String startTime =
          "${events.last.start!.hour.toString().padLeft(2, '0')}:${events.last.start!.minute.toString().padLeft(2, '0')}";
      newNextEvent = "${events.last.title!} ($startTime)";
    }
    if (newNextEvent != _nextEvent) {
      _nextEvent = newNextEvent;
      return true;
    } else {
      return false;
    }
  }
}
