import 'dart:convert';

class EncryptedAuthPayload {
  final String wrappedKeyBase64;
  final String nonceBase64;
  final String ciphertextBase64;

  const EncryptedAuthPayload({
    required this.wrappedKeyBase64,
    required this.nonceBase64,
    required this.ciphertextBase64,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wrapped_key_base64': wrappedKeyBase64,
    'nonce_base64': nonceBase64,
    'ciphertext_base64': ciphertextBase64,
  };

  int get wrappedKeyBytes => base64Decode(wrappedKeyBase64).length;

  int get nonceBytes => base64Decode(nonceBase64).length;

  int get ciphertextBytes => base64Decode(ciphertextBase64).length;

  String toPrettyJson() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}
