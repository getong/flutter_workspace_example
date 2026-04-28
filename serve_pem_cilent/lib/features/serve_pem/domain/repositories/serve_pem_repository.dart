import '../entities/public_key_info.dart';
import '../entities/registration_result.dart';

abstract interface class ServePemRepository {
  Future<PublicKeyInfo> getPublicKey();

  Future<RegistrationResult> register({
    required String clientPublicKey,
    required String password,
  });
}
