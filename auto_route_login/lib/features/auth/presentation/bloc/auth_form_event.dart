part of 'auth_form_bloc.dart';

sealed class AuthFormEvent extends Equatable {
  const AuthFormEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginSubmitted extends AuthFormEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}

class SignupSubmitted extends AuthFormEvent {
  const SignupSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}
