import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  double seconds = 0.0;

  _currentTime() {
    return "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
  }

  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(
              () {
                seconds = DateTime.now().second / 60;
              },
            ));
  }

  @override
  void initState() {
    super.initState();
    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime(),
      style: TextStyle(
          color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
/*
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}*/
