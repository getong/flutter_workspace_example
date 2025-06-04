import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template settings_state}
/// State for app settings
/// {@endtemplate}
class SettingsState {
  const SettingsState({
    this.fontSize = 16.0,
    this.enableAnimations = true,
    this.language = 'English',
    this.notificationsEnabled = true,
    this.soundEnabled = true,
  });

  final double fontSize;
  final bool enableAnimations;
  final String language;
  final bool notificationsEnabled;
  final bool soundEnabled;

  SettingsState copyWith({
    double? fontSize,
    bool? enableAnimations,
    String? language,
    bool? notificationsEnabled,
    bool? soundEnabled,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

/// {@template settings_cubit}
/// Cubit for managing app settings
/// {@endtemplate}
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void updateFontSize(double fontSize) {
    emit(state.copyWith(fontSize: fontSize));
  }

  void toggleAnimations() {
    emit(state.copyWith(enableAnimations: !state.enableAnimations));
  }

  void changeLanguage(String language) {
    emit(state.copyWith(language: language));
  }

  void toggleNotifications() {
    emit(state.copyWith(notificationsEnabled: !state.notificationsEnabled));
  }

  void toggleSound() {
    emit(state.copyWith(soundEnabled: !state.soundEnabled));
  }
}
