import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/theme_logic.dart';

const MAX_LENGTH_RENAMED_APP = 30;

class RenameAppDialog extends StatelessWidget {
  final AppInfo appInfo;

  RenameAppDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).primaryColor; // Color(0xffa4133c);

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      title: Text(
        "Rename app",
        style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "App name: ${appInfo.appName}",
          ),
          Text("Display name: ${appInfo.getDisplayName()}"),
          AppNameTextFieldWithValidation(appInfo.getDisplayName(), appInfo.appName),
        ],
      ),
    );
  }
}

class AppNameTextFieldWithValidation extends StatefulWidget {
  final String currentDisplayName;
  final String appName;

  AppNameTextFieldWithValidation(this.currentDisplayName, this.appName);

  @override
  _AppNameTextFieldWithValidation createState() => _AppNameTextFieldWithValidation();
}

class _AppNameTextFieldWithValidation extends State<AppNameTextFieldWithValidation> {
  TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final displayNameEqualsAppName = widget.currentDisplayName == widget.appName;

    _controller.text = widget.currentDisplayName;
    return Column(
      children: [
        TextField(
          maxLength: MAX_LENGTH_RENAMED_APP,
          controller: _controller,
          cursorColor: COLOR_ACCENT,
          decoration: InputDecoration(
              // counterText: "",
              errorText: _errorText,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_ACCENT)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_ACCENT)),
              border: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_ACCENT)),
              focusColor: Colors.redAccent,
              hintText: "Enter new name",
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? COLOR_ACCENT.withOpacity(0.4)
                    : COLOR_ACCENT.withOpacity(0.3), //Colors.black45,
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    _controller.text = widget.appName;
                    // Navigator.pop(context, widget.appName);
                  },
                  child: Text("Reset",
                    style: TextStyle(color: Colors.redAccent),
                  )),
              TextButton(
                onPressed: () {
                  var newName = _controller.text.trim();
                  if (newName.isEmpty) {
                    setErrorText("Name can't be empty.");
                  } else if (newName == widget.currentDisplayName && displayNameEqualsAppName) {
                    /// If name didn't change, don't call logic
                    Navigator.pop(context, null);
                  } else {
                    /// If name did change return newName
                    Navigator.pop(context, newName);
                  }
                },
                child: Text(
                  "Change",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void setErrorText(errorText) {
    setState(() {
      _errorText = errorText;
    });
  }
}
