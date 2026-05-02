import 'package:auto_route_login/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:auto_route_login/features/auth/domain/entities/user.dart';
import 'package:auto_route_login/features/auth/domain/usecases/login_use_case.dart';
import 'package:auto_route_login/features/auth/domain/usecases/signup_use_case.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

@injectable
class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc(this._loginUseCase, this._signupUseCase, this._authCubit)
    : super(const AuthFormState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final AuthCubit _authCubit;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthFormState> emit,
  ) async {
    emit(const AuthFormState(status: AuthFormStatus.loading));
    try {
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      _authCubit.authenticate(user);
      emit(AuthFormState(status: AuthFormStatus.success, user: user));
    } on DioException catch (error) {
      emit(
        AuthFormState(
          status: AuthFormStatus.failure,
          errorMessage: _resolveDioMessage(error),
        ),
      );
    } catch (_) {
      emit(
        const AuthFormState(
          status: AuthFormStatus.failure,
          errorMessage: 'Unexpected error. Please try again.',
        ),
      );
    }
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<AuthFormState> emit,
  ) async {
    emit(const AuthFormState(status: AuthFormStatus.loading));
    try {
      final user = await _signupUseCase(
        email: event.email,
        password: event.password,
      );
      _authCubit.authenticate(user);
      emit(AuthFormState(status: AuthFormStatus.success, user: user));
    } on DioException catch (error) {
      emit(
        AuthFormState(
          status: AuthFormStatus.failure,
          errorMessage: _resolveDioMessage(error),
        ),
      );
    } catch (_) {
      emit(
        const AuthFormState(
          status: AuthFormStatus.failure,
          errorMessage: 'Unexpected error. Please try again.',
        ),
      );
    }
  }

  String _resolveDioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return 'Request failed. Please try again.';
  }
}
