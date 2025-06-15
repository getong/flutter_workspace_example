import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/basic_scaffold_page.dart';
import '../pages/row_column_page.dart';
import '../pages/popup_menu_page.dart';
import '../pages/tab_bar_page.dart';
import '../pages/stack_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.basicScaffold.path,
      builder: (context, state) => const BasicScaffoldPage(),
    ),
    GoRoute(
      path: AppRoutes.rowColumn.path,
      builder: (context, state) => const RowColumnPage(),
    ),
    GoRoute(
      path: AppRoutes.popupMenu.path,
      builder: (context, state) => const PopupMenuPage(),
    ),
    GoRoute(
      path: AppRoutes.tabBar.path,
      builder: (context, state) => const TabBarPage(),
    ),
    GoRoute(
      path: AppRoutes.stack.path,
      builder: (context, state) => const StackPage(),
    ),
  ],
);
