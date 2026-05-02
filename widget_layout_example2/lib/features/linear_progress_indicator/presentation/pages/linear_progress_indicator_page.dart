import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.linearProgressIndicator)
class LinearProgressIndicatorExamplePage extends StatefulWidget {
  const LinearProgressIndicatorExamplePage({super.key});

  @override
  State<LinearProgressIndicatorExamplePage> createState() =>
      _LinearProgressIndicatorExamplePageState();
}

class _LinearProgressIndicatorExamplePageState
    extends State<LinearProgressIndicatorExamplePage> {
  double _progress = 0.45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LinearProgressIndicator Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'LinearProgressIndicator shows task progress along a horizontal bar.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Determinate Progress',
              description:
                  'Provide a value between 0 and 1 when you know the task completion percentage.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LinearProgressIndicator(value: _progress),
                  const SizedBox(height: 12),
                  Text('${(_progress * 100).round()}% complete'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            _progress = (_progress + 0.1).clamp(0.0, 1.0);
                          });
                        },
                        child: const Text('Advance'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _progress = 0;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Indeterminate Progress',
              description:
                  'Leave value null when the task is still loading but you do not know how far along it is.',
              child: LinearProgressIndicator(),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Styled Indicator',
              description:
                  'Track color, value color, and minHeight help adapt the indicator to dashboards or upload flows.',
              child: LinearProgressIndicator(
                value: 0.72,
                minHeight: 12,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                borderRadius: BorderRadius.all(Radius.circular(999)),
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
