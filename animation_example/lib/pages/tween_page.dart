import 'package:flutter/material.dart';

import '../widgets/go_back_icon_button.dart';

class TweenPage extends StatefulWidget {
  const TweenPage({super.key});

  @override
  State<TweenPage> createState() => _TweenPageState();
}

class _TweenPageState extends State<TweenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationTween;
  late final Animation<double> _paddingTween;
  late final Animation<double> _heightSequence;
  late final Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    final Animation<double> curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotationTween = Tween<double>(begin: -0.09, end: 0.09).animate(curved);
    _paddingTween = Tween<double>(begin: 12, end: 42).animate(curved);
    _heightSequence = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 70, end: 130),
        weight: 60,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 130, end: 95),
        weight: 40,
      ),
    ]).animate(curved);
    _colorTween = ColorTween(
      begin: Colors.cyan.shade300,
      end: Colors.deepOrange.shade300,
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
        title: const Text('Tween + TweenSequence'),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(_paddingTween.value),
              child: Transform.rotate(
                angle: _rotationTween.value,
                child: Container(
                  width: 240,
                  height: _heightSequence.value,
                  decoration: BoxDecoration(
                    color: _colorTween.value,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Tween: ${_controller.value.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: <Widget>[
            FilledButton.icon(
              onPressed: () => _controller.repeat(reverse: true),
              icon: const Icon(Icons.play_circle),
              label: const Text('Play'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _controller.stop(),
              icon: const Icon(Icons.pause_circle),
              label: const Text('Pause'),
            ),
            OutlinedButton.icon(
              onPressed: () => _controller.reset(),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
