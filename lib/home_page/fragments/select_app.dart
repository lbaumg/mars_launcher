import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/home_page/custom_widgets/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';
import 'package:flutter_mars_launcher/models/app_model.dart';
import 'package:provider/provider.dart';

class SelectApps extends StatefulWidget {
  final List<AppInfo> apps;

  SelectApps({required this.apps});

  @override
  _SelectAppsState createState() => _SelectAppsState();
}

class _SelectAppsState extends State<SelectApps> {
  TextEditingController _textController = TextEditingController();
  List<AppInfo> filteredApps = [];

  onItemChanged(String value) {
    setState(() {
      filteredApps = widget.apps
          .where((app) => app.appName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
    if (filteredApps.length == 1) {
      filteredApps.first.open();
    }

  }

  @override
  void initState() {
    super.initState();
    filteredApps = widget.apps;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: Colors.white,
              cursorWidth: 0,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)
                  )
              ),
              controller: _textController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              onChanged: onItemChanged,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 20.0, 0, 0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: filteredApps.map((app) => AppCard(appInfo: app, isShortcutItem: false,)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




