import 'package:widget_layout_example2/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  AuthUser login({required String username, required String password});

  void logout();
}
