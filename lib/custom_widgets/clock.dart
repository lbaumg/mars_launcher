import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Clock extends StatefulWidget {
  const Clock({Key ?key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  double seconds = 0.0;

  _currentTime() {
    return "${DateTime.now().hour} : ${DateTime.now().minute}";
  }

  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 60),
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
    return Scaffold(
      body: Container(
        color: hexToColor('#E3E3ED'),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: hexToColor('#2c3143'),
                  ),
                ),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.all(36.0),
                    width: 340,
                    height: 340,
                    child: Center(
                      child: Text(
                        _currentTime(),
                        style: GoogleFonts.bungee(
                            fontSize: 60.0,
                            textStyle: TextStyle(color: Colors.white),
                            fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
