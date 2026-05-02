import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.filledButton)
class FilledButtonPage extends StatelessWidget {
  const FilledButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FilledButton Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FilledButton is a Material 3 button for high-emphasis actions. It is useful when you want the primary action to stand out clearly.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _FilledButtonExampleCard(
              title: 'Primary Action',
              description:
                  'A standard FilledButton works well for the most important action on a screen.',
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Primary FilledButton pressed.'),
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: 16),
            _FilledButtonExampleCard(
              title: 'Icon Variant',
              description:
                  'FilledButton.icon combines an icon with text when the action benefits from extra visual context.',
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('FilledButton.icon pressed.')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Export Report'),
              ),
            ),
            const SizedBox(height: 16),
            _FilledButtonExampleCard(
              title: 'Custom Styling',
              description:
                  'You can customize size, shape, and color while keeping the FilledButton behavior.',
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Custom styled FilledButton pressed.'),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Publish Now'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _FilledButtonExampleCard extends StatelessWidget {
  const _FilledButtonExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
