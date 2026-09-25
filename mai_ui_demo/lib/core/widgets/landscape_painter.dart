import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';

/// Offline vector artwork: Cangshan, Erhai and a winding lakeside route.
class LandscapePainter extends CustomPainter {
  LandscapePainter(this.village);
  final bool village;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 400, size.height / 240);
    final paint = Paint();
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 400, 240),
      paint..color = const Color(0xFFE9ECDD),
    );
    canvas.drawCircle(
      const Offset(313, 49),
      27,
      paint..color = const Color(0xFFE4A16C),
    );
    Path shape(List<Offset> points) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      return path..close();
    }

    canvas.drawPath(
      shape(const [
        Offset(0, 133),
        Offset(65, 50),
        Offset(107, 102),
        Offset(163, 35),
        Offset(227, 110),
        Offset(276, 75),
        Offset(400, 147),
        Offset(400, 240),
        Offset(0, 240),
      ]),
      paint..color = const Color(0xFFBACBB5),
    );
    canvas.drawPath(
      shape(const [
        Offset(0, 165),
        Offset(90, 103),
        Offset(137, 144),
        Offset(207, 91),
        Offset(286, 151),
        Offset(349, 119),
        Offset(400, 152),
        Offset(400, 240),
        Offset(0, 240),
      ]),
      paint..color = const Color(0xFF829E85),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 183)
        ..quadraticBezierTo(104, 148, 218, 177)
        ..quadraticBezierTo(318, 193, 400, 160)
        ..lineTo(400, 240)
        ..lineTo(0, 240)
        ..close(),
      paint..color = const Color(0xFFBED8D2),
    );
    paint
      ..color = const Color(0xFFEEF3E7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(165 + i * 12, 194 + i * 8),
        Offset(267 + i * 15, 194 + i * 8),
        paint,
      );
    }
    paint.style = PaintingStyle.fill;
    canvas.drawPath(
      Path()
        ..moveTo(0, 175)
        ..cubicTo(148, 174, 151, 235, 400, 227)
        ..lineTo(400, 240)
        ..lineTo(0, 240)
        ..close(),
      paint..color = const Color(0xFF4E7556),
    );
    canvas.drawPath(
      Path()
        ..moveTo(16, 190)
        ..cubicTo(118, 183, 136, 241, 322, 232),
      paint
        ..color = const Color(0xFFECD7AD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    paint.style = PaintingStyle.fill;
    for (final x in village ? [55.0, 105.0, 155.0, 285.0] : [42.0, 80.0]) {
      final y = village ? 170.0 : 163.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, 32, 30),
          const Radius.circular(2),
        ),
        paint..color = const Color(0xFFFFF3D9),
      );
      canvas.drawPath(
        shape([Offset(x - 6, y), Offset(x + 16, y - 19), Offset(x + 39, y)]),
        paint..color = forest,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + 12, y + 12, 8, 18),
        paint..color = const Color(0xFFA9784F),
      );
    }
    canvas.drawCircle(const Offset(133, 202), 7, paint..color = orange);
    canvas.drawCircle(const Offset(133, 202), 3, paint..color = Colors.white);
    canvas.restore();
  }

  @override
  bool shouldRepaint(LandscapePainter oldDelegate) =>
      village != oldDelegate.village;
}
