import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import 'models/demo_recipe.dart';
import 'pages/components_page.dart';
import 'pages/form_playground_page.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'pages/recipe_detail_page.dart';
import 'pages/settings_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  errorBuilder: (BuildContext context, GoRouterState state) {
    return NotFoundPage(location: state.uri.toString());
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/components',
      name: 'components',
      builder: (BuildContext context, GoRouterState state) {
        return const ComponentsPage();
      },
    ),
    GoRoute(
      path: '/form-playground',
      name: 'form-playground',
      builder: (BuildContext context, GoRouterState state) {
        return const FormPlaygroundPage();
      },
    ),
    GoRoute(
      path: '/settings-lab',
      name: 'settings-lab',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
    GoRoute(
      path: '/recipes/:slug',
      name: 'recipe',
      builder: (BuildContext context, GoRouterState state) {
        final String slug = state.pathParameters['slug']!;
        final DemoRecipe? recipe = findDemoRecipe(slug);

        if (recipe == null) {
          return NotFoundPage(location: state.uri.toString());
        }

        return RecipeDetailPage(recipe: recipe);
      },
    ),
  ],
);
