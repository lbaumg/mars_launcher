import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/services/service_locator.dart';

const INDEX_TO_WEEKDAY = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

const INDEX_TO_MONTH = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

String getPostfixForDayIndex(index) {
  switch (index) {
    case 1:
      return "st";
    case 2:
      return "nd";
    default:
      return "th";
  }
}


class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  final clockLogic = ClockLogic();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: clockLogic.timeNotifier,
        builder: (context, currentTime, child) {
          return RichText(
              text: TextSpan(
            text: currentTime,
            style: TextStyle(
              fontSize: FONT_SIZE_CLOCK,
              fontFamily: FONT_REGULAR,
            ),
            children: <TextSpan>[
              TextSpan(
                text: clockLogic.currentDate,
                style: TextStyle(
                  fontSize: FONT_SIZE_CLOCK_DATE,
                  height: 1.8,
                  fontFamily: FONT_LIGHT,

                ),
              ),
            ],
          ));
        });
  }

  @override
  void dispose() {
    clockLogic.stopTimer();
    super.dispose();
  }
}

class ClockLogic {
  final timeNotifier = ValueNotifier("");
  late Timer timer;
  var currentDate = "";


  ClockLogic() {
    _updateClock();
    timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateClock());
  }

  void _updateClock() {
    var now = DateTime.now();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    var newTime = "$hour : $minute\n";
    if (newTime != timeNotifier.value) {
      timeNotifier.value = newTime;
      currentDate = "${INDEX_TO_WEEKDAY[now.weekday]},  ${now.day}${getPostfixForDayIndex(now.day)} ${INDEX_TO_MONTH[now.month]?.substring(0,3)}";
    }
  }

  void stopTimer() {
    timer.cancel();
  }
}
