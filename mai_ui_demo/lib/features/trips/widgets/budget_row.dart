import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';

class BudgetRow extends StatelessWidget {
  const BudgetRow(this.label, this.value, {super.key});
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(label, style: const TextStyle(color: muted)),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: forest,
        ),
      ),
    ],
  );
}
