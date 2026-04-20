import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/auth/bloc/app_auth_bloc.dart';
import 'package:widget_layout_example2/auth/bloc/app_auth_event.dart';
import 'package:widget_layout_example2/auth/bloc/app_auth_state.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onResult});

  final void Function(bool didLogin)? onResult;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AppAuthBloc>().add(
      AppAuthLoginRequested(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _handleAuthenticated(BuildContext context) {
    widget.onResult?.call(true);
    context.router.replaceAll(<PageRouteInfo<void>>[AppRouteTarget.home.route]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listenWhen: (AppAuthState previous, AppAuthState current) =>
          !previous.isAuthenticated && current.isAuthenticated,
      listener: (BuildContext context, AppAuthState state) {
        _handleAuthenticated(context);
      },
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter any username and password to continue to the homepage.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(onPressed: _submit, child: const Text('Log In')),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.router.push(AppRouteTarget.signUp.route),
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Go To Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
