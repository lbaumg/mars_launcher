import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mars_launcher/logic/theme_logic.dart';

const BUTTON_BACKGROUND_COLOR_DIALOG = Colors.black;
const BUTTON_TEXT_COLOR_DIALOG = Colors.white;

class ColorPickerDialog extends StatelessWidget {
  final bool isDarkMode;
  final Color initialColor;
  final ThemeManager themeManager;

  ColorPickerDialog({Key? key, required this.isDarkMode, required this.initialColor, required this.themeManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Pick a background color';
    const textButton = 'APPLY';

    var selectedColor = initialColor;

    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: themeManager.theme.primaryColor
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              labelTypes: [],
              pickerAreaHeightPercent: 0.8,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: const Text(textButton),
                onPressed: () {
                  print(selectedColor);
                  themeManager.setBackgroundColor(isDarkMode, selectedColor);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: BUTTON_TEXT_COLOR_DIALOG,
                  backgroundColor: BUTTON_BACKGROUND_COLOR_DIALOG,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
