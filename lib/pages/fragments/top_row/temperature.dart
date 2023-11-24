import 'package:flutter/material.dart';
import 'package:mars_launcher/global.dart';
import 'package:mars_launcher/logic/temperature_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/services/service_locator.dart';

class Temperature extends StatelessWidget {
  final temperatureLogic = getIt<TemperatureLogic>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: temperatureLogic.temperatureNotifier,
        builder: (context, temperature, child) {
          return Text(temperature,
              style: TextStyle(
                fontSize: FONT_SIZE_TEMPERATURE,
                fontFamily: FONT_REGULAR,
              ));
        });
  }
}
