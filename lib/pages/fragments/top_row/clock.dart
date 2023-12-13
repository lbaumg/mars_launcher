import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/theme/theme_constants.dart';



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
          return Text(
            currentTime,
            style: TextStyle(
              fontSize: FONT_SIZE_CLOCK,
              fontFamily: FONT_REGULAR,
            ),
          );
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


  ClockLogic() {
    _updateClock();
    timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateClock());
  }

  void _updateClock() {
    var now = DateTime.now();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    var newTime = "$hour:$minute";
    if (newTime != timeNotifier.value) {
      timeNotifier.value = newTime;
    }
  }

  void stopTimer() {
    timer.cancel();
  }
}
