
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionService {
  final permissionCalendarGranted = ValueNotifier(false);

  PermissionService() {
    checkPermissionsOnStartup();
  }

  Future checkPermissionsOnStartup() async{
    await ensureCalendarPermission();
  }

  Future ensureCalendarPermission() async {
    if (await Permission.calendarFullAccess.isGranted) {
      permissionCalendarGranted.value = true;
    } else {
      PermissionStatus status = await Permission.calendarFullAccess.request();
      permissionCalendarGranted.value = status.isGranted;
    }
  }
}
