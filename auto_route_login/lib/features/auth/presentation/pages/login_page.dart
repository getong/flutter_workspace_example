import 'package:auto_route/auto_route.dart';
import 'package:auto_route_login/app/di/injection.dart';
import 'package:auto_route_login/app/router/app_router.dart';
import 'package:auto_route_login/features/auth/presentation/bloc/auth_form_bloc.dart';
import 'package:auto_route_login/features/auth/presentation/widgets/auth_form.dart';
import 'package:auto_route_login/features/auth/presentation/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthFormBloc>(
      create: (_) => getIt<AuthFormBloc>(),
      child: BlocConsumer<AuthFormBloc, AuthFormState>(
        listener: (context, state) {
          if (state.status == AuthFormStatus.success && state.user != null) {
            context.router.replace(HomeRoute(user: state.user!));
          }

          if (state.status == AuthFormStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return AuthShell(
            title: 'Welcome back',
            subtitle: 'Login with the demo account to enter the app.',
            child: AuthForm(
              submitLabel: 'Login',
              helperText: 'Demo account: demo@demo.com / any password >= 6 chars',
              loading: state.status == AuthFormStatus.loading,
              onSubmit: (email, password) async {
                context.read<AuthFormBloc>().add(
                      LoginSubmitted(email: email, password: password),
                    );
              },
              footer: Align(
                child: TextButton(
                  onPressed: () => context.router.push(const SignupRoute()),
                  child: const Text('Need an account? Sign up'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
