import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/temperature_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/pages/hidden_apps.dart';
import 'package:mars_launcher/services/permission_service.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';
import 'package:url_launcher/url_launcher.dart';


const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 50.0; // TODO look for overflow

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  final appShortcutsManager = getIt<AppShortcutsManager>();
  final themeManager = getIt<ThemeManager>();
  final permissionService = getIt<PermissionService>();
  final settingsLogic = getIt<SettingsLogic>();
  var currentlyPopping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && mounted && !currentlyPopping) {
      currentlyPopping = true;
      Navigator.of(context).pop();
    }
    super.didChangeAppLifecycleState(state);
  }

  void pushAppSearch(ValueNotifierWithKey<AppInfo> specialAppNotifier) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (_) => Scaffold(
                  body: SafeArea(
                      child: AppSearchFragment(
                appSearchMode: AppSearchMode.chooseSpecialShortcut,
                specialShortcutAppNotifier: specialAppNotifier,
              )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        currentlyPopping = true;
        return;
      },
      child: GestureDetector(
        onDoubleTap: () {
          themeManager.toggleDarkMode();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 20, ROW_PADDING_RIGHT, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Strings.settingsTitle, style: TEXT_STYLE_TITLE),
                  // SizedBox(
                  //   height: 30,
                  //   width: double.infinity,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: SingleChildScrollView(
                      child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// SET DEFAULT LAUNCHER
                              TextButton(
                                onPressed: () {
                                  settingsLogic.openDefaultLauncherSettings();
                                },
                                child: Text(
                                  Strings.settingsChangeDefaultLauncher,
                                  style: TEXT_STYLE_ITEMS,
                                ),
                              ),

                              /// LIGHT COLOR / DARK COLOR
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return buildColorPickerDialog(
                                              context, false);
                                        },
                                      );
                                    },
                                    child: Text(
                                      Strings.settingsLightColor,
                                      style: TEXT_STYLE_ITEMS,
                                    ),
                                  ),
                                  // Expanded(child: Container()),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return buildColorPickerDialog(
                                              context, true);
                                        },
                                      );
                                    },
                                    child: Text(
                                      Strings.settingsDarkColor,
                                      style: TEXT_STYLE_ITEMS,
                                    ),
                                  ),
                                ],
                              ),

                              /// APPS NUMBER
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      settingsLogic.setNotifierValueAndSave(
                                          settingsLogic
                                              .numberOfShortcutItemsNotifier);
                                    },
                                    child: Text(
                                      Strings.settingsAppNumber,
                                      style: TEXT_STYLE_ITEMS,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  ValueListenableBuilder<int>(
                                      valueListenable: settingsLogic
                                          .numberOfShortcutItemsNotifier,
                                      builder:
                                          (context, numOfShortcutItems, child) {
                                        return SizedBox(
                                            width: 86,
                                            child: TextButton(
                                              onPressed: () {
                                                settingsLogic.setNotifierValueAndSave(
                                                    settingsLogic
                                                        .numberOfShortcutItemsNotifier);
                                              },
                                              child: Center(
                                                  child: Text(
                                                      numOfShortcutItems
                                                          .toString(),
                                                      style: TEXT_STYLE_ITEMS)),
                                            ));
                                      }),
                                ],
                              ),

                              /// CLOCK APP
                              Row(
                                children: [
                                  TextButton(
                                      onLongPress: () {},
                                      onPressed: () {
                                        pushAppSearch(
                                            appShortcutsManager.clockAppNotifier);
                                      },
                                      child: Text(
                                        Strings.settingsClockApp,
                                        style: TEXT_STYLE_ITEMS,
                                      )),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  ShowHideButton(
                                    notifier:
                                        settingsLogic.clockWidgetEnabledNotifier,
                                    onPressed: () {
                                      settingsLogic.setNotifierValueAndSave(
                                          settingsLogic
                                              .clockWidgetEnabledNotifier);
                                    },
                                  ),
                                ],
                              ),


                              /// WEATHER APP
                              Row(
                                children: [
                                  TextButton(
                                      onLongPress: () {},
                                      onPressed: () {
                                        pushAppSearch(appShortcutsManager
                                            .weatherAppNotifier);
                                      },
                                      child: Text(
                                        Strings.settingsWeatherApp,
                                        style: TEXT_STYLE_ITEMS,
                                      )),
                                  Expanded(child: Container()),
                                  ShowHideButton(
                                    notifier: settingsLogic
                                        .weatherWidgetEnabledNotifier,
                                    onPressed: () {
                                      settingsLogic.setNotifierValueAndSave(
                                          settingsLogic
                                              .weatherWidgetEnabledNotifier);
                                    },
                                  ),
                                ],
                              ),

                              /// CALENDAR APP
                              Row(
                                children: [
                                  TextButton(
                                    onLongPress: () {},
                                    onPressed: () {
                                      pushAppSearch(appShortcutsManager
                                          .calendarAppNotifier);
                                    },
                                    child: Text(
                                      Strings.settingsCalendarApp,
                                      style: TEXT_STYLE_ITEMS,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  ShowHideButton(
                                    notifier: settingsLogic
                                        .calendarWidgetEnabledNotifier,
                                    onPressed: () {
                                      settingsLogic.setNotifierValueAndSave(
                                          settingsLogic
                                              .calendarWidgetEnabledNotifier);
                                    },
                                  ),
                                ],
                              ),

                              /// BATTERY
                              Row(
                                children: [
                                  TextButton(
                                      onLongPress: () {},
                                      onPressed: () {},
                                      child: Text(
                                        Strings.settingsBattery,
                                        style: TEXT_STYLE_ITEMS,
                                      )),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  ShowHideButton(
                                    notifier: settingsLogic
                                        .batteryWidgetEnabledNotifier,
                                    onPressed: () {
                                      settingsLogic.setNotifierValueAndSave(
                                          settingsLogic
                                              .batteryWidgetEnabledNotifier);
                                    },
                                  ),
                                ],
                              ),

                              /// SWIPE LEFT
                              TextButton(
                                  onLongPress: () {},
                                  onPressed: () {
                                    pushAppSearch(
                                        appShortcutsManager.swipeLeftAppNotifier);
                                  },
                                  child: Text(
                                    Strings.settingsSwipeLeft,
                                    style: TEXT_STYLE_ITEMS,
                                  )),

                              /// SWIPE RIGHT
                              TextButton(
                                  onLongPress: () {},
                                  onPressed: () {
                                    pushAppSearch(appShortcutsManager
                                        .swipeRightAppNotifier);
                                  },
                                  child: Text(
                                    Strings.settingsSwipeRight,
                                    style: TEXT_STYLE_ITEMS,
                                  )),

                              // /// MORE SETTINGS
                              // TextButton(
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => const MoreSettings()),
                              //       );
                              //     },
                              //     child: Text(
                              //       Strings.settingsMore,
                              //       style: TEXT_STYLE_ITEMS,
                              //     )
                              // ),

                              /// HIDDEN APPS
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HiddenApps()),
                                    );
                                  },
                                  child: Text(
                                    Strings.settingsHiddenApps,
                                    style: TEXT_STYLE_ITEMS,
                                  )),

                              /// SET API KEY
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildAddOpenWeatherAPIDialog(
                                          context);
                                    },
                                  );
                                },
                                child: Text(
                                  "OpenWeather API key",
                                  style: TEXT_STYLE_ITEMS,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColorPickerDialog(BuildContext context, bool isDarkMode) {
    var selectedColor = isDarkMode
        ? themeManager.darkMode.background
        : themeManager.lightMode.background;

    const title = 'Pick a background color';
    const textButton = 'APPLY';

    return AlertDialog(
      title: const Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              labelTypes: [],
              pickerAreaHeightPercent: 0.8,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: const Text(textButton),
                onPressed: () {
                  print(selectedColor);
                  themeManager.setBackgroundColor(isDarkMode, selectedColor);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowHideButton extends StatelessWidget {
  const ShowHideButton(
      {Key? key, required this.notifier, required this.onPressed})
      : super(key: key);

  final ValueNotifierWithKey<bool> notifier;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: notifier,
          builder: (context, enabled, child) {
            return SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  enabled ? "hide" : "show",
                  style: TEXT_STYLE_ITEMS,
                ),
              ),
            );
          }),
    );
  }
}

