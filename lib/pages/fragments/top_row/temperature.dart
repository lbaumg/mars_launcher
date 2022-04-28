
import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/temperature_logic.dart';
import 'package:mars_launcher/services/service_locator.dart';


class Temperature extends StatelessWidget {
  final temperatureLogic = getIt<TemperatureLogic>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: temperatureLogic.temperatureNotifier,
        builder: (context, temperature, child) {
        return Text(
          temperature,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600),
        );
      }
    );
  }
}
