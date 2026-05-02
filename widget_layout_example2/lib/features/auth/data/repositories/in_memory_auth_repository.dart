import 'package:widget_layout_example2/features/auth/domain/entities/auth_user.dart';
import 'package:widget_layout_example2/features/auth/domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  AuthUser? _currentUser;

  @override
  AuthUser login({required String username, required String password}) {
    final String sanitizedUsername = username.trim();
    final AuthUser user = AuthUser(
      username: sanitizedUsername.isEmpty ? 'Guest' : sanitizedUsername,
    );
    _currentUser = user;
    return user;
  }

  @override
  void logout() {
    _currentUser = null;
  }
}
