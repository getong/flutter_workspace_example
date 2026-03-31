import 'package:flutter/material.dart';

import 'pages/key_demos/global_key_demo_page.dart';
import 'pages/key_demos/object_key_demo_page.dart';
import 'pages/key_demos/page_storage_key_demo_page.dart';
import 'pages/key_demos/unique_key_demo_page.dart';
import 'pages/key_demos/value_key_demo_page.dart';
import 'pages/listview_basics_page.dart';
import 'pages/listview_builder_page.dart';
import 'pages/listview_catalog.dart';
import 'pages/listview_detail_page.dart';
import 'pages/listview_home_page.dart';
import 'pages/listview_horizontal_page.dart';
import 'pages/listview_interactive_page.dart';
import 'pages/listview_separated_page.dart';
import 'pages/not_found_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String listViewBasics = '/listview_basics';
  static const String listViewBuilder = '/listview_builder';
  static const String listViewSeparated = '/listview_separated';
  static const String listViewHorizontal = '/listview_horizontal';
  static const String listViewInteractive = '/listview_interactive';
  static const String uniqueKeyDemo = '/key_demo_unique';
  static const String valueKeyDemo = '/key_demo_value';
  static const String objectKeyDemo = '/key_demo_object';
  static const String globalKeyDemo = '/key_demo_global';
  static const String pageStorageKeyDemo = '/key_demo_page_storage';
  static const String showcasePrefix = '/showcase';
}

Route<dynamic> onGenerateAppRoute(RouteSettings settings) {
  final String routeName = settings.name ?? AppRoutes.home;
  switch (routeName) {
    case AppRoutes.home:
      return _buildRoute(settings, const ListViewHomePage());
    case AppRoutes.listViewBasics:
      return _buildRoute(settings, const ListViewBasicsPage());
    case AppRoutes.listViewBuilder:
      return _buildRoute(settings, const ListViewBuilderPage());
    case AppRoutes.listViewSeparated:
      return _buildRoute(settings, const ListViewSeparatedPage());
    case AppRoutes.listViewHorizontal:
      return _buildRoute(settings, const ListViewHorizontalPage());
    case AppRoutes.listViewInteractive:
      return _buildRoute(settings, const ListViewInteractivePage());
    case AppRoutes.uniqueKeyDemo:
      return _buildRoute(settings, const UniqueKeyDemoPage());
    case AppRoutes.valueKeyDemo:
      return _buildRoute(settings, const ValueKeyDemoPage());
    case AppRoutes.objectKeyDemo:
      return _buildRoute(settings, const ObjectKeyDemoPage());
    case AppRoutes.globalKeyDemo:
      return _buildRoute(settings, const GlobalKeyDemoPage());
    case AppRoutes.pageStorageKeyDemo:
      return _buildRoute(settings, const PageStorageKeyDemoPage());
  }

  final Uri uri = Uri.parse(routeName);
  if (uri.pathSegments.length == 2 &&
      uri.pathSegments.first == AppRoutes.showcasePrefix.substring(1)) {
    final String slug = uri.pathSegments[1];
    final ListViewPageSpec? page = findListViewPage(slug);
    if (page == null) {
      return _buildRoute(settings, NotFoundPage(slug: slug));
    }
    return _buildRoute(settings, ListViewDetailPage(page: page));
  }

  return _buildRoute(settings, NotFoundPage(slug: routeName));
}

MaterialPageRoute<dynamic> _buildRoute(RouteSettings settings, Widget page) {
  return MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);
}
