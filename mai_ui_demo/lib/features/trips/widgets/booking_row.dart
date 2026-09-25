import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';

class BookingRow extends StatelessWidget {
  const BookingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.amount,
    required this.status,
  });
  final IconData icon;
  final String title, detail, amount, status;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: forest),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(detail, style: const TextStyle(fontSize: 11, color: muted)),
          ],
        ),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, color: forest),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              color: status == '待预订' ? orange : muted,
            ),
          ),
        ],
      ),
    ],
  );
}
