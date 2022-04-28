import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService {
  final location = new Location();
  var locationData = LocationData.fromMap(Map());

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
    if ((!serviceEnabled && !await location.requestService()) || await location.hasPermission() == PermissionStatus.denied) {
      return false;
    } else {
      return true;
    }
  }

  updateLocation() async {
    locationData = await location.getLocation();
  }
}
