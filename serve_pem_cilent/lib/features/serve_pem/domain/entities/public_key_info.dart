class PublicKeyInfo {
  final String transport;
  final String keyEncryptionAlgorithm;
  final String contentEncryptionAlgorithm;
  final String keyFormat;
  final String publicKeyPem;
  final String publicKeyDerBase64;
  final String sha256Hash;
  final int wrappedKeyBytes;
  final int nonceBytes;
  final int maxWrappedKeyPlaintextBytes;

  const PublicKeyInfo({
    required this.transport,
    required this.keyEncryptionAlgorithm,
    required this.contentEncryptionAlgorithm,
    required this.keyFormat,
    required this.publicKeyPem,
    required this.publicKeyDerBase64,
    required this.sha256Hash,
    required this.wrappedKeyBytes,
    required this.nonceBytes,
    required this.maxWrappedKeyPlaintextBytes,
  });
}
