import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/auto_route_demo_support.dart';
import 'package:widget_layout_example2/app_router.dart';
import 'package:widget_layout_example2/auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider<AppAuthBloc>.value(value: appAuthBloc, child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Widget Layout Example',
      localizationsDelegates: fluent.FluentLocalizations.localizationsDelegates,
      supportedLocales: fluent.FluentLocalizations.supportedLocales,
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