Widget buildAddOpenWeatherAPIDialog(BuildContext context) {
  return AlertDialog(
    title: const Text(
      'Set OpenWeather API key',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
            textAlign: TextAlign.justify,
            softWrap: true,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black),
              children: [
                TextSpan(
                  text:
                      "To provide accurate weather predictions for your location, this app uses the OpenWeather API. "
                      "Since the use of the API costs something from 1000 API calls per day and this app is "
                      "and should remain free of charge, anyone who is interested can generate and insert their own API key. "
                      "A API key can be generated by creating an account on ",
                ),
                TextSpan(
                  text: "OpenWeatherMap",
                  style: TextStyle(
                    color: Colors.blue, // Set the color of the link
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Define the URL to open when the link is tapped
                      final uri = Uri.parse("https://openweathermap.org/api");

                      // Use the url_launcher package to open the URL
                      launchUrl(uri);
                    },
                ),
                TextSpan(
                  text: ".",
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          MyTextFieldWithValidation(),
        ],
      ),
    ),
  );
}

class MyTextFieldWithValidation extends StatefulWidget {
  @override
  _MyTextFieldWithValidationState createState() =>
      _MyTextFieldWithValidationState();
}

class _MyTextFieldWithValidationState extends State<MyTextFieldWithValidation> {
  TextEditingController _controller = TextEditingController();
  String? _errorText;

  final temperatureLogic = getIt<TemperatureLogic>();

  @override
  void initState() {
    super.initState();
    if (temperatureLogic.apiKey != null &&
        temperatureLogic.apiKey!.isNotEmpty) {
      _controller.text = temperatureLogic.apiKey!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Enter API Key",
            errorText: _errorText,
          ),
        ),
        SizedBox(height: 16.0),
        Row(children: [
          ElevatedButton(
            onPressed: () {
              temperatureLogic.deleteAPIKey();
              _controller.text = "";
              setErrorText(null);
            },
            child: const Text("DELETE"),
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent),
          ),
          Expanded(child: SizedBox()),
          ElevatedButton(
            child: const Text('ADD'),
            onPressed: () async {
              var apiKey = _controller.text.trim();
              if (await isInputValid(apiKey)) {
                temperatureLogic.addApiKey(apiKey);

                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black87,
            ),
          ),
        ]),
      ],
    );
  }

  /// Checks if apiKey is not empty and valid
  Future<bool> isInputValid(apiKey) async {
    if (apiKey.isEmpty) {
      setErrorText('Field cannot be empty');
      return false;
    } else {
      final isValid = await temperatureLogic.isApiKeyValid(apiKey);
      if (!isValid) {
        setErrorText('API Key not valid');
        return false;
      } else {
        setErrorText(null);
        return true;
      }
    }
  }

  void setErrorText(errorText) {
    setState(() {
      _errorText = errorText;
    });
  }
}
