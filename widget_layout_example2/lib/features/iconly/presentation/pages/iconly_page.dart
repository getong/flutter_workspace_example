import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.iconly)
class IconlyPage extends StatelessWidget {
  const IconlyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DeprecatedPackagePage(
      title: 'iconly Module',
      packageName: 'iconly',
    );
  }
}

class _DeprecatedPackagePage extends StatelessWidget {
  const _DeprecatedPackagePage({
    required this.title,
    required this.packageName,
  });

  final String title;
  final String packageName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.extension_off_outlined,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 20),
                Text(
                  'Module deprecated',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$packageName has been disabled for the Flutter 3.44.0 '
                  'upgrade. The route is kept as a placeholder so the app can '
                  'continue to build without the third_party override.',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
