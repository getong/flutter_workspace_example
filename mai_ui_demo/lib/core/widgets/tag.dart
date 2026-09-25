import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.warm = false});
  final String text;
  final bool warm;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: warm ? const Color(0xFFF7E6D6) : paleGreen,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: warm ? const Color(0xFFA25323) : forest,
      ),
    ),
  );
}
