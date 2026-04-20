import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class AnimatedDefaultTextStylePage extends StatefulWidget {
  const AnimatedDefaultTextStylePage({super.key});

  @override
  State<AnimatedDefaultTextStylePage> createState() =>
      _AnimatedDefaultTextStylePageState();
}

class _AnimatedDefaultTextStylePageState
    extends State<AnimatedDefaultTextStylePage> {
  bool _emphasized = false;

  void _toggleStyle() {
    setState(() {
      _emphasized = !_emphasized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle animatedStyle = _emphasized
        ? const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.deepPurple,
            letterSpacing: 1.2,
          )
        : const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            letterSpacing: 0,
          );

    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedDefaultTextStyle Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'AnimatedDefaultTextStyle automatically animates text-style changes such as size, weight, color, and spacing when the style updates.',
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
                    'Animated Headline',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'Tap the button to animate between a regular style and a stronger emphasized headline style.',
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                      style: animatedStyle,
                      child: const Text('Quarterly Report'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _toggleStyle,
                    child: Text(
                      _emphasized
                          ? 'Show Regular Style'
                          : 'Show Emphasized Style',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'State Feedback',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'This second example shows how text can visually react to a state change without replacing the widget.',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _emphasized
                          ? Colors.green.shade50
                          : Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _emphasized
                            ? Colors.green.shade300
                            : Colors.blueGrey.shade200,
                      ),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        fontSize: _emphasized ? 24 : 18,
                        fontWeight: _emphasized
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _emphasized
                            ? Colors.green.shade700
                            : Colors.blueGrey.shade700,
                      ),
                      child: Text(
                        _emphasized ? 'Status: Published' : 'Status: Draft',
                      ),
                    ),
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
