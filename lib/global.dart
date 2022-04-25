import 'package:flutter_mars_launcher/data/app_info.dart';

const List<String> IGNORED_APPS = ["com.cloudcatcher.mars_launcher"];

final marsLauncherAppInfo = AppInfo(packageName: "com.cloudcatcher.mars_launcher", appName: "mars_launcher");
final genericAppInfo = AppInfo(packageName: "", appName: "select");

const JSON_KEY_PACKAGE_NAME = "packageName";
const JSON_KEY_APP_NAME = "appName";
const JSON_KEY_SYSTEM_APP = "systemApp";

const int MIN_NUM_OF_SHORTCUT_ITEMS = 0;
const int MAX_NUM_OF_SHORTCUT_ITEMS = 7;
const bool LOAD_FROM_JSON = true;
const UPDATE_TEMPERATURE_EVERY = 5; // in minutes
