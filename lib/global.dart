import 'package:mars_launcher/data/app_info.dart';

const List<String> IGNORED_APPS = ["com.cloudcatcher.mars_launcher"];

const JSON_KEY_PACKAGE_NAME = "packageName";
const JSON_KEY_APP_NAME = "appName";
const JSON_KEY_SYSTEM_APP = "systemApp";
const JSON_KEY_DISPLAY_NAME = "appDisplayName";
const JSON_KEY_APP_IS_HIDDEN = "appIsHidden";

const UNINITIALIZED_APP_NAME = "hold to set";

final marsLauncherAppInfo = AppInfo(packageName: "com.cloudcatcher.mars_launcher", appName: "mars_launcher");
final genericAppInfo = AppInfo(packageName: "", appName: UNINITIALIZED_APP_NAME);


const LOAD_APPS_FROM_JSON = false;

const int MIN_NUM_OF_SHORTCUT_ITEMS = 0;
const int MAX_NUM_OF_SHORTCUT_ITEMS = 7;
const bool LOAD_FROM_JSON = true;
const UPDATE_TEMPERATURE_EVERY = 5; // in minutes

const TEXT_CALENDER_EMPTY = "no events";

const double FONT_SIZE_TEMPERATURE = 15;
const double FONT_SIZE_CLOCK = 15;
const double FONT_SIZE_CLOCK_DATE = 15;
const double FONT_SIZE_EVENTS = 15;
