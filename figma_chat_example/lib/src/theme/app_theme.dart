import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const surface = Colors.white;
  const foreground = Color(0xFF16151D);
  const inputBackground = Color(0xFFF3F3F5);
  const border = Color(0x1A000000);

  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.purple500,
    brightness: Brightness.light,
    primary: AppColors.purple500,
    secondary: AppColors.blue500,
    surface: surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    fontFamily: 'SF Pro Display',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: foreground),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: foreground),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.35,
        color: Color(0xFF7B8190),
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 16,
      shadowColor: const Color(0x14000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      margin: EdgeInsets.zero,
    ),
    dividerColor: border,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.purple500, width: 1.4),
      ),
      hintStyle: const TextStyle(color: Color(0xFF98A0AE), fontSize: 14),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
    ),
  );
}

class AppColors {
  static const purple50 = Color(0xFFF7F1FF);
  static const purple500 = Color(0xFF8B5CF6);
  static const blue50 = Color(0xFFEFF6FF);
  static const blue500 = Color(0xFF3B82F6);
  static const pink50 = Color(0xFFFFF1F7);
  static const pink500 = Color(0xFFEC4899);
  static const green500 = Color(0xFF22C55E);
  static const gray50 = Color(0xFFF8FAFC);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray300 = Color(0xFFD6DCE7);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  static const text = Color(0xFF16151D);
}
