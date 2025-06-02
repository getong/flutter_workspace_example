import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationInitial()) {
    on<AuthenticationLoginRequested>(_onLoginRequested);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthenticationAuthenticated(username: event.username));
  }

  void _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationUnauthenticated());
  }
}
