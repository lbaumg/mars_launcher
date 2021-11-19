
import 'package:flutter/cupertino.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';

class ShortcutAppsNotifier extends ValueNotifier<List<AppInfo>> {
  ShortcutAppsNotifier() : super(initialShortcutApps);



  void replaceShortcut(int index, AppInfo newShortcutApp) {
    // if (0 < index || index > 3) {
    //   return;
    // }
    print("INDEX: $index");
    if ([0,1,2,3].contains(index)) {
      value[index] = newShortcutApp;
      print("REPLACED SHORTCUT");
      notifyListeners();
    }
  }
}