import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color canvas = Color(0xFFF6F1E8);
  static const Color ink = Color(0xFF14213D);
  static const Color forest = Color(0xFF255F4B);
  static const Color gold = Color(0xFFEF9B20);
  static const Color sand = Color(0xFFE7D7C1);
  static const Color card = Color(0xFFFFFCF6);
  static const Color muted = Color(0xFF6B7280);
  static const Color error = Color(0xFFB42318);
}

abstract final class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Georgia',
    scaffoldBackgroundColor: AppColors.canvas,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.ink,
          secondary: AppColors.gold,
          surface: AppColors.card,
          error: AppColors.error,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      behavior: SnackBarBehavior.floating,
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      backgroundColor: AppColors.sand,
      selectedColor: AppColors.gold.withValues(alpha: 0.2),
      labelStyle: const TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.ink,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}
