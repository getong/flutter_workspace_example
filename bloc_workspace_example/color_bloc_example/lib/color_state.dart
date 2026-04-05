import 'package:flutter/material.dart';

abstract class ColorState {
  final Color color;
  const ColorState(this.color);
}

class RedColorState extends ColorState {
  const RedColorState() : super(Colors.red);
}

class BlueColorState extends ColorState {
  const BlueColorState() : super(Colors.blue);
}

class GreenColorState extends ColorState {
  const GreenColorState() : super(Colors.green);
}

class OrangeColorState extends ColorState {
  const OrangeColorState() : super(Colors.orange);
}
