class PublicKeyInfo {
  final String algorithm;
  final String keyFormat;
  final String publicKeyPem;
  final String publicKeyDerBase64;
  final String sha256Hash;
  final int maxPlaintextBytes;

  const PublicKeyInfo({
    required this.algorithm,
    required this.keyFormat,
    required this.publicKeyPem,
    required this.publicKeyDerBase64,
    required this.sha256Hash,
    required this.maxPlaintextBytes,
  });
}
