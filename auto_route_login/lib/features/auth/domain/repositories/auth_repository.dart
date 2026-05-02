import 'package:auto_route_login/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> signup({
    required String email,
    required String password,
  });
}
