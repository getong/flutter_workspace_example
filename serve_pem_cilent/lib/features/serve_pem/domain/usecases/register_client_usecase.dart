import 'package:injectable/injectable.dart';

import '../entities/registration_result.dart';
import '../repositories/serve_pem_repository.dart';

@injectable
class RegisterClientUseCase {
  final ServePemRepository _repository;

  RegisterClientUseCase(this._repository);

  Future<RegistrationResult> call({
    required String clientPublicKey,
    required String password,
  }) {
    return _repository.register(
      clientPublicKey: clientPublicKey,
      password: password,
    );
  }
}
