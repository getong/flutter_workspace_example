import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.state, required this.child, super.key});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= 920;
    final String activePath = _normalize(state.uri.path);
    final Color glow = Color.lerp(
      theme.colorScheme.primary,
      theme.colorScheme.background,
      0.82,
    )!;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[glow, theme.colorScheme.background],
          ),
        ),
        child: SafeArea(
          child: wide
              ? Row(
                  children: <Widget>[
                    SizedBox(
                      width: 280,
                      child: _Sidebar(activePath: activePath),
                    ),
                    Expanded(child: child),
                  ],
                )
              : Column(
                  children: <Widget>[
                    _TopNavigation(activePath: activePath),
                    Expanded(child: child),
                  ],
                ),
        ),
      ),
    );
  }

  String _normalize(String path) {
    if (path.startsWith('/layouts/')) {
      return '/examples';
    }
    return path;
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.activePath});

  final String activePath;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 8, 20),
      child: ShadCard(
        title: const Text('shadcn_ui example'),
        description: const Text(
          'A multi-page Flutter demo derived from flutter_row_example.',
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ShellDestination(
                path: '/',
                label: 'Home',
                icon: Icons.home_rounded,
                activePath: activePath,
              ),
              const SizedBox(height: 8),
              _ShellDestination(
                path: '/examples',
                label: 'Examples',
                icon: Icons.grid_view_rounded,
                activePath: activePath,
              ),
              const SizedBox(height: 8),
              _ShellDestination(
                path: '/settings',
                label: 'Settings',
                icon: Icons.tune_rounded,
                activePath: activePath,
              ),
              const SizedBox(height: 20),
              ShadSeparator.horizontal(),
              const SizedBox(height: 20),
              Text('Current', style: theme.textTheme.small),
              const SizedBox(height: 8),
              ShadBadge.outline(child: Text(activePath)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopNavigation extends StatelessWidget {
  const _TopNavigation({required this.activePath});

  final String activePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ShadCard(
        title: const Text('shadcn_ui example'),
        description: const Text('Shared shell powered by go_router.'),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _TopDestination(
                path: '/',
                label: 'Home',
                icon: Icons.home_rounded,
                activePath: activePath,
              ),
              _TopDestination(
                path: '/examples',
                label: 'Examples',
                icon: Icons.grid_view_rounded,
                activePath: activePath,
              ),
              _TopDestination(
                path: '/settings',
                label: 'Settings',
                icon: Icons.tune_rounded,
                activePath: activePath,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShellDestination extends StatelessWidget {
  const _ShellDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.activePath,
  });

  final String path;
  final String label;
  final IconData icon;
  final String activePath;

  @override
  Widget build(BuildContext context) {
    final bool selected = activePath == path;
    final Widget iconWidget = Icon(icon, size: 18);

    if (selected) {
      return ShadButton.secondary(
        width: double.infinity,
        mainAxisAlignment: MainAxisAlignment.start,
        leading: iconWidget,
        onPressed: () => context.go(path),
        child: Text(label),
      );
    }

    return ShadButton.ghost(
      width: double.infinity,
      mainAxisAlignment: MainAxisAlignment.start,
      leading: iconWidget,
      onPressed: () => context.go(path),
      child: Text(label),
    );
  }
}

class _TopDestination extends StatelessWidget {
  const _TopDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.activePath,
  });

  final String path;
  final String label;
  final IconData icon;
  final String activePath;

  @override
  Widget build(BuildContext context) {
    final bool selected = activePath == path;
    final Widget iconWidget = Icon(icon, size: 18);

    if (selected) {
      return ShadButton.secondary(
        leading: iconWidget,
        onPressed: () => context.go(path),
        child: Text(label),
      );
    }

    return ShadButton.ghost(
      leading: iconWidget,
      onPressed: () => context.go(path),
      child: Text(label),
    );
  }
}
