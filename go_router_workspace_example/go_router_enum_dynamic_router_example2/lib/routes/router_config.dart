import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/user_detail_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/category_screen.dart';
import '../transitions/custom_transitions.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoute.profile.path,
      name: AppRoute.profile.name,
      pageBuilder: (context, state) => buildPageWithTransition(
        const ProfileScreen(),
        state,
        transitionBuilder: FadeTransitionBuilder(),
      ),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      name: AppRoute.settings.name,
      pageBuilder: (context, state) => buildPageWithTransition(
        const SettingsScreen(),
        state,
        transitionBuilder: SlideTransitionBuilder(),
      ),
    ),
    GoRoute(
      path: AppRoute.userDetail.path,
      name: AppRoute.userDetail.name,
      pageBuilder: (context, state) {
        final userId = state.pathParameters['id']!;
        return buildPageWithTransition(
          UserDetailScreen(userId: userId),
          state,
          transitionBuilder: ScaleTransitionBuilder(),
        );
      },
    ),
    GoRoute(
      path: AppRoute.productDetail.path,
      name: AppRoute.productDetail.name,
      pageBuilder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return buildPageWithTransition(
          ProductDetailScreen(productId: productId),
          state,
          transitionBuilder: RotationTransitionBuilder(),
        );
      },
    ),
    GoRoute(
      path: AppRoute.category.path,
      name: AppRoute.category.name,
      pageBuilder: (context, state) {
        final categoryName = state.pathParameters['categoryName']!;
        return buildPageWithTransition(
          CategoryScreen(categoryName: categoryName),
          state,
          transitionBuilder: SlideTransitionBuilder(),
        );
      },
    ),
  ],
);
