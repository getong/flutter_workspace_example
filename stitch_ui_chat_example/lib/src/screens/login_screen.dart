import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../router/app_router.dart';
import '../theme.dart';
import '../widgets/common.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _openHome() {
    context.router.replaceAll([const HomeShellRoute()]);
  }

  void _openSignUp() {
    context.router.push(const SignUpRoute());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AtriumBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: WidthClamp(
                maxWidth: 430,
                child: EntranceFader(
                  child: Column(
                    children: [
                      GlassPanel(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () => context.maybePop(),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor:
                                      AtriumColors.onSurfaceVariant,
                                ),
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: atriumPrimaryGradient(),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: atriumShadow(),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'Welcome Back',
                              style: textTheme.displaySmall?.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please enter your details to sign in',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: AtriumColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _SocialButton(
                              icon: Icons.mail_rounded,
                              label: 'Continue with Google',
                              onPressed: _openHome,
                            ),
                            const SizedBox(height: 14),
                            _SocialButton(
                              icon: Icons.facebook_rounded,
                              label: 'Continue with Facebook',
                              onPressed: _openHome,
                              filled: true,
                            ),
                            const SizedBox(height: 26),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AtriumColors.outline.withValues(
                                      alpha: 0.28,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AtriumColors.outline.withValues(
                                      alpha: 0.28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            const AtriumTextField(
                              label: 'Email Address',
                              hint: 'name@example.com',
                              icon: Icons.mail_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            AtriumTextField(
                              label: 'Password',
                              hint: '••••••••',
                              icon: Icons.lock_rounded,
                              obscureText: _obscurePassword,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AtriumColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Forgot?'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            PrimaryGradientButton(
                              label: 'Sign In',
                              onPressed: _openHome,
                            ),
                            const SizedBox(height: 24),
                            Text.rich(
                              TextSpan(
                                style: textTheme.bodyMedium,
                                children: [
                                  const TextSpan(
                                    text: 'Don\'t have an account? ',
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: _openSignUp,
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: AtriumColors.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Wrap(
                        spacing: 22,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: const [
                          _HintChip(
                            icon: Icons.security_rounded,
                            label: 'SECURE ACCESS',
                          ),
                          _HintChip(
                            icon: Icons.language_rounded,
                            label: 'ENGLISH (US)',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final background = filled
        ? atriumPrimaryGradient()
        : const LinearGradient(colors: [Colors.white, Colors.white]);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: background,
        borderRadius: BorderRadius.circular(18),
        border: filled
            ? null
            : Border.all(color: AtriumColors.outline.withValues(alpha: 0.16)),
        boxShadow: filled ? atriumShadow(opacity: 0.08) : null,
      ),
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(58),
          foregroundColor: filled ? Colors.white : AtriumColors.onSurface,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AtriumColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AtriumColors.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
