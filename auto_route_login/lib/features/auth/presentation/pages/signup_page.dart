import 'package:auto_route/auto_route.dart';
import 'package:auto_route_login/app/di/injection.dart';
import 'package:auto_route_login/app/router/app_router.dart';
import 'package:auto_route_login/features/auth/presentation/bloc/auth_form_bloc.dart';
import 'package:auto_route_login/features/auth/presentation/widgets/auth_form.dart';
import 'package:auto_route_login/features/auth/presentation/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthFormBloc>(
      create: (_) => getIt<AuthFormBloc>(),
      child: BlocConsumer<AuthFormBloc, AuthFormState>(
        listener: (context, state) {
          if (state.status == AuthFormStatus.success) {
            context.router.pushAndPopUntil(
              const HomeRoute(),
              predicate: (_) => false,
            );
          }

          if (state.status == AuthFormStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return AuthShell(
            title: 'Create account',
            subtitle: 'Sign up through the mocked Dio API, then land on home.',
            child: AuthForm(
              submitLabel: 'Sign up',
              loading: state.status == AuthFormStatus.loading,
              onSubmit: (email, password) async {
                context.read<AuthFormBloc>().add(
                  SignupSubmitted(email: email, password: password),
                );
              },
              footer: Align(
                child: TextButton(
                  onPressed: () =>
                      context.router.popUntilRouteWithName(LoginRoute.name),
                  child: const Text('Already have an account? Login'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
