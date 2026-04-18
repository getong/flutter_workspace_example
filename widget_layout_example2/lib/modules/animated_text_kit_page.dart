import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'AnimatedTextKitRoute')
class AnimatedTextKitPage extends StatefulWidget {
  const AnimatedTextKitPage({super.key});

  @override
  State<AnimatedTextKitPage> createState() => _AnimatedTextKitPageState();
}

class _AnimatedTextKitPageState extends State<AnimatedTextKitPage> {
  final AnimatedTextController _controller = AnimatedTextController();
  List<String> _eventLog = <String>[
    'Animation controller is running. Try pause, play, and reset.',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _log(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog = <String>['$stamp  $message', ..._eventLog].take(10).toList();
    });
  }

  String get _controllerState {
    switch (_controller.state) {
      case AnimatedTextState.playing:
        return 'playing';
      case AnimatedTextState.pausedByUser:
        return 'pausedByUser';
      case AnimatedTextState.pausedBetweenAnimations:
        return 'pausedBetweenAnimations';
      case AnimatedTextState.pausedBetweenAnimationsByUser:
        return 'pausedBetweenAnimationsByUser';
      case AnimatedTextState.stopped:
        return 'stopped';
      case AnimatedTextState.reset:
        return 'reset';
    }
  }

  void _play() {
    _controller.play();
    _log('AnimatedTextController.play()');
    setState(() {});
  }

  void _pause() {
    _controller.pause();
    _log('AnimatedTextController.pause()');
    setState(() {});
  }

  void _reset() {
    _controller.reset();
    _log('AnimatedTextController.reset()');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('animated_text_kit Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'animated_text_kit gives you composable animated headlines, '
            'typewriter effects, callbacks, and controller-driven playback.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `AnimatedTextKit`, '
            '`RotateAnimatedText`, `FadeAnimatedText`, '
            '`TypewriterAnimatedText`, `ColorizeAnimatedText`, '
            '`WavyAnimatedText`, `TextLiquidFill`, and '
            '`AnimatedTextController`.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _DemoCard(
            title: 'Mixed animated headline',
            description:
                'Combine multiple animation types in one `AnimatedTextKit` to build a more expressive hero treatment.',
            child: Center(
              child: DefaultTextStyle(
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 700),
                  animatedTexts: <AnimatedText>[
                    RotateAnimatedText('Ship Faster'),
                    RotateAnimatedText('Stay Readable'),
                    FadeAnimatedText(
                      'Keep Motion Intentional',
                      textStyle: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                  onTap: () => _log('Tapped mixed headline demo'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Controller-driven typewriter',
            description:
                'Use `AnimatedTextController` to pause, resume, and reset playback. This is useful for tutorials, onboarding, or synchronized hero sections.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DefaultTextStyle(
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    child: AnimatedTextKit(
                      controller: _controller,
                      isRepeatingAnimation: false,
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                      totalRepeatCount: 1,
                      pause: const Duration(milliseconds: 500),
                      animatedTexts: <AnimatedText>[
                        TypewriterAnimatedText(
                          'Discipline is the best optimization.',
                          speed: const Duration(milliseconds: 45),
                          cursor: '_',
                        ),
                        TypewriterAnimatedText(
                          'Animated text can still stay legible.',
                          speed: const Duration(milliseconds: 45),
                          cursor: '_',
                        ),
                        TypewriterAnimatedText(
                          'Control it with play, pause, and reset.',
                          speed: const Duration(milliseconds: 45),
                          cursor: '_',
                        ),
                      ],
                      onNext: (int index, bool isLast) {
                        _log('onNext index=$index isLast=$isLast');
                      },
                      onFinished: () {
                        _log('Typewriter sequence finished');
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Controller state: $_controllerState'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _play,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _pause,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.replay),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Colorize and wavy styles',
            description:
                'Shorter promotional copy often works well with reusable presets like colorize and wavy text.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 84,
                  child: DefaultTextStyle(
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 400),
                      animatedTexts: <AnimatedText>[
                        ColorizeAnimatedText(
                          'Launch',
                          textStyle: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                          colors: const <Color>[
                            Color(0xFF2563EB),
                            Color(0xFF7C3AED),
                            Color(0xFFEA580C),
                          ],
                        ),
                        WavyAnimatedText(
                          'Measure',
                          textStyle: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                          speed: const Duration(milliseconds: 90),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Useful APIs here: `pause`, `repeatForever`, '
                  '`animatedTexts`, and package-specific text classes.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'TextLiquidFill',
            description:
                'This effect works well for splash sections or one-off reveal moments where you want a stronger animated focal point.',
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextLiquidFill(
                  text: 'FLUTTER',
                  waveColor: theme.colorScheme.primary,
                  boxBackgroundColor: const Color(0xFF111827),
                  textStyle: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                  ),
                  boxHeight: 180,
                  boxWidth: 320,
                  loadDuration: const Duration(seconds: 3),
                  waveDuration: const Duration(milliseconds: 1500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Callback log',
            description:
                'Use the callbacks for analytics, progress state, or coordinating other UI when one text finishes and the next begins.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _eventLog
                  .map(
                    (String item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(item),
                    ),
                  )
                  .toList(growable: false),
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

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
