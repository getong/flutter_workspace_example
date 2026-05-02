sealed class AppAuthState {
  const AppAuthState();

  bool get isAuthenticated;
}

final class AppAuthUnauthenticated extends AppAuthState {
  const AppAuthUnauthenticated();

  @override
  bool get isAuthenticated => false;
}

final class AppAuthAuthenticated extends AppAuthState {
  const AppAuthAuthenticated({required this.username});

  final String username;

  @override
  bool get isAuthenticated => true;
}
