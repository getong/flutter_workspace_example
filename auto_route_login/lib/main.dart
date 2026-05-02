import 'package:auto_route_login/app/app.dart';
import 'package:auto_route_login/app/di/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
