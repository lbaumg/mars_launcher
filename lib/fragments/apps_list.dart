import 'package:flutter/material.dart';
import 'package:flutter_mars_launcher/custom_widgets/app_card.dart';
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:flutter_mars_launcher/global.dart';

class AppsList extends StatefulWidget {
  final List<AppInfo> apps;
  List<AppInfo> filteredApps = [];

  AppsList({required this.apps});

  @override
  _AppsListState createState() => _AppsListState();
}

class _AppsListState extends State<AppsList> {
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            cursorColor: Colors.white,
            cursorWidth: 0.5,
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
/*            decoration: InputDecoration(
              hintText: 'Search here...',
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.search, color: Colors.white,),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  _textController.clear();
                  onItemChanged("");
                },
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).buttonColor),
              ),
            ),*/
            onChanged: onItemChanged,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 0.0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: filteredApps.map((app) => AppCard(appInfo: app, textColor: Colors.deepOrangeAccent)).toList(),
            ),
          ),
        ],
      ),
    );
    
/*    return Scaffold(      
      body: ListView.builder(
          itemCount: widget.apps.length,
          itemBuilder: (context, index) {
            return Text(
                widget.apps[index].appName,
              style: TextStyle(
                color: Colors.white
              ),
            );
            // return AppCard(appInfo: widget.apps[index]);
          }),
    );*/
  }
}




