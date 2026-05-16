import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.tweenAnimationBuilder)
class TweenAnimationBuilderPage extends StatefulWidget {
  const TweenAnimationBuilderPage({super.key});

  @override
  State<TweenAnimationBuilderPage> createState() =>
      _TweenAnimationBuilderPageState();
}

class _TweenAnimationBuilderPageState extends State<TweenAnimationBuilderPage> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TweenAnimationBuilder Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'TweenAnimationBuilder is useful when you want an animation without managing an AnimationController manually.',
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
                    'Animated Card Size',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'This example animates width, height, radius, and opacity from a single tweened value.',
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.0,
                        end: _expanded ? 1.0 : 0.0,
                      ),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOutCubic,
                      builder:
                          (BuildContext context, double value, Widget? child) {
                            final double width = lerpDouble(120, 240, value)!;
                            final double height = lerpDouble(120, 160, value)!;
                            final double radius = lerpDouble(18, 32, value)!;
                            final Color color = Color.lerp(
                              Colors.blueGrey.shade200,
                              Colors.deepPurple.shade400,
                              value,
                            )!;
                            return Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: lerpDouble(0.72, 1.0, value)!,
                                child: Text(
                                  value > 0.5 ? 'Expanded' : 'Compact',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _toggleExpanded,
                    child: Text(_expanded ? 'Collapse' : 'Expand'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

double? lerpDouble(num a, num b, double t) => a * (1.0 - t) + b * t;
