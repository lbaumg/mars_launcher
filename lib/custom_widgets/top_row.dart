import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/global.dart';

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
            child: Text(
              // TODO implement clock
              "16:20",
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                // fontWeight: FontWeight.w00
              ),
            ),
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
      ),
    );
  }
}