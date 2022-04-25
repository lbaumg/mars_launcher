import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = new Location();
  double? lat;
  double? lon;

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

  Future<bool> checkPermission() async {
    bool serviceEnabled = await isServiceEnabled();
    if (!serviceEnabled && !await location.requestService()) {
      return false;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      print("REQUESTING PERMISSION");
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  updateLocation() async {
    LocationData locationData = await location.getLocation();
    lon = locationData.longitude;
    lat = locationData.latitude;
  }
}