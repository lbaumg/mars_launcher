import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        fontFamily: 'NotoSans',
      scaffoldBackgroundColor: Colors.black,

    ),
    home: Home(),
  ));
}




