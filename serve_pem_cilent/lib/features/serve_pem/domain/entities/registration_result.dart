class RegistrationResult {
  final String status;
  final int userId;
  final String clientPublicKeySha256;

  const RegistrationResult({
    required this.status,
    required this.userId,
    required this.clientPublicKeySha256,
  });
}
