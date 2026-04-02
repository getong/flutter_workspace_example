import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class SemanticsPage extends StatelessWidget {
  const SemanticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semantics Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Semantics adds accessibility information for screen readers and assistive technologies. It helps describe purpose, state, and actions more clearly.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _SemanticsExampleCard(
              title: 'Labeled Icon',
              description:
                  'A visual icon can expose a clearer spoken label through Semantics.',
              child: Center(
                child: Semantics(
                  label: 'Favorite item',
                  hint: 'Marks this item as a favorite',
                  child: const Icon(
                    Icons.favorite,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SemanticsExampleCard(
              title: 'Button Role',
              description:
                  'Semantics can describe custom UI as a button even when the visual is not a Material button.',
              child: Semantics(
                button: true,
                label: 'Custom checkout button',
                hint: 'Double tap to continue to checkout',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Continue To Checkout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SemanticsExampleCard(
              title: 'Value And State',
              description:
                  'You can expose current values and toggled state for richer accessibility feedback.',
              child: Semantics(
                label: 'Volume control',
                value: '75 percent',
                increasedValue: '80 percent',
                decreasedValue: '70 percent',
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.volume_up, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.75,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '75%',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
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

class _SemanticsExampleCard extends StatelessWidget {
  const _SemanticsExampleCard({
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
