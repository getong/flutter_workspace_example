import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:widget_layout_example2/features/auth/domain/entities/auth_user.dart';
import 'package:widget_layout_example2/features/auth/domain/repositories/auth_repository.dart';
import 'package:widget_layout_example2/features/auth/presentation/bloc/app_auth_event.dart';
import 'package:widget_layout_example2/features/auth/presentation/bloc/app_auth_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  AppAuthBloc({AuthRepository? authRepository})
    : _authRepository = authRepository ?? InMemoryAuthRepository(),
      super(const AppAuthUnauthenticated()) {
    on<AppAuthLoginRequested>(_onLoginRequested);
    on<AppAuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  void _onLoginRequested(
    AppAuthLoginRequested event,
    Emitter<AppAuthState> emit,
  ) {
    final AuthUser user = _authRepository.login(
      username: event.username,
      password: event.password,
    );
    emit(AppAuthAuthenticated(username: user.username));
  }

  void _onLogoutRequested(
    AppAuthLogoutRequested event,
    Emitter<AppAuthState> emit,
  ) {
    _authRepository.logout();
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
