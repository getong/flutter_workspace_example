import 'package:auto_route_login/features/auth/domain/entities/user.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

/// Global singleton that holds the currently authenticated [User].
/// Null means the user is not authenticated.
@lazySingleton
class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(null);

  bool get isAuthenticated => state != null;

  void authenticate(User user) => emit(user);

  void logout() => emit(null);
}
