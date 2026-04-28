import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/public_key_info.dart';
import '../../domain/entities/registration_result.dart';
import '../../domain/repositories/serve_pem_repository.dart';
import '../services/registration_encryptor.dart';
import '../services/serve_pem_api_service.dart';

@LazySingleton(as: ServePemRepository)
class ServePemRepositoryImpl implements ServePemRepository {
  final ServePemApiService _apiService;
  final RegistrationEncryptor _encryptor;

  ServePemRepositoryImpl(this._apiService, this._encryptor);

  @override
  Future<PublicKeyInfo> getPublicKey() async {
    try {
      return await _apiService.fetchPublicKey();
    } on DioException catch (error) {
      throw Exception(
        _messageFromDioException(
          error,
          fallback: 'Unable to load the server public key.',
        ),
      );
    } on FormatException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<RegistrationResult> register({
    required String clientPublicKey,
    required String password,
  }) async {
    final publicKeyInfo = await getPublicKey();
    final ciphertextBase64 = _encryptor.encrypt(
      publicKeyPem: publicKeyInfo.publicKeyPem,
      maxPlaintextBytes: publicKeyInfo.maxPlaintextBytes,
      clientPublicKey: clientPublicKey,
      password: password,
    );

    try {
      return await _apiService.register(ciphertextBase64: ciphertextBase64);
    } on DioException catch (error) {
      throw Exception(
        _messageFromDioException(
          error,
          fallback: 'Unable to submit the encrypted registration.',
        ),
      );
    } on FormatException catch (error) {
      throw Exception(error.message);
    }
  }

  String _messageFromDioException(
    DioException error, {
    required String fallback,
  }) {
    final payload = error.response?.data;
    if (payload is Map<String, dynamic>) {
      final serverMessage = payload['error'];
      if (serverMessage is String && serverMessage.trim().isNotEmpty) {
        return serverMessage;
      }
    }

    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return '$fallback Server responded with status code $statusCode.';
    }

    return fallback;
  }
}
