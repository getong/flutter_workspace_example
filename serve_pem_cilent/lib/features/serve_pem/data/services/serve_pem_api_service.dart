import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/serve_pem_dio_factory.dart';
import '../models/public_key_info_model.dart';
import '../models/registration_result_model.dart';

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
    required String ciphertextBase64,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/register',
      data: <String, dynamic>{'ciphertext_base64': ciphertextBase64},
    );
    final payload = _requirePayload(
      response,
      'Register response is missing a JSON body.',
    );
    return RegistrationResultModel.fromJson(payload);
  }

  Map<String, dynamic> _requirePayload(
    Response<Map<String, dynamic>> response,
    String errorMessage,
  ) {
    if (response.statusCode != 200 || response.data == null) {
      throw Exception(errorMessage);
    }

    return response.data!;
  }
}
