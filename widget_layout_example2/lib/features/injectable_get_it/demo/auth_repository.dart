abstract interface class AuthRepository {
  String get currentUsername;

  String get accessToken;

  DateTime get createdAt;
}
