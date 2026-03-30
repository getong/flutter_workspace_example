import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:forui/forui.dart';

import 'app_router.dart';

void main() {
  runApp(const ForuiRouterExampleApp());
}

class ForuiRouterExampleApp extends StatelessWidget {
  const ForuiRouterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = defaultTargetPlatform;
    final FPlatformVariant adaptivePlatform =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android
        ? FPlatformVariant.iOS
        : FPlatformVariant.macOS;
    final FThemeData theme = adaptivePlatform.desktop
        ? FThemes.zinc.light.desktop
        : FThemes.zinc.light.touch;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      routerConfig: appRouter,
      theme: theme.toApproximateMaterialTheme(),
      builder: (BuildContext context, Widget? child) {
        return FTheme(
          data: theme,
          platform: adaptivePlatform,
          child: FToaster(
            child: FTooltipGroup(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}
