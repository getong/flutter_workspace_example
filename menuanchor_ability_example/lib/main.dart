import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuAnchor Push/Pop Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationDemoPage(level: 1);
  }
}

class NavigationDemoPage extends StatelessWidget {
  const NavigationDemoPage({super.key, required this.level});

  final int level;

  void _pushNextPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NavigationDemoPage(level: level + 1),
      ),
    );
  }

  void _popCurrentPage(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Already at root page, cannot pop.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MenuAnchor Page $level'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => _pushNextPage(context),
                  leadingIcon: const Icon(Icons.open_in_new),
                  child: const Text('Push next page'),
                ),
                MenuItemButton(
                  onPressed: () => _popCurrentPage(context),
                  leadingIcon: const Icon(Icons.arrow_back),
                  child: const Text('Pop current page'),
                ),
              ],
              builder:
                  (
                    BuildContext context,
                    MenuController controller,
                    Widget? child,
                  ) {
                    return IconButton(
                      key: ValueKey<String>('menu_button_$level'),
                      tooltip: 'Open menu',
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                    );
                  },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current page level: $level',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              const Text(
                'Use the top-right MenuAnchor to push a new page or pop the current page.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _pushNextPage(context),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Push from button'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _popCurrentPage(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Pop from button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
