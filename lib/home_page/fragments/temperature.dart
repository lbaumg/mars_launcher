import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:weather/weather.dart';

String _api = "fe944563ad38e93ba270f054ec5b3474";

class Temperature extends StatefulWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  _TemperatureState createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  Timer? timer;
  double lat = 49.44501618703811; //TODO get from location
  double lon = 8.654721930317473;
  String temperature = "";
  WeatherFactory wf = WeatherFactory(_api);

  Future<String?> _currentTemperature() async {
    Weather w = await wf.currentWeatherByLocation(lat, lon);
    String? temp = w.temperature?.celsius.toString();
    return temp?.substring(0,3).padRight(4,"°C");
  }

  _updateTemperature() {
    _currentTemperature().then((String? result){
      if (result != null) {
        print("New temperature: $result");
        setState(() {
          temperature = result; //.toString();
        });
      }
    });
  }

  _triggerUpdate() {
    timer = Timer.periodic(
        Duration(minutes: 10),
        (timer) => _updateTemperature()
    );
  }

  @override
  void initState() {
    super.initState();
    _triggerUpdate();
    _updateTemperature();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      temperature,
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
