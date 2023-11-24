import 'package:mars_launcher/data/app_info.dart';

const List<String> IGNORED_APPS = ["com.cloudcatcher.mars_launcher"];

const marsLauncherAppInfo = AppInfo(packageName: "com.cloudcatcher.mars_launcher", appName: "mars_launcher");
const genericAppInfo = AppInfo(packageName: "", appName: "long tap to set");

const JSON_KEY_PACKAGE_NAME = "packageName";
const JSON_KEY_APP_NAME = "appName";
const JSON_KEY_SYSTEM_APP = "systemApp";

const int MIN_NUM_OF_SHORTCUT_ITEMS = 0;
const int MAX_NUM_OF_SHORTCUT_ITEMS = 7;
const bool LOAD_FROM_JSON = true;
const UPDATE_TEMPERATURE_EVERY = 5; // in minutes

const TEXT_CALENDER_EMPTY = "nothing scheduled";

const double FONT_SIZE_TEMPERATURE = 20;
const double FONT_SIZE_CLOCK = 20;
const double FONT_SIZE_CLOCK_DATE = 12;
const double FONT_SIZE_EVENTS = 16;
