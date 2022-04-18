import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

String _api = "fe944563ad38e93ba270f054ec5b3474";

class Temperature extends StatefulWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  _TemperatureState createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  Timer? timer;
  TemperatureLogic temperatureLogic = TemperatureLogic();

  _updateTemperature() {
    temperatureLogic.updateTemperature().then((bool success){
        if (success) {
          print(temperatureLogic.temperature);
          setState(() {});
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
      temperatureLogic.temperature,
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  @override
  void dispose(){
    timer!.cancel();
    super.dispose();
  }
}



class TemperatureLogic {
  String _tempString = "";
  LocationLogic locationLogic = LocationLogic();
  WeatherFactory wf = WeatherFactory(_api);

  String get temperature => _tempString;

  Future<bool> updateTemperature() async {
    await locationLogic.updateLatLon();
    Weather w = await wf.currentWeatherByLocation(locationLogic.lat, locationLogic.lon);
    String temp = w.temperature?.celsius?.toInt().toString() ?? "";
    if (temp.isNotEmpty) {
      _tempString = "$temp°C";
      return true;
    } else {
      return false;
    }
  }
}


class LocationLogic {
  Location location = new Location();
  bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  double _lat = 49.44501618703811;
  double _lon = 8.654721930317473;

  double get lat => _lat;
  double get lon => _lon;

  Future<bool> isServiceEnabled() async {
    bool serviceEnabled = false;
    for (int i = 0; i < 10; i++) {
      try {
        serviceEnabled = await location.serviceEnabled();
        return serviceEnabled;
      } on PlatformException {
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
    return serviceEnabled;
  }


  updateLocation() async {
    _serviceEnabled = await isServiceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  updateLatLon() async {
    await updateLocation();
    _lat = _locationData.latitude ?? _lat;
    _lon = _locationData.longitude ?? _lon;
  }
}
