import 'package:flutter/material.dart';

import 'models/demo_models.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'state/demo_app_controller.dart';
import 'theme/app_theme.dart';

class FigmaChatApp extends StatefulWidget {
  const FigmaChatApp({super.key});

  @override
  State<FigmaChatApp> createState() => _FigmaChatAppState();
}

class _FigmaChatAppState extends State<FigmaChatApp> {
  late final DemoAppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DemoAppController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScope(
      controller: _controller,
      child: MaterialApp(
        title: 'UI Design for User Features',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DemoScope.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final screen = switch (controller.screen) {
          AppScreen.login => const LoginScreen(key: ValueKey(AppScreen.login)),
          AppScreen.signup => const SignupScreen(
            key: ValueKey(AppScreen.signup),
          ),
          AppScreen.chat => const ChatScreen(key: ValueKey(AppScreen.chat)),
          AppScreen.profile => const ProfileScreen(
            key: ValueKey(AppScreen.profile),
          ),
        };

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0.02, 0.02),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnimation, child: child),
            );
          },
          child: screen,
        );
      },
    );
  }
}
