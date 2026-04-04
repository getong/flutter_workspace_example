import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme.dart';

class AtriumBackground extends StatelessWidget {
  const AtriumBackground({
    super.key,
    required this.child,
    this.compact = false,
  });

  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final topSize = compact ? 220.0 : 320.0;
    final sideSize = compact ? 180.0 : 260.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFF), AtriumColors.background],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -20,
            child: _Aura(size: topSize, color: AtriumColors.primaryBright),
          ),
          Positioned(
            top: 120,
            left: -80,
            child: _Aura(
              size: sideSize,
              color: AtriumColors.surfaceHighest,
              opacity: 0.9,
            ),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: _Aura(
              size: sideSize,
              color: AtriumColors.tertiary,
              opacity: 0.18,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Aura extends StatelessWidget {
  const _Aura({required this.size, required this.color, this.opacity = 0.22});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: size / 1.8,
              spreadRadius: size / 9,
            ),
          ],
        ),
      ),
    );
  }
}

class WidthClamp extends StatelessWidget {
  const WidthClamp({super.key, required this.child, this.maxWidth = 520});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(32)),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.74),
            borderRadius: borderRadius,
            border: Border.all(
              color: AtriumColors.outline.withValues(alpha: 0.18),
            ),
            boxShadow: atriumShadow(opacity: 0.08),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: atriumPrimaryGradient(),
        borderRadius: BorderRadius.circular(24),
        boxShadow: atriumShadow(),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AtriumColors.onPrimary,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class AtriumBackButton extends StatelessWidget {
  const AtriumBackButton({
    super.key,
    required this.onPressed,
    this.iconColor = AtriumColors.onSurface,
  });

  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AtriumColors.surfaceRaised.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
            boxShadow: atriumShadow(opacity: 0.05),
          ),
          child: Icon(Icons.arrow_back_rounded, color: iconColor),
        ),
      ),
    );
  }
}

class AtriumTextField extends StatelessWidget {
  const AtriumTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.suffix,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(letterSpacing: 1.4),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AtriumColors.onSurfaceVariant),
            suffixIcon: suffix,
            filled: true,
            fillColor: AtriumColors.surfaceLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: AtriumColors.primary.withValues(alpha: 0.35),
                width: 2,
              ),
            ),
            hintStyle: const TextStyle(color: AtriumColors.outlineStrong),
          ),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}

class AvatarBubble extends StatelessWidget {
  const AvatarBubble({
    super.key,
    required this.initials,
    required this.accent,
    required this.fill,
    this.size = 56,
    this.isOnline = false,
    this.square = false,
    this.icon,
    this.withRing = false,
  });

  final String initials;
  final Color accent;
  final Color fill;
  final double size;
  final bool isOnline;
  final bool square;
  final IconData? icon;
  final bool withRing;

  @override
  Widget build(BuildContext context) {
    final radius = square ? 18.0 : size / 2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: size,
          height: size,
          padding: EdgeInsets.all(withRing ? 3 : 0),
          decoration: BoxDecoration(
            shape: square ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: square ? BorderRadius.circular(radius) : null,
            gradient: withRing
                ? LinearGradient(colors: [accent, AtriumColors.primaryBright])
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: fill,
              shape: square ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: square ? BorderRadius.circular(radius - 3) : null,
            ),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, color: accent, size: size * 0.42)
                : Text(
                    initials,
                    style: TextStyle(
                      color: AtriumColors.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: size * 0.28,
                    ),
                  ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: size * 0.22,
              height: size * 0.22,
              decoration: BoxDecoration(
                color: AtriumColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
              ),
            ),
          ),
      ],
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (label: 'Chats', icon: Icons.chat_bubble_rounded),
      (label: 'People', icon: Icons.group_rounded),
      (label: 'Profile', icon: Icons.person_rounded),
    ];
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const navHeight = 86.0;

    return SizedBox(
      height: navHeight + bottomInset,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: EdgeInsets.only(bottom: bottomInset),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.76),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: atriumShadow(opacity: 0.06),
            ),
            child: WidthClamp(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final active = index == currentIndex;

                    return Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => onTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: active
                                ? AtriumColors.surfaceHigh
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                size: 22,
                                color: active
                                    ? AtriumColors.primary
                                    : AtriumColors.onSurfaceVariant,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.label.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: active
                                          ? AtriumColors.primary
                                          : AtriumColors.onSurfaceVariant,
                                      letterSpacing: 0.7,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EntranceFader extends StatefulWidget {
  const EntranceFader({super.key, required this.child});

  final Widget child;

  @override
  State<EntranceFader> createState() => _EntranceFaderState();
}

class _EntranceFaderState extends State<EntranceFader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(_fade);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
