import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/apps_logic.dart';
import 'package:mars_launcher/logic/shortcut_logic.dart';
import 'package:mars_launcher/logic/theme_logic.dart';
import 'package:mars_launcher/pages/fragments/app_search_fragment.dart';
import 'package:mars_launcher/services/service_locator.dart';

typedef OpenAppCallback = Function(AppInfo appInfo);

class AppCard extends StatelessWidget {
  final AppInfo appInfo;
  final bool isShortcutItem;
  final OpenAppCallback openApp;
  final allowDialog;

  AppCard(
      {required this.appInfo,
      required this.isShortcutItem,
      required this.openApp,
      this.allowDialog = false});

  @override
  Widget build(BuildContext context) {
    final appShortcutsManager = getIt<AppShortcutsManager>();

    var fontFamily = isShortcutItem ? FONT_REGULAR : FONT_LIGHT;
    var letterSpacing = isShortcutItem ? 1.0 : 0.0;
    var textColor = isShortcutItem
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: TextButton(
        onPressed: () {
          openApp(appInfo);
        },
        onLongPress: () async {
          if (isShortcutItem) {
            int shortcutIndex =
                appShortcutsManager.shortcutAppsNotifier.value.indexOf(appInfo);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                      body: SafeArea(
                          child: AppSearchFragment(
                              appSearchMode: AppSearchMode.chooseShortcut,
                              shortcutIndex: shortcutIndex)))),
            );
          } else {
            if (allowDialog) {
              final result = await showDialog(
                context: context,
                builder: (_) => AppInfoDialog(appInfo: appInfo),
              );

              // Handle the result
              if (result != null) {
                print('Dialog result: $result');
                // TODO change name somehow or reload
                // appInfo.displayName = result;
              }
            }
          }
        },
        child: Text(
          appInfo.getDisplayName(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w100,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder()),
          foregroundColor: MaterialStateProperty.all(textColor),
        ),
      ),
    );
  }
}

class AppInfoDialog extends StatelessWidget {
  AppInfoDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  final AppInfo appInfo;
  final themeManager = getIt<ThemeManager>();
  final appsManager = getIt<AppsManager>();

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).primaryColor; // Color(0xffa4133c);
    final actionColor = Colors.redAccent; //Color(0xffc9184a); // Theme.of(context).primaryColor;
    final buttonStyle = ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent));

    return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          appInfo.appName,
          style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      // TODO open new screen to rename app
                      final result = await showDialog(
                        context: context,
                        builder: (_) => RenameAppDialog(appInfo: appInfo),
                      );
                      // TODO trigger reload of app search
                      if (result != null) {
                        appsManager.addOrUpdateRenamedApp(appInfo, result);
                        Navigator.pop(context, result);
                      }
                    },
                    child: Text(
                      "Rename",
                      style: TextStyle(color: actionColor),
                    ),
                    style: buttonStyle,
                  ),
                  TextButton(
                      onPressed: () {
                        appInfo.hide(true);
                        appsManager.addOrUpdateHiddenApp(appInfo);
                        Fluttertoast.showToast(
                            msg: "${appInfo.appName} is now hidden!",
                            backgroundColor:
                                themeManager.themeModeNotifier.value
                                    ? Colors.white
                                    : Colors.black,
                            textColor: themeManager.themeModeNotifier.value
                                ? Colors.black
                                : Colors.white);

                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Hide",
                        style: TextStyle(color: actionColor),
                      ),
                      style: buttonStyle),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      appInfo.openSettings();
                      Navigator.pop(context, null);
                    },
                    child: Text(
                      "Info",
                      style: TextStyle(color: actionColor),
                    ),
                    style: buttonStyle,
                  ),
                  appInfo.systemApp
                      ? SizedBox.shrink()
                      : TextButton(
                          onPressed: () {
                            appInfo.uninstall();
                            Navigator.pop(context, null);
                          },
                          child: Text(
                            "Uninstall",
                            style: TextStyle(color: actionColor),
                          ),
                          style: buttonStyle,
                        ),
                ])
          ],
        ));
  }
}

class RenameAppDialog extends StatelessWidget {
  final AppInfo appInfo;

  RenameAppDialog({
    Key? key,
    required this.appInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme
        .of(context)
        .primaryColor; // Color(0xffa4133c);

    return AlertDialog(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
          Text(
              "Display name: ${appInfo.getDisplayName()}"
          ),
          AppNameTextFieldWithValidation(appInfo.getDisplayName()),

        ],
      ),

    );
  }
}

class AppNameTextFieldWithValidation extends StatefulWidget {
  final String currentDisplayName;
  AppNameTextFieldWithValidation(this.currentDisplayName);

  @override
  _AppNameTextFieldWithValidation createState() =>
      _AppNameTextFieldWithValidation();
}

class _AppNameTextFieldWithValidation extends State<AppNameTextFieldWithValidation> {
  TextEditingController _controller = TextEditingController();
  String? _errorText;


  @override
  Widget build(BuildContext context) {
    _controller.text = widget.currentDisplayName;
    return Column(
      children: [
        TextField(
          maxLength: 20,
          controller: _controller,
          cursorColor: COLOR_ACCENT,
          decoration: InputDecoration(
            // counterText: "",
              errorText: _errorText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: COLOR_ACCENT)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: COLOR_ACCENT)
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: COLOR_ACCENT)
              ),
              focusColor: Colors.redAccent,
              hintText: "Enter new name",
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? COLOR_ACCENT.withOpacity(0.4) : COLOR_ACCENT.withOpacity(0.3), //Colors.black45,
              )
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
            child: TextButton(
              onPressed: () {
                var newName = _controller.text.trim();
                if (newName.isEmpty) {
                  setErrorText("Name can't be empty.");
                } else if (newName == widget.currentDisplayName) {
                  /// If name didn't change, don't call logic
                  Navigator.pop(context, null);
                } else {
                  /// If name did change return newName
                  Navigator.pop(context, newName);
                }
              },
              child: Text(
                "Change",
                style: TextStyle(
                    color: Colors.redAccent
                ),
              ),
            ),
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