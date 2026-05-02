part of 'auth_form_bloc.dart';

enum AuthFormStatus { initial, loading, success, failure }

class AuthFormState extends Equatable {
  const AuthFormState({
    this.status = AuthFormStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthFormStatus status;
  final User? user;
  final String? errorMessage;

  AuthFormState copyWith({
    AuthFormStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthFormState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, user, errorMessage];
}
