import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/travel_app.dart';
import 'app/state/travel_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(TravelApp(store: TravelStore(preferences)));
}
