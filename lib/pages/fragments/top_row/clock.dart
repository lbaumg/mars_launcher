import 'dart:async';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  ClockLogic clockLogic = ClockLogic();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: clockLogic.timeNotifier,
        builder: (context, currentTime, child) {
        return Text(
          currentTime,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        );
      }
    );
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
    String hour = DateTime.now().hour.toString().padLeft(2, '0');
    String minute = DateTime.now().minute.toString().padLeft(2, '0');
    timeNotifier.value = "$hour:$minute";
  }

  void stopTimer() {
    timer.cancel();
  }
}
