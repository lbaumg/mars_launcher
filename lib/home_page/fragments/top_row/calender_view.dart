import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';

class CalenderView extends StatelessWidget {
  const CalenderView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "no events",
      style: TextStyle(
        color: textColor,
        fontSize: 15,
      ),
    );
  }
}

// class CalenderLogic {
//   late DeviceCalendarPlugin _deviceCalendarPlugin;
//   late List<Calendar> _calendars;
//
// }
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