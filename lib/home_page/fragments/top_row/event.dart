import 'dart:async';
import 'dart:io';

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
      calenderLogic.nextEvent.length > 15 ? ".." + calenderLogic.nextEvent.substring(calenderLogic.nextEvent.length - 15) : calenderLogic.nextEvent,
      softWrap: false,
      // overflow:TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
      ),
    );
  }

  _updateEvents() {
    calenderLogic.updateEvents().then((bool success) {
      if (success) {
        print("SET STATE, new event: ${calenderLogic.nextEvent}");
        setState(() {});
      }
    });
  }

  _triggerUpdate() {
    timer = Timer.periodic(Duration(minutes: 10), (timer) => _updateEvents());
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
  bool _calendarsLoaded = false;

  List<Calendar> get _writableCalendars =>
      _calendars.where((c) => c.isReadOnly == false).toList();

  List<Calendar> get _readOnlyCalendars =>
      _calendars.where((c) => c.isReadOnly == true).toList();

  List<Calendar> get _defaultCalendars =>
      _calendars.where((c) => c.isDefault == true).toList();

  CalenderLogic() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    _retrieveCalendars();
    print("CalenderLogic constructor called");
  }

  String get nextEvent => _nextEvent;

  Future<bool> updateEvents() async {
    // if (!_calendarsLoaded) {
    //   print("UPDATING EVENTS");
    //   sleep(Duration(seconds: 2));
    // }
    return await _retrieveCalendarEvents();
  }

  void _retrieveCalendars() async {
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
      print("CALENDARS LOADED");
      _calendarsLoaded = true;
      _retrieveCalendarEvents();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<bool> _retrieveCalendarEvents() async {
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day + 1);

    List<Event> events = [];
    for (Calendar calendar in _defaultCalendars) {
      var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendar.id, RetrieveEventsParams(startDate: now, endDate: midnight));
      events.addAll(calendarEventsResult.data as List<Event>);
    }
    if (events.isEmpty || events.last.title == null || events.last.start == null) {
      return false;
    }
    String title = events.last.title!;
    String start = "${events.last.start!.hour.toString().padLeft(2, '0')}:${events.last.start!.minute.toString().padLeft(2, '0')}";

    _nextEvent = "$title ($start)";
    print(_nextEvent);
    return true;
  }
}
