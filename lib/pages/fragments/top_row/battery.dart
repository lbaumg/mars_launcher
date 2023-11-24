import 'package:flutter/material.dart';

class BatteryIcon extends StatelessWidget {
  final int batteryLevel;

  BatteryIcon({required this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BatteryPainter(batteryLevel: batteryLevel),
      size: Size(45, 30), // Hier kannst du die Größe des Icons anpassen
    );
  }
}

class BatteryPainter extends CustomPainter {
  final int batteryLevel;

  BatteryPainter({required this.batteryLevel});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white // Farbe des Batterie-Icons
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    Rect batteryRect = Rect.fromPoints(Offset(10, 10), Offset(size.width - 10, size.height - 10));

    canvas.drawRect(batteryRect, paint);

    if (batteryLevel > 0) {
      Paint fillPaint = Paint()
        ..color = Colors.white // Farbe des gefüllten Bereichs
        ..style = PaintingStyle.fill;

      double fillPercentage = batteryLevel / 100.0;
      double fillWidth = (size.width - 20) * fillPercentage;

      Rect fillRect = Rect.fromPoints(Offset(10, 10), Offset(10 + fillWidth, size.height - 10));

      canvas.drawRect(fillRect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}