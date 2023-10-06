import 'package:flutter/material.dart';

class BezierCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(50, size.height / 2);
    path.quadraticBezierTo(size.width / 2, 0, size.width - 50, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('flutter CustomPaint widget Example'),
        ),
        body: Center(
          child: CustomPaint(
            size: Size(300, 300),
            painter: BezierCurvePainter(),
          ),
        ),
      ),
    );
  }
}
