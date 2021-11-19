//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//
// class CalendarModel extends ChangeNotifier{
//   late DeviceCalendarPlugin _deviceCalendarPlugin;
//   late List<Calendar> _calendars;
//
//   // List<Calendar> get _readOnlyCalendars => _calendars?.where((c) => c.isReadOnly).toList() ?? List.filled (0, 0);
//
//   _CalendarsPageState() {
//     _deviceCalendarPlugin = DeviceCalendarPlugin();
//   }
//
//   void _retrieveCalendars() async {
//     try {
//       var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
//       if (permissionsGranted.isSuccess && !permissionsGranted.data) {
//         permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
//         if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
//           return;
//         }
//       }
//
//       final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
//         _calendars = calendarsResult.data;
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
//
//
// }