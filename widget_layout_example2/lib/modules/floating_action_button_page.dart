import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FloatingActionButtonExamplePage extends StatefulWidget {
  const FloatingActionButtonExamplePage({super.key});

  @override
  State<FloatingActionButtonExamplePage> createState() =>
      _FloatingActionButtonExamplePageState();
}

class _FloatingActionButtonExamplePageState
    extends State<FloatingActionButtonExamplePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FloatingActionButton Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
          children: <Widget>[
            const Text(
              'FloatingActionButton highlights a primary screen action such as create, add, compose, or capture.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Live example',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Counter: $_count'),
                    const SizedBox(height: 16),
                    const Text(
                      'Tap the orange floating action button on this page to increment the counter.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Common variants',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: null,
                          heroTag: 'mini-disabled',
                          mini: true,
                          child: Icon(Icons.edit),
                        ),
                        FloatingActionButton.small(
                          onPressed: null,
                          heroTag: 'small-disabled',
                          child: Icon(Icons.add),
                        ),
                        FloatingActionButton.large(
                          onPressed: null,
                          heroTag: 'large-disabled',
                          child: Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: 'page-action',
            backgroundColor: Colors.deepOrange,
            onPressed: () {
              setState(() {
                _count++;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Increment'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'home-action',
            onPressed: () => context.router.replacePath('/'),
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
