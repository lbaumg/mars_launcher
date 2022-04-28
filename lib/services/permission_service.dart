
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionService {
  final calendarActivated = ValueNotifier(false);
  final weatherActivated = ValueNotifier(false);

  PermissionService() {
    ensurePermissions();
  }

  Future ensurePermissions() async {
    await ensureCalendarPermission();
    await ensureLocationPermission();
  }

  Future ensureLocationPermission() async {
    if (await Permission.location.isGranted) {
      weatherActivated.value = true;
    } else {
      PermissionStatus status = await Permission.location.request();
      weatherActivated.value = status.isGranted;
      print("[$runtimeType] Location permission status: $status");
    }
  }

  Future ensureCalendarPermission() async {
    if (await Permission.calendar.isGranted) {
      calendarActivated.value = true;
    } else {
      PermissionStatus status = await Permission.calendar.request();
      calendarActivated.value = status.isGranted;
    }
  }
}
