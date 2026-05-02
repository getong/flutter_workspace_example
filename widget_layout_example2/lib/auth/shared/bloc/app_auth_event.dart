sealed class AppAuthEvent {
  const AppAuthEvent();
}

final class AppAuthLoginRequested extends AppAuthEvent {
  const AppAuthLoginRequested({required this.username, required this.password});

  final String username;
  final String password;
}

final class AppAuthLogoutRequested extends AppAuthEvent {
  const AppAuthLogoutRequested();
}
