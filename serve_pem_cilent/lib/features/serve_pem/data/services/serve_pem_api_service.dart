import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/serve_pem_dio_factory.dart';
import '../models/public_key_info_model.dart';
import '../models/registration_result_model.dart';
import 'registration_encryptor.dart';

class ServePemApiException implements Exception {
  final String message;
  final String? code;

  const ServePemApiException(this.message, {this.code});
}

@lazySingleton
class ServePemApiService {
  final Dio _dio;

  ServePemApiService() : _dio = createServePemDio();

  Future<PublicKeyInfoModel> fetchPublicKey() async {
    final response = await _dio.get<Map<String, dynamic>>('/public-key');
    final payload = _requirePayload(
      response,
      'Public key response is missing a JSON body.',
    );
    return PublicKeyInfoModel.fromJson(payload);
  }

  Future<RegistrationResultModel> register({
    required EncryptedAuthRequest encryptedRequest,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/register',
      data: encryptedRequest.toJson(),
    );
    final payload = _requirePayload(
      response,
      'Register response is missing a JSON body.',
    );
    return RegistrationResultModel.fromJson(payload);
  }

  Future<RegistrationResultModel> login({
    required EncryptedAuthRequest encryptedRequest,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/login',
      data: encryptedRequest.toJson(),
    );
    final payload = _requirePayload(
      response,
      'Login response is missing a JSON body.',
    );
    return RegistrationResultModel.fromJson(payload);
  }

  Map<String, dynamic> _requirePayload(
    Response<Map<String, dynamic>> response,
    String errorMessage,
  ) {
    if (response.statusCode != 200 || response.data == null) {
      throw ServePemApiException(errorMessage);
    }

    return response.data!;
  }
}
