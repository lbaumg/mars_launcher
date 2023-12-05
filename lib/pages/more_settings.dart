import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/settings_logic.dart';
import 'package:mars_launcher/logic/temperature_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/hidden_apps.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/strings.dart';
import 'package:url_launcher/url_launcher.dart';

const TEXT_STYLE_TITLE = TextStyle(fontSize: 35, fontWeight: FontWeight.normal);
const TEXT_STYLE_ITEMS = TextStyle(fontSize: 22, height: 1);
const ROW_PADDING_RIGHT = 60.0;

class MoreSettings extends StatefulWidget {
  const MoreSettings({Key? key}) : super(key: key);

  @override
  State<MoreSettings> createState() => _MoreSettingsState();
}

class _MoreSettingsState extends State<MoreSettings>
    with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();
  final temperatureLogic = getIt<TemperatureLogic>();
  var currentlyPopping = false;
  final settingsLogic = getIt<SettingsLogic>();


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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        currentlyPopping = true;
        return true;
      },
      child: GestureDetector(
        onDoubleTap: () {
          themeManager.toggleDarkMode();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(50, 50.0, ROW_PADDING_RIGHT, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("more", style: TEXT_STYLE_TITLE),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),
                      SizedBox(height: 10),

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

                      /// HIDDEN APPS
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HiddenApps()),
                            );
                          },
                          child: Text(
                            Strings.settingsHiddenApps,
                            style: TEXT_STYLE_ITEMS,
                          )
                      ),

                      /// SET API KEY
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildAddOpenWeatherAPIDialog(context);
                            },
                          );
                        },
                        child: Text(
                          "OpenWeather API key",
                          style: TEXT_STYLE_ITEMS,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              backgroundColor: Colors.redAccent
            ),
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
