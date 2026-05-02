import 'package:auto_route_login/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auto_route_login/features/auth/domain/entities/user.dart';
import 'package:auto_route_login/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({required String email, required String password}) {
    return _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<User> signup({required String email, required String password}) {
    return _remoteDataSource.signup(email: email, password: password);
  }
}
