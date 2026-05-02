import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:widget_layout_example2/features/auto_route_demo/presentation/support/auto_route_demo_support.dart';
import 'package:widget_layout_example2/app_router.dart';
import 'package:widget_layout_example2/features/auth/auth.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

Future<void> main() async {
  // Initialize Marionette only in debug mode
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await _ensureExtendedImageCacheDirectory();
  await _initializeRiveNative();
  runApp(BlocProvider<AppAuthBloc>.value(value: appAuthBloc, child: MyApp()));
}

Future<void> _ensureExtendedImageCacheDirectory() async {
  if (kIsWeb) {
    return;
  }

  try {
    final Directory temporaryDirectory = await getTemporaryDirectory();

    // `extended_image_library` writes network cache files into
    // `<temporaryDirectory>/cacheimage`, but on macOS the parent cache path may
    // not exist yet. Creating it recursively avoids PathNotFoundException.
    await temporaryDirectory.create(recursive: true);
    await Directory(
      '${temporaryDirectory.path}${Platform.pathSeparator}cacheimage',
    ).create(recursive: true);
  } catch (error) {
    debugPrint('Failed to prepare extended_image cache directory: $error');
  }
}

Future<void> _initializeRiveNative() async {
  try {
    final bool initialized = await rive.RiveNative.init();
    if (!initialized) {
      debugPrint('RiveNative.init() returned false.');
    }
  } catch (error) {
    debugPrint('Failed to initialize RiveNative: $error');
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return Toast(
      navigatorKey: _appRouter.navigatorKey,
      child: MaterialApp.router(
        title: 'Widget Layout Example',
        localizationsDelegates:
            fluent.FluentLocalizations.localizationsDelegates,
        supportedLocales: fluent.FluentLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          extensions: const <ThemeExtension<dynamic>>[
            FlashToastTheme(),
            FlashBarTheme(),
          ],
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
      ),
    );
  }
}
