import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_flow_result.dart';
import '../../domain/usecases/login_client_usecase.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

class LoginSuccess extends LoginState {
  final AuthFlowResult result;

  const LoginSuccess(this.result);
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);
}

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginClientUseCase _loginClientUseCase;

  LoginCubit(this._loginClientUseCase) : super(const LoginInitial());

  Future<void> submit({
    required String clientPublicKey,
    required String password,
  }) async {
    emit(const LoginSubmitting());

    try {
      final result = await _loginClientUseCase(
        clientPublicKey: clientPublicKey,
        password: password,
      );
      emit(LoginSuccess(result));
    } catch (error) {
      emit(LoginError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
