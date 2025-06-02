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

/// {@template settings_state}
/// State class for app settings.
/// {@endtemplate}
class SettingsState {
  const SettingsState({
    required this.fontSize,
    required this.enableAnimations,
    required this.language,
  });

  final double fontSize;
  final bool enableAnimations;
  final String language;

  SettingsState copyWith({
    double? fontSize,
    bool? enableAnimations,
    String? language,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      language: language ?? this.language,
    );
  }
}

/// {@template settings_cubit}
/// A cubit that manages app settings for MultiBlocProvider example.
/// {@endtemplate}
class SettingsCubit extends Cubit<SettingsState> {
  /// {@macro settings_cubit}
  SettingsCubit()
      : super(const SettingsState(
          fontSize: 16.0,
          enableAnimations: true,
          language: 'English',
        ));

  void updateFontSize(double size) {
    emit(state.copyWith(fontSize: size));
  }

  void toggleAnimations() {
    emit(state.copyWith(enableAnimations: !state.enableAnimations));
  }

  void changeLanguage(String language) {
    emit(state.copyWith(language: language));
  }
}
