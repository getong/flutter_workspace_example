import 'package:flutter/material.dart';

class AtriumColors {
  static const Color background = Color(0xFFF5F6FF);
  static const Color surface = Color(0xFFF5F6FF);
  static const Color surfaceLow = Color(0xFFECF0FF);
  static const Color surfaceMid = Color(0xFFDfe8FF);
  static const Color surfaceHigh = Color(0xFFD7E3FF);
  static const Color surfaceHighest = Color(0xFFCEDDFF);
  static const Color surfaceRaised = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF005E9F);
  static const Color primaryBright = Color(0xFF44A5FF);
  static const Color secondary = Color(0xFF0059B5);
  static const Color onSurface = Color(0xFF1A2F50);
  static const Color onSurfaceVariant = Color(0xFF485C80);
  static const Color onPrimary = Color(0xFFEDF3FF);
  static const Color outline = Color(0xFF9AADD6);
  static const Color outlineStrong = Color(0xFF63779D);
  static const Color success = Color(0xFF32C46C);
  static const Color tertiary = Color(0xFFD797FF);
  static const Color tertiaryDeep = Color(0xFF7C40A2);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFFB5151);
  static const Color errorText = Color(0xFF570008);
}

LinearGradient atriumPrimaryGradient({Alignment begin = Alignment.topLeft}) {
  return LinearGradient(
    begin: begin,
    end: Alignment.bottomRight,
    colors: const [AtriumColors.primary, AtriumColors.primaryBright],
  );
}

List<BoxShadow> atriumShadow({double opacity = 0.12}) {
  return [
    BoxShadow(
      color: AtriumColors.primary.withValues(alpha: opacity),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];
}

ThemeData buildAtriumTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: AtriumColors.primaryBright,
        brightness: Brightness.light,
      ).copyWith(
        primary: AtriumColors.primary,
        secondary: AtriumColors.secondary,
        surface: AtriumColors.surface,
        onSurface: AtriumColors.onSurface,
        onPrimary: AtriumColors.onPrimary,
        outline: AtriumColors.outline,
        error: AtriumColors.error,
      );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AtriumColors.background,
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: AtriumColors.onSurface,
        letterSpacing: -1.2,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: AtriumColors.onSurface,
        letterSpacing: -0.8,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AtriumColors.onSurface,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AtriumColors.onSurface,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        color: AtriumColors.onSurface,
        height: 1.45,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        color: AtriumColors.onSurfaceVariant,
        height: 1.45,
      ),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
      labelMedium: base.textTheme.labelMedium?.copyWith(
        color: AtriumColors.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    ),
    splashFactory: InkRipple.splashFactory,
    dividerColor: Colors.transparent,
  );
}
