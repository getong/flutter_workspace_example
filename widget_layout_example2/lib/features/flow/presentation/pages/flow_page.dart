import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flow)
class FlowExamplePage extends StatefulWidget {
  const FlowExamplePage({super.key});

  @override
  State<FlowExamplePage> createState() => _FlowExamplePageState();
}

class _FlowExamplePageState extends State<FlowExamplePage> {
  double _spacing = 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flow Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Flow positions its children using a custom FlowDelegate. It is useful when you want layout behavior that standard Row, Column, or Wrap cannot express cleanly.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Custom Horizontal Flow',
              description:
                  'This example lays items out with delegate-controlled spacing and slight vertical staggering.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: Flow(
                      delegate: _StaggeredFlowDelegate(spacing: _spacing),
                      children: List<Widget>.generate(5, (int index) {
                        final List<Color> colors = <Color>[
                          Colors.indigo,
                          Colors.teal,
                          Colors.orange,
                          Colors.pink,
                          Colors.blueGrey,
                        ];
                        return Container(
                          width: 82,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Item ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Slider(
                    min: 4,
                    max: 28,
                    value: _spacing,
                    label: _spacing.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _spacing = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Why Flow?',
              description:
                  'Flow is appropriate when you need custom positioning rules, special animations, or layout delegates that work directly with child paint transforms.',
              child: Text(
                'Compared with Wrap, Flow gives you lower-level placement control through a delegate.',
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

class _StaggeredFlowDelegate extends FlowDelegate {
  const _StaggeredFlowDelegate({required this.spacing});

  final double spacing;

  @override
  void paintChildren(FlowPaintingContext context) {
    double x = 0;
    for (int index = 0; index < context.childCount; index++) {
      final double y = index.isEven ? 0 : 22;
      context.paintChild(index, transform: Matrix4.translationValues(x, y, 0));
      x += context.getChildSize(index)!.width + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant _StaggeredFlowDelegate oldDelegate) {
    return oldDelegate.spacing != spacing;
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
