import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final String title;
  final int count;
  final String? subtitle;
  final Color? titleColor;
  final TextStyle? countStyle;

  const CounterDisplay({
    super.key,
    required this.title,
    required this.count,
    this.subtitle,
    this.titleColor,
    this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18, color: titleColor)),
        const SizedBox(height: 10),
        Text(
          '$count',
          style: countStyle ?? Theme.of(context).textTheme.headlineLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ],
    );
  }
}
