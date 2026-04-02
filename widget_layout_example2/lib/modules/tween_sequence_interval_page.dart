import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class TweenSequenceIntervalPage extends StatefulWidget {
  const TweenSequenceIntervalPage({super.key});

  @override
  State<TweenSequenceIntervalPage> createState() =>
      _TweenSequenceIntervalPageState();
}

class _TweenSequenceIntervalPageState extends State<TweenSequenceIntervalPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sequenceSize;
  late final Animation<Color?> _sequenceColor;
  late final Animation<double> _intervalOpacity;
  late final Animation<Offset> _intervalOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _sequenceSize = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 80, end: 160),
        weight: 45,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 160, end: 120),
        weight: 35,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 120, end: 140),
        weight: 20,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _sequenceColor = TweenSequence<Color?>(<TweenSequenceItem<Color?>>[
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: Colors.indigo.shade300,
          end: Colors.teal.shade400,
        ),
        weight: 50,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: Colors.teal.shade400,
          end: Colors.deepOrange.shade400,
        ),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _intervalOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _intervalOffset =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TweenSequence + Interval Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'TweenSequence lets one animation move through multiple tween stages, while Interval lets you delay or stagger parts of a parent animation timeline.',
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
                    'TweenSequence Example',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'The box below grows, settles, and grows slightly again using multiple weighted tween stages.',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Container(
                          width: _sequenceSize.value,
                          height: _sequenceSize.value,
                          decoration: BoxDecoration(
                            color: _sequenceColor.value,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Sequence',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
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
                    'Interval Example',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'This panel fades in first, then the status card slides in later by using different intervals on the same controller.',
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _intervalOpacity,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const SelectableText(
                        'Stage 1: Intro text fades in from 0.0 to 0.45 of the animation timeline.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _intervalOffset,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Stage 2: Status Card',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          SelectableText(
                            'This card starts later by using an Interval from 0.4 to 1.0.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _playAnimation,
            child: const Text('Replay Animation'),
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
