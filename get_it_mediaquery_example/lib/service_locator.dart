import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class ContextService {
  ThemeData? _themeData;
  MediaQueryData? _mediaQueryData;
  NavigatorState? _navigatorState;

  ThemeData get themeData => _themeData!;
  MediaQueryData get mediaQueryData => _mediaQueryData!;
  NavigatorState get navigatorState => _navigatorState!;

  void updateContextData(BuildContext context) {
    _themeData = Theme.of(context);
    _mediaQueryData = MediaQuery.of(context);
    _navigatorState = Navigator.of(context);
  }

  bool get hasData =>
      _themeData != null && _mediaQueryData != null && _navigatorState != null;
}

void setupServiceLocator() {
  getIt.registerSingleton<ContextService>(ContextService());
}
