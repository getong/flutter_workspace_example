class WebcryptoDemoResult {
  const WebcryptoDemoResult({
    required this.randomBytesBase64,
    required this.sha256Base64,
    required this.hmacKeyBase64,
    required this.hmacSignatureBase64,
    required this.hmacVerified,
    required this.aesKeyBase64,
    required this.ivBase64,
    required this.ciphertextBase64,
    required this.decryptedText,
    required this.additionalData,
    required this.plaintext,
  });

  final String randomBytesBase64;
  final String sha256Base64;
  final String hmacKeyBase64;
  final String hmacSignatureBase64;
  final bool hmacVerified;
  final String aesKeyBase64;
  final String ivBase64;
  final String ciphertextBase64;
  final String decryptedText;
  final String additionalData;
  final String plaintext;
}
