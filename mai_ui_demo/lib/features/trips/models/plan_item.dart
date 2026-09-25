import 'package:flutter/material.dart';

class PlanItem {
  const PlanItem(
    this.time,
    this.title,
    this.duration,
    this.category,
    this.icon,
  );
  final String time, title, duration, category;
  final IconData icon;
}
