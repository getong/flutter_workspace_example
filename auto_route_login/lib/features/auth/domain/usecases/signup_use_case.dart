import 'package:auto_route_login/features/auth/domain/entities/user.dart';
import 'package:auto_route_login/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
  }) {
    return _repository.signup(email: email, password: password);
  }
}
