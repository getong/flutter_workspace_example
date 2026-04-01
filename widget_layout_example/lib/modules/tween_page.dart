import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TweenPage extends StatefulWidget {
  const TweenPage({super.key});

  @override
  State<TweenPage> createState() => _TweenPageState();
}

class _TweenPageState extends State<TweenPage> {
  double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    final Tween<double> sizeTween = Tween<double>(begin: 80, end: 180);
    final ColorTween colorTween = ColorTween(
      begin: Colors.lightBlue,
      end: Colors.deepPurple,
    );
    final Tween<double> radiusTween = Tween<double>(begin: 12, end: 36);

    final double boxSize = sizeTween.transform(_progress);
    final Color boxColor = colorTween.transform(_progress) ?? Colors.deepPurple;
    final double radius = radiusTween.transform(_progress);

    return Scaffold(
      appBar: AppBar(title: const Text('Tween Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'Tween defines how to interpolate from one value to another. Other animation widgets often use tweens under the hood.',
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
                    'Interpolated Values',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'Move the slider to see Tween and ColorTween map progress into size, radius, and color values.',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      alignment: Alignment.center,
                      child: SelectableText(
                        '${(_progress * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: _progress,
                    onChanged: (double value) {
                      setState(() {
                        _progress = value;
                      });
                    },
                  ),
                  SelectableText(
                    'Size: ${boxSize.toStringAsFixed(1)} | Radius: ${radius.toStringAsFixed(1)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
