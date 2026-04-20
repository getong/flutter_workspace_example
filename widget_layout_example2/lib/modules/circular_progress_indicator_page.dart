import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CircularProgressIndicatorExamplePage extends StatefulWidget {
  const CircularProgressIndicatorExamplePage({super.key});

  @override
  State<CircularProgressIndicatorExamplePage> createState() =>
      _CircularProgressIndicatorExamplePageState();
}

class _CircularProgressIndicatorExamplePageState
    extends State<CircularProgressIndicatorExamplePage> {
  double _progress = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CircularProgressIndicator Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'CircularProgressIndicator is useful for compact loading states and centered task progress.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Determinate Circle',
              description:
                  'Provide a value when you know the current progress of the task.',
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 8,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Slider(
                      value: _progress,
                      onChanged: (double value) {
                        setState(() {
                          _progress = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Indeterminate Circle',
              description:
                  'Leave value null for generic loading states where completion is not measurable yet.',
              child: Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Styled Variants',
              description:
                  'You can adjust strokeWidth and colors for dashboards, overlays, and branded loading states.',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: 0.35,
                      strokeWidth: 4,
                    ),
                  ),
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepOrange,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  ),
                ],
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
