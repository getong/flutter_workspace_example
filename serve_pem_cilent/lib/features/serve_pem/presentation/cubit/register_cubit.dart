import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/registration_result.dart';
import '../../domain/usecases/register_client_usecase.dart';

sealed class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterSubmitting extends RegisterState {
  const RegisterSubmitting();
}

class RegisterSuccess extends RegisterState {
  final RegistrationResult result;

  const RegisterSuccess(this.result);
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);
}

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterClientUseCase _registerClientUseCase;

  RegisterCubit(this._registerClientUseCase) : super(const RegisterInitial());

  Future<void> submit({
    required String clientPublicKey,
    required String password,
  }) async {
    emit(const RegisterSubmitting());

    try {
      final result = await _registerClientUseCase(
        clientPublicKey: clientPublicKey,
        password: password,
      );
      emit(RegisterSuccess(result));
    } catch (error) {
      emit(RegisterError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
