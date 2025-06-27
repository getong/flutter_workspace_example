import 'package:flutter/material.dart';

/// App-wide constants for styling and configuration
class AppConstants {
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0)),
    ],
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    shadows: [
      Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0)),
    ],
  );

  static const TextStyle centerTitleStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cornerTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [Shadow(blurRadius: 5, color: Colors.black)],
  );

  static const TextStyle interactiveTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle interactiveSubtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Colors
  static const List<Color> unsafeGradient = [Colors.red, Colors.orange];
  static const List<Color> safeGradient = [Colors.green, Colors.blue];

  // Interactive page gradients
  static final List<Color> interactiveSafeGradient = [
    Colors.green.shade400,
    Colors.blue.shade600,
  ];

  static final List<Color> interactiveUnsafeGradient = [
    Colors.red.shade400,
    Colors.orange.shade600,
  ];

  // Spacing
  static const double defaultPadding = 20.0;
  static const double smallPadding = 10.0;
  static const double largePadding = 40.0;

  // Icon sizes
  static const double largeIconSize = 100.0;
  static const double mediumIconSize = 80.0;
  static const double smallIconSize = 30.0;

  // Grid painter settings
  static const double gridSpacing = 30.0;
  static const double gridOpacity = 0.1;

  // Button settings
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 16,
  );

  // Divider settings
  static const double dividerHeight = 4.0;
  static const double dividerIndicatorWidth = 100.0;
  static const double dividerIndicatorHeight = 2.0;
}
