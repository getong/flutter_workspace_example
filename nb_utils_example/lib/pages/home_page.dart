import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/demo_recipe.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<_RouteCardSpec> _routes = <_RouteCardSpec>[
    _RouteCardSpec(
      path: '/components',
      routeName: 'components',
      title: 'Components Gallery',
      subtitle: 'AppButton, HorizontalList, styles, and toast helpers.',
      icon: Icons.widgets_outlined,
    ),
    _RouteCardSpec(
      path: '/form-playground',
      routeName: 'form-playground',
      title: 'Form Playground',
      subtitle: 'AppTextField validation and action flows.',
      icon: Icons.edit_note_outlined,
    ),
    _RouteCardSpec(
      path: '/settings-lab',
      routeName: 'settings-lab',
      title: 'Settings Lab',
      subtitle: 'SettingSection and SettingItemWidget in a realistic page.',
      icon: Icons.tune_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('go_router + nb_utils')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _HeroCard(recipeCount: demoRecipes.length),
          24.height,
          Text('Static routes', style: boldTextStyle(size: 20)),
          8.height,
          Text(
            'This follows the same idea as the source project: an index page '
            'that links to several focused demos.',
            style: secondaryTextStyle(),
          ),
          12.height,
          ..._routes.map(
            (_RouteCardSpec route) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: SettingItemWidget(
                  title: route.title,
                  subTitle: route.subtitle,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      route.icon,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => context.go(route.path),
                ),
              ),
            ),
          ),
          16.height,
          Text('Dynamic recipe routes', style: boldTextStyle(size: 20)),
          8.height,
          Text(
            'Each recipe below resolves through `/recipes/:slug` using '
            '`GoRouterState.pathParameters`.',
            style: secondaryTextStyle(),
          ),
          12.height,
          ...demoRecipes.map(
            (DemoRecipe recipe) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: SettingItemWidget(
                  title: recipe.title,
                  subTitle: recipe.summary,
                  leading: CircleAvatar(
                    backgroundColor: recipe.accent.withValues(alpha: 0.14),
                    child: Icon(recipe.icon, color: recipe.accent),
                  ),
                  trailing: Text(
                    recipe.slug,
                    style: secondaryTextStyle(size: 12),
                  ),
                  onTap: () => context.goNamed(
                    'recipe',
                    pathParameters: <String, String>{'slug': recipe.slug},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.recipeCount});

  final int recipeCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Multi-page example',
            style: boldTextStyle(size: 28, color: Colors.white),
          ),
          10.height,
          Text(
            'A compact Flutter example that pairs `go_router` navigation with '
            '`nb_utils` widgets and extensions.',
            style: secondaryTextStyle(color: Colors.white70, size: 15),
          ),
          18.height,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _Badge(label: '3 static pages'),
              _Badge(label: '$recipeCount dynamic routes'),
              const _Badge(label: 'Material 3 theme'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(label, style: boldTextStyle(color: Colors.white, size: 13)),
    );
  }
}

class _RouteCardSpec {
  const _RouteCardSpec({
    required this.path,
    required this.routeName,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String path;
  final String routeName;
  final String title;
  final String subtitle;
  final IconData icon;
}
