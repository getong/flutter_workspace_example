import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.customPaint)
class CustomPaintPage extends StatelessWidget {
  const CustomPaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPaint Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'CustomPaint lets you draw shapes, lines, and other visuals directly on a canvas with a CustomPainter.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Painted Sales Bars',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'This example paints a simple mini chart without composing multiple box widgets.',
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 220,
                    child: CustomPaint(
                      painter: _SalesBarsPainter(),
                      child: Center(
                        child: Text(
                          'Canvas drawn by CustomPainter',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _SalesBarsPainter extends CustomPainter {
  const _SalesBarsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xFFF5F7FB)
      ..style = PaintingStyle.fill;
    final Paint axisPaint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 2;
    final Paint barPaint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFF5C6BC0), Color(0xFF26A69A)],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Offset.zero & size);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      backgroundPaint,
    );

    final double chartBottom = size.height - 36;
    final double chartLeft = 28;
    final double chartRight = size.width - 20;
    final double chartTop = 24;
    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );

    const List<double> values = <double>[68, 92, 54, 104, 86];
    final double availableWidth = chartRight - chartLeft;
    final double gap = 14;
    final double barWidth =
        (availableWidth - gap * (values.length + 1)) / values.length;
    const double maxValue = 120;

    for (int i = 0; i < values.length; i++) {
      final double left = chartLeft + gap + i * (barWidth + gap);
      final double height = (values[i] / maxValue) * (chartBottom - chartTop);
      final Rect rect = Rect.fromLTWH(
        left,
        chartBottom - height,
        barWidth,
        height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
