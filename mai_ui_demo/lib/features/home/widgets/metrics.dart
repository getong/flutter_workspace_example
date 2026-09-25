import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';

class Metrics extends StatelessWidget {
  const Metrics({super.key});
  @override
  Widget build(BuildContext context) => Surface(
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
    child: Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) Container(width: 1, height: 34, color: line),
          Expanded(
            child: Column(
              children: [
                Text(
                  ['预算总额', '已预订项', '天气参考'][i],
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 5),
                Text(
                  ['¥3,600', '2 / 3', '晴 22°C'][i],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: forest,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}
