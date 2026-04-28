import 'encrypted_auth_payload.dart';
import 'public_key_info.dart';
import 'registration_result.dart';

class AuthFlowResult {
  final RegistrationResult serverResult;
  final PublicKeyInfo publicKeyInfo;
  final EncryptedAuthPayload encryptedRequest;

  const AuthFlowResult({
    required this.serverResult,
    required this.publicKeyInfo,
    required this.encryptedRequest,
  });
}
