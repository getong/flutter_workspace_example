import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/auto_route_demo_support.dart';
import 'package:widget_layout_example2/app_router.dart';
import 'package:widget_layout_example2/video_runtime/flutter_video_caching_fvp_runtime.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureFlutterVideoCachingAndFvp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Widget Layout Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: _appRouter.config(
        includePrefixMatches: true,
        deepLinkTransformer: DeepLink.prefixStripper('demo'),
        deepLinkBuilder: (PlatformDeepLink deepLink) {
          if (deepLink.path.startsWith('/blocked')) {
            demoNavigationLog.add(
              'deepLinkBuilder rerouted ${deepLink.path} -> /auto-route-page',
            );
            return DeepLink.path('/auto-route-page');
          }
          return deepLink;
        },
        reevaluateListenable: demoAuthController,
        navigatorObservers: () => <NavigatorObserver>[
          DemoAutoRouterObserver(demoNavigationLog),
          AutoRouteObserver(),
        ],
      ),
    );
  }
}
