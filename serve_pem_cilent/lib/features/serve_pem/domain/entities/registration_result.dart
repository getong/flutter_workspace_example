class RegistrationResult {
  final String status;
  final String clientPublicKeySha256;
  final String passwordSha256;

  const RegistrationResult({
    required this.status,
    required this.clientPublicKeySha256,
    required this.passwordSha256,
  });
}
