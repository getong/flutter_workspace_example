import 'package:injectable/injectable.dart';

import '../entities/auth_flow_result.dart';
import '../repositories/serve_pem_repository.dart';

@injectable
class LoginClientUseCase {
  final ServePemRepository _repository;

  LoginClientUseCase(this._repository);

  Future<AuthFlowResult> call({
    required String clientPublicKey,
    required String password,
  }) {
    return _repository.login(
      clientPublicKey: clientPublicKey,
      password: password,
    );
  }
}
