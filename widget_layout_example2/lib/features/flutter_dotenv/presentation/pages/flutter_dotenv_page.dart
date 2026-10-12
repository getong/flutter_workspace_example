import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.flutterDotenv)
class FlutterDotenvPage extends StatelessWidget {
  const FlutterDotenvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_dotenv · Deprecated')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'This module has been retired',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'flutter_dotenv parses a bundled .env asset at runtime. The '
            'project now uses envied, which generates typed fields from .env '
            'files at build time.',
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_suggest_outlined),
              title: const Text('envied'),
              subtitle: const Text(
                'Typed, compile-time checked configuration with flavors, '
                'inheritance and optional obfuscation.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.router.pushPath(AppRoute.envied.path),
            ),
          ),
        ],
      ),
    );
  }
}
