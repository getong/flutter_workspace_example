import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/widgets/landscape_painter.dart';

class LandscapeArt extends StatelessWidget {
  const LandscapeArt({super.key, this.village = false, this.height = 220});
  final bool village;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: LandscapePainter(village)),
    ),
  );
}
