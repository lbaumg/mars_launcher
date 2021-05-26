import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/custom_widgets/clock.dart';
import 'package:flutter_mars_launcher/global.dart';

class TopRow extends StatelessWidget {
  const TopRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            clockApp.open();
          },
          child: Clock(),
        ),
        Expanded(
          child: Container(),
        ),
        TextButton(
          onPressed: () {
            calenderApp.open();
          },
          child: Text(
            "no events",
            style: TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}