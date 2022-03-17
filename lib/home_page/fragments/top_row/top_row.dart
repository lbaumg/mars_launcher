/// Top row of home screen, contains widgets from home_page/fragments/top_row

import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/home_page/fragments/top_row/event.dart';
import 'package:flutter_mars_launcher/home_page/fragments/top_row/clock.dart';
import 'package:flutter_mars_launcher/home_page/fragments/top_row/temperature.dart';

class TopRow extends StatelessWidget {
  const TopRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              clockApp.open();
            },
            child: Clock(),
          ),
          Expanded(child: Container()),
          TextButton(
            onPressed: () {
              weatherApp.open();
            },
            child: Temperature(),
          ),
          Expanded(child: Container()),
          Container(
            constraints: BoxConstraints(maxWidth: 125),
            child: TextButton(
              onPressed: () {
                calenderApp.open();
              },
              child: EventView(),
            ),
          ),
        ],
      ),
    );
  }
}
