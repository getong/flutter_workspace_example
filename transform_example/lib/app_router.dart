import 'package:flutter/material.dart';

import 'pages/not_found_page.dart';
import 'pages/transform_catalog.dart';
import 'pages/transform_detail_page.dart';
import 'pages/transform_home_page.dart';

const AppRouter appRouter = AppRouter();

class AppRouter {
  const AppRouter();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '/';

    if (routeName == '/') {
      return MaterialPageRoute<void>(
        builder: (BuildContext context) => const TransformHomePage(),
        settings: settings,
      );
    }

    if (routeName.startsWith('/transforms/')) {
      final String slug = routeName.substring('/transforms/'.length);
      final TransformPageSpec? page = findTransformPage(slug);
      if (page == null) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => NotFoundPage(slug: slug),
          settings: settings,
        );
      }
      return MaterialPageRoute<void>(
        builder: (BuildContext context) => TransformDetailPage(page: page),
        settings: settings,
      );
    }

    return MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          NotFoundPage(slug: routeName.replaceAll('/', '')),
      settings: settings,
    );
  }
}
