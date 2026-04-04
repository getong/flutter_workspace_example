import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../router/app_router.dart';
import '../theme.dart';
import '../widgets/common.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _agreeToTerms = true;
  bool _obscurePassword = true;

  void _finishSignUp() {
    context.router.replaceAll([const HomeShellRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AtriumBackground(
        compact: true,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: WidthClamp(
                  maxWidth: 430,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.maybePop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const Expanded(
                        child: Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AtriumColors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: WidthClamp(
                    maxWidth: 430,
                    child: EntranceFader(
                      child: Column(
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: atriumPrimaryGradient(),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: atriumShadow(),
                            ),
                            child: Transform.rotate(
                              angle: 0.18,
                              child: const Icon(
                                Icons.bubble_chart_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Create Account',
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join our community today',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 28),
                          GlassPanel(
                            child: Column(
                              children: [
                                const AtriumTextField(
                                  label: 'Full Name',
                                  hint: 'John Doe',
                                  icon: Icons.person_rounded,
                                ),
                                const SizedBox(height: 18),
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
                                const SizedBox(height: 18),
                                const AtriumTextField(
                                  label: 'Confirm Password',
                                  hint: '••••••••',
                                  icon: Icons.lock_reset_rounded,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _agreeToTerms,
                                      onChanged: (value) {
                                        setState(() {
                                          _agreeToTerms = value ?? false;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Text.rich(
                                          TextSpan(
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                            children: const [
                                              TextSpan(text: 'I agree to the '),
                                              TextSpan(
                                                text: 'Terms and Conditions',
                                                style: TextStyle(
                                                  color: AtriumColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' and Privacy Policy.',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                PrimaryGradientButton(
                                  label: 'Sign Up',
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: _finishSignUp,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () => context.maybePop(),
                                    child: const Text(
                                      'Log In',
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
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AtriumColors.outline.withValues(
                                    alpha: 0.24,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'OR JOIN WITH',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AtriumColors.outline.withValues(
                                    alpha: 0.24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              _RoundJoinButton(
                                icon: Icons.mail_rounded,
                                label: 'Google',
                              ),
                              SizedBox(width: 18),
                              _RoundJoinButton(
                                icon: Icons.apple_rounded,
                                label: 'Apple',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: WidthClamp(
          maxWidth: 430,
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            borderRadius: BorderRadius.circular(28),
            child: Row(
              children: [
                Expanded(
                  child: _AuthModeChip(
                    label: 'Sign Up',
                    icon: Icons.person_add_alt_1_rounded,
                    active: true,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _AuthModeChip(
                    label: 'Login',
                    icon: Icons.login_rounded,
                    active: false,
                    onTap: () => context.maybePop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundJoinButton extends StatelessWidget {
  const _RoundJoinButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: atriumShadow(opacity: 0.06),
        ),
        child: Icon(icon, color: AtriumColors.onSurface, size: 26),
      ),
    );
  }
}

class _AuthModeChip extends StatelessWidget {
  const _AuthModeChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AtriumColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active
                  ? AtriumColors.primary
                  : AtriumColors.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: active
                    ? AtriumColors.primary
                    : AtriumColors.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
