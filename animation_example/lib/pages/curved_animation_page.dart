import 'package:flutter/material.dart';

import '../widgets/go_back_icon_button.dart';

class CurvedAnimationPage extends StatefulWidget {
  const CurvedAnimationPage({super.key});

  @override
  State<CurvedAnimationPage> createState() => _CurvedAnimationPageState();
}

class _CurvedAnimationPageState extends State<CurvedAnimationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
      reverseCurve: Curves.easeOutCubic,
    );

    _opacity = Tween<double>(begin: 0.15, end: 1).animate(_curvedAnimation);
    _scale = Tween<double>(begin: 0.65, end: 1.2).animate(_curvedAnimation);
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
        title: const Text('CurvedAnimation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'CurvedAnimation applies non-linear easing to a linear controller.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _curvedAnimation,
              builder: (BuildContext context, Widget? child) {
                final double safeOpacity = _opacity.value
                    .clamp(0.0, 1.0)
                    .toDouble();
                return Opacity(
                  opacity: safeOpacity,
                  child: Transform.scale(
                    scale: _scale.value,
                    child: Container(
                      width: 170,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade400,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _curvedAnimation.value.toStringAsFixed(2),
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
                  icon: const Icon(Icons.pause),
                  label: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
