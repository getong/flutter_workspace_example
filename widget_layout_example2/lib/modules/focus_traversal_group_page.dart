import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'FocusTraversalGroupRoute')
class FocusTraversalGroupPage extends StatelessWidget {
  const FocusTraversalGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusTraversalGroup Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FocusTraversalGroup defines a focus boundary and traversal policy for a subtree. It is useful when tab order should be intentional inside forms, toolbars, dialogs, or keyboard-first interfaces.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _TraversalExampleCard(
              title: 'Ordered Action Grid',
              description:
                  'The visual layout is two columns, but NumericFocusOrder defines the tab sequence explicitly from 1 to 4.',
              api:
                  'Uses: FocusTraversalGroup + OrderedTraversalPolicy + NumericFocusOrder',
              child: _OrderedActionGrid(),
            ),
            const SizedBox(height: 16),
            const _TraversalExampleCard(
              title: 'Form Sections As Boundaries',
              description:
                  'Separate traversal groups help large forms feel predictable by keeping each section locally ordered.',
              api: 'Uses: multiple FocusTraversalGroup widgets in one page',
              child: _GroupedFormPreview(),
            ),
            const SizedBox(height: 16),
            const _TraversalExampleCard(
              title: 'Dialog Footer Order',
              description:
                  'Dialog actions can keep keyboard focus on the intended primary path even when the visual placement is different.',
              api: 'Uses: FocusTraversalOrder around buttons',
              child: _DialogActionPreview(),
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

class _OrderedActionGrid extends StatelessWidget {
  const _OrderedActionGrid();

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: const <Widget>[
          FocusTraversalOrder(
            order: NumericFocusOrder(1),
            child: SizedBox(
              width: 150,
              child: FilledButton(onPressed: null, child: Text('1. Review')),
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(3),
            child: SizedBox(
              width: 150,
              child: OutlinedButton(onPressed: null, child: Text('3. Assign')),
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(2),
            child: SizedBox(
              width: 150,
              child: FilledButton(onPressed: null, child: Text('2. Approve')),
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(4),
            child: SizedBox(
              width: 150,
              child: OutlinedButton(onPressed: null, child: Text('4. Export')),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupedFormPreview extends StatelessWidget {
  const _GroupedFormPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Shipping',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 12),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(2),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Payment',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 12),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Card number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(2),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Name on card',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogActionPreview extends StatelessWidget {
  const _DialogActionPreview();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Archive 24 completed tasks?',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Keyboard traversal can move to the safest action first, then the primary action, and finally the destructive action.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: const <Widget>[
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1),
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text('Review'),
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(2),
                    child: FilledButton(
                      onPressed: null,
                      child: Text('Archive'),
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(3),
                    child: TextButton(
                      onPressed: null,
                      child: Text('Delete Instead'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TraversalExampleCard extends StatelessWidget {
  const _TraversalExampleCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
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
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
