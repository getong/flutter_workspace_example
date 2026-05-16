import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/app_bootstrap.dart';

Future<void> main() async {
  await bootstrapWidgetLayoutApp();
  runApp(createWidgetLayoutApp());
}
