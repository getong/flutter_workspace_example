import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template theme_state}
/// State class that holds theme information for BlocSelector examples.
/// {@endtemplate}
class ThemeState {
  const ThemeState({
    required this.themeData,
    required this.isDark,
    required this.toggleCount,
  });

  final ThemeData themeData;
  final bool isDark;
  final int toggleCount;

  ThemeState copyWith({
    ThemeData? themeData,
    bool? isDark,
    int? toggleCount,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      isDark: isDark ?? this.isDark,
      toggleCount: toggleCount ?? this.toggleCount,
    );
  }
}

/// {@template brightness_cubit}
/// A simple [Cubit] that manages the [ThemeState] as its state.
/// Demonstrates BlocSelector usage with specific state properties.
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeState> {
  /// {@macro brightness_cubit}
  ThemeCubit()
      : super(ThemeState(
          themeData: _lightTheme,
          isDark: false,
          toggleCount: 0,
        ));

  static final _lightTheme = ThemeData.light();
  static final _darkTheme = ThemeData.dark();

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    final newIsDark = !state.isDark;
    emit(state.copyWith(
      themeData: newIsDark ? _darkTheme : _lightTheme,
      isDark: newIsDark,
      toggleCount: state.toggleCount + 1,
    ));
  }
}
