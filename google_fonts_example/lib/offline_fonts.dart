import 'package:flutter/material.dart';

class DemoFontOption {
  const DemoFontOption(this.label, {this.fontFamily});

  final String label;
  final String? fontFamily;
}

const List<DemoFontOption> demoFontOptions = <DemoFontOption>[
  DemoFontOption('System Sans'),
  DemoFontOption('Lato', fontFamily: 'Lato'),
  DemoFontOption('System Serif', fontFamily: 'Times New Roman'),
  DemoFontOption('System Monospace', fontFamily: 'Courier New'),
  DemoFontOption('Rounded', fontFamily: 'Avenir Next'),
  DemoFontOption('Display Serif', fontFamily: 'Georgia'),
];

DemoFontOption demoFontByLabel(String label) {
  return demoFontOptions.firstWhere((DemoFontOption option) {
    return option.label == label;
  });
}

TextStyle demoFontStyle(
  DemoFontOption option, {
  TextStyle? textStyle,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  double? height,
  Paint? foreground,
  List<Shadow>? shadows,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  final TextStyle baseStyle = (textStyle ?? const TextStyle()).copyWith(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
    foreground: foreground,
    shadows: shadows,
    decoration: decoration,
    decorationColor: decorationColor,
  );

  return option.fontFamily == null
      ? baseStyle
      : baseStyle.copyWith(fontFamily: option.fontFamily);
}
