import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DemoPageScaffold extends StatelessWidget {
  const DemoPageScaffold({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Home'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              accent.withValues(alpha: 0.08),
              const Color(0xFFF7F2EA),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _PageHero(title: title, subtitle: subtitle, accent: accent),
                    const SizedBox(height: 24),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DemoSection extends StatelessWidget {
  const DemoSection({
    required this.title,
    required this.child,
    this.description,
    super.key,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(description!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(padding: const EdgeInsets.all(18), child: child),
          ),
        ],
      ),
    );
  }
}

class _PageHero extends StatelessWidget {
  const _PageHero({
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: <Color>[
            accent.withValues(alpha: 0.95),
            accent.withValues(alpha: 0.65),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}
