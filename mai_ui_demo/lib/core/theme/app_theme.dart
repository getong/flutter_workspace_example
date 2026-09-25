import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';

ThemeData buildAppTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: paper,
  colorScheme: ColorScheme.fromSeed(
    seedColor: forest,
    primary: forest,
    secondary: orange,
    surface: paper,
  ),
  fontFamilyFallback: const [
    'PingFang SC',
    'Microsoft YaHei',
    'Noto Sans CJK SC',
  ],
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, height: 1.6, color: ink),
    bodySmall: TextStyle(color: muted, height: 1.5),
  ),
  dividerColor: line,
  appBarTheme: const AppBarTheme(
    backgroundColor: paper,
    foregroundColor: forest,
    scrolledUnderElevation: 0,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
