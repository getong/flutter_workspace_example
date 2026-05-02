import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/auth/shared/bloc/app_auth_event.dart';
import 'package:widget_layout_example2/auth/shared/bloc/app_auth_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  AppAuthBloc() : super(const AppAuthUnauthenticated()) {
    on<AppAuthLoginRequested>(_onLoginRequested);
    on<AppAuthLogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(
    AppAuthLoginRequested event,
    Emitter<AppAuthState> emit,
  ) {
    final String username = event.username.trim();
    emit(AppAuthAuthenticated(username: username.isEmpty ? 'Guest' : username));
  }

  void _onLogoutRequested(
    AppAuthLogoutRequested event,
    Emitter<AppAuthState> emit,
  ) {
    emit(const AppAuthUnauthenticated());
  }
}

extension AppAuthStateX on AppAuthState {
  @visibleForTesting
  String? get usernameOrNull => switch (this) {
    AppAuthAuthenticated(:final String username) => username,
    AppAuthUnauthenticated() => null,
  };
}
