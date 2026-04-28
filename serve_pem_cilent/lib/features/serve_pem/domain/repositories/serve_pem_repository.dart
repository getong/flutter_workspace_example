import '../entities/auth_flow_result.dart';
import '../entities/public_key_info.dart';

abstract interface class ServePemRepository {
  Future<PublicKeyInfo> getPublicKey();

  Future<AuthFlowResult> register({
    required String clientPublicKey,
    required String password,
  });

  Future<AuthFlowResult> login({
    required String clientPublicKey,
    required String password,
  });
}
