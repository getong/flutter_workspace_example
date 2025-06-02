// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'app.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}

// copy from https://pub.dev/packages/flutter_bloc/example
