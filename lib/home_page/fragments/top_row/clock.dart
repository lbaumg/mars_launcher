import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer? timer;

  _currentTime() {
    String hour = DateTime.now().hour.toString().padLeft(2, '0');
    String minute = DateTime.now().minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }


  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => setState(() {})
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime(),
      style: TextStyle(
          color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  @override
  void dispose(){
    timer!.cancel();
    super.dispose();
  }
}
/*
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}*/
