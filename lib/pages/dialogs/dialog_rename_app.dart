import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/utils.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

const MAX_LENGTH_RENAMED_APP = 30;

class RenameAppDialog extends StatelessWidget {
  final AppInfo appInfo;

  RenameAppDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final titleColor = Theme.of(context).primaryColor; // Color(0xffa4133c);

    final textStyle = TextStyle(
        color: Theme.of(context).scaffoldBackgroundColor,
      fontSize: 18
    );

    return AlertDialog(
      title: Text(
        "Rename \"${appInfo.appName}\"",
        style: TextStyle(
          fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Current name: \"${appInfo.displayName}\"",
            style: textStyle
          ),
          insertVerticalSpacing(20),
          AppNameTextFieldWithValidation(appInfo.displayName, appInfo.appName),
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

    bool isDarkMode = isThemeDark(context);
    final buttonStyle = getDialogButtonStyle(isDarkMode);

    return Column(
      children: [
        TextField(
          maxLength: MAX_LENGTH_RENAMED_APP,
          controller: _controller,
          cursorColor: COLOR_ACCENT,
          style: TextStyle(
            color: COLOR_ACCENT
          ),
          decoration: InputDecoration(
              // counterText: "",
              errorText: _errorText,
              filled: true,
              fillColor: isDarkMode ? Colors.black12 : Colors.white,
              // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_ACCENT)),
              // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_ACCENT)),
              // border: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_ACCENT)),
              focusColor: Colors.redAccent,
              hintText: "Enter new name",
              hintStyle: TextStyle(color: Colors.black54,)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    if (displayNameEqualsAppName) {
                      Navigator.pop(context, null);
                    } else {
                      _controller.text = widget.appName;
                      Navigator.pop(context, widget.appName);
                    }
                  },
                  style: buttonStyle,
                  child: Text("Reset")
              ),
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
                style: buttonStyle,
                child: Text("Change"),
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
