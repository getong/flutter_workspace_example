import 'package:auto_route_login/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signup({
    required String email,
    required String password,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/login',
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/signup',
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromJson(response.data ?? <String, dynamic>{});
  }
}
