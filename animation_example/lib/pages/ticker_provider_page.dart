import 'package:flutter/material.dart';

import '../widgets/go_back_icon_button.dart';

class TickerProviderPage extends StatefulWidget {
  const TickerProviderPage({super.key});

  @override
  State<TickerProviderPage> createState() => _TickerProviderPageState();
}

class _TickerProviderPageState extends State<TickerProviderPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _turnsAnimation;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    final CurvedAnimation curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.25).animate(curved);
    _turnsAnimation = Tween<double>(begin: 0, end: 1).animate(curved);
    _colorAnimation = ColorTween(
      begin: Colors.teal.shade300,
      end: Colors.orange.shade400,
    ).animate(curved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const GoBackIconButton(),
        title: const Text('TickerProvider + AnimationController'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'SingleTickerProviderStateMixin provides vsync for the controller.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: RotationTransition(
                    turns: _turnsAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${(_controller.value * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () => _controller.forward(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Forward'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _controller.reverse(),
                  icon: const Icon(Icons.reply),
                  label: const Text('Reverse'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _controller.repeat(reverse: true),
                  icon: const Icon(Icons.repeat),
                  label: const Text('Repeat'),
                ),
                TextButton.icon(
                  onPressed: () => _controller.stop(),
                  icon: const Icon(Icons.pause_circle),
                  label: const Text('Stop'),
                ),
                TextButton.icon(
                  onPressed: () => _controller.reset(),
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
