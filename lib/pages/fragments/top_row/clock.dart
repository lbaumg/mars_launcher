import 'dart:async';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late ClockLogic clockLogic;

  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    clockLogic = ClockLogic(this.callback);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      clockLogic.currentTime,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  @override
  void dispose() {
    clockLogic.stopTimer();
    super.dispose();
  }
}

class ClockLogic {
  Function callback;
  late Timer timer;
  late String currentTime;
  String previousTime = "-1:-1";

  ClockLogic(this.callback) {
    _updateClock();
    timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateClock());
  }

  void _updateClock() {
    String hour = DateTime.now().hour.toString().padLeft(2, '0');
    String minute = DateTime.now().minute.toString().padLeft(2, '0');
    currentTime = "$hour:$minute";
    if (currentTime != previousTime) {
      callback();
      previousTime = currentTime;
    }
  }

  void stopTimer() {
    timer.cancel();
  }
}
