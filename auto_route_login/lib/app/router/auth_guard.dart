import 'package:auto_route/auto_route.dart';
import 'package:auto_route_login/app/router/app_router.dart';
import 'package:auto_route_login/features/auth/presentation/cubit/auth_cubit.dart';

/// Route guard that protects authenticated-only routes.
/// Redirects to [LoginRoute] when the user is not authenticated.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._authCubit);

  final AuthCubit _authCubit;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authCubit.isAuthenticated) {
      resolver.next();
    } else {
      router.replace(const LoginRoute());
      resolver.next(false);
    }
  }
}
