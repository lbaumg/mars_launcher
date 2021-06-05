import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mars_launcher/home_page/home.dart';
import 'package:flutter_mars_launcher/models/app_model.dart';
import 'package:flutter_mars_launcher/services/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
    statusBarBrightness: Brightness.light,
  ));

  setupGetIt();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        fontFamily: 'NotoSansLight',
      scaffoldBackgroundColor: Colors.black,

    ),
    home: Home(),
  ));
}




