import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const String _primaryLottieUrl =
    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json';
const String _secondaryLottieUrl =
    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/AndroidWave.json';

@RoutePage(name: 'LottieRoute')
class LottiePage extends StatefulWidget {
  const LottiePage({super.key});

  @override
  State<LottiePage> createState() => _LottiePageState();
}

class _LottiePageState extends State<LottiePage> with TickerProviderStateMixin {
  late final AnimationController _loopController;
  late final AnimationController _scrubController;
  double _manualProgress = 0.35;
  bool _loopPlaying = true;

  @override
  void initState() {
    super.initState();
    _loopController = AnimationController(vsync: this);
    _scrubController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _loopController.dispose();
    _scrubController.dispose();
    super.dispose();
  }

  void _toggleLoopPlayback() {
    setState(() {
      _loopPlaying = !_loopPlaying;
    });
    if (_loopPlaying) {
      _loopController.repeat();
    } else {
      _loopController.stop();
    }
  }

  void _setManualProgress(double value) {
    setState(() {
      _manualProgress = value;
    });
    _scrubController.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('lottie Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'Render JSON-based animations with controllers and rich loading modes',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `Lottie.network`, animation control via '
            '`AnimationController`, `onLoaded`, `frameBuilder`, '
            '`errorBuilder`, `animate: false`, `repeat`, and the main '
            'constructor patterns used for asset, memory, and network sources.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const _CodeSampleCard(
            title: 'Asset or memory source',
            code: r'''
Lottie.asset('assets/animations/success.json');

Lottie.memory(
  bytes,
  repeat: false,
  frameRate: FrameRate.max,
);
''',
          ),
          const SizedBox(height: 16),
          const _CodeSampleCard(
            title: 'Controller-driven playback',
            code: r'''
final controller = AnimationController(vsync: this);

Lottie.network(
  url,
  controller: controller,
  onLoaded: (composition) {
    controller
      ..duration = composition.duration
      ..forward();
  },
);
''',
          ),
          const SizedBox(height: 16),
          const _CodeSampleCard(
            title: 'Manual scrubbing',
            code: r'''
Lottie.network(
  url,
  controller: controller,
  animate: false,
  repeat: false,
  onLoaded: (composition) {
    controller.duration = composition.duration;
  },
)

controller.value = 0.50; // jump to 50% progress
''',
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Live Demo A: Auto-play and loop',
            description:
                'The animation duration is taken from the loaded composition, '
                'then the controller repeats continuously.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 230,
                  child: Lottie.network(
                    _primaryLottieUrl,
                    controller: _loopController,
                    fit: BoxFit.contain,
                    frameBuilder:
                        (
                          BuildContext context,
                          Widget child,
                          LottieComposition? composition,
                        ) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  const Color(0xFFE0F2FE),
                                  const Color(0xFFDBEAFE),
                                  const Color(0xFFF5F3FF),
                                ],
                              ),
                            ),
                            child: Center(child: child),
                          );
                        },
                    onLoaded: (LottieComposition composition) {
                      if (_loopController.duration != composition.duration) {
                        _loopController.duration = composition.duration;
                        if (_loopPlaying) {
                          _loopController.repeat();
                        }
                      }
                    },
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return _LottieErrorPanel(error: error);
                        },
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _toggleLoopPlayback,
                      icon: Icon(
                        _loopPlaying ? Icons.pause_circle : Icons.play_circle,
                      ),
                      label: Text(_loopPlaying ? 'Pause Loop' : 'Resume Loop'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _loopController
                          ..reset()
                          ..forward();
                        setState(() {
                          _loopPlaying = false;
                        });
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Play Once'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _loopPlaying = true;
                        });
                        _loopController.repeat();
                      },
                      icon: const Icon(Icons.repeat),
                      label: const Text('Repeat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Live Demo B: Manual scrubber',
            description:
                'This version disables auto-play and lets the page drive the '
                'animation progress like a timeline preview.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 230,
                  child: Lottie.network(
                    _secondaryLottieUrl,
                    controller: _scrubController,
                    animate: false,
                    repeat: false,
                    frameRate: FrameRate.max,
                    onLoaded: (LottieComposition composition) {
                      if (_scrubController.duration != composition.duration) {
                        _scrubController.duration = composition.duration;
                        _scrubController.value = _manualProgress;
                      }
                    },
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return _LottieErrorPanel(error: error);
                        },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Progress: ${(_manualProgress * 100).round()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Slider(value: _manualProgress, onChanged: _setManualProgress),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () => _setManualProgress(0),
                      child: const Text('0%'),
                    ),
                    OutlinedButton(
                      onPressed: () => _setManualProgress(0.5),
                      child: const Text('50%'),
                    ),
                    OutlinedButton(
                      onPressed: () => _setManualProgress(1),
                      child: const Text('100%'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Constructor options at a glance',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const <Widget>[
                _InfoPill(
                  title: 'Lottie.asset',
                  subtitle:
                      'Best for bundled animations that should work offline.',
                  color: Color(0xFF2563EB),
                ),
                _InfoPill(
                  title: 'Lottie.network',
                  subtitle:
                      'Good for remotely managed animations and experiments.',
                  color: Color(0xFF0F766E),
                ),
                _InfoPill(
                  title: 'Lottie.memory',
                  subtitle:
                      'Useful when animation bytes come from cache or API.',
                  color: Color(0xFF7C3AED),
                ),
                _InfoPill(
                  title: 'onLoaded + controller',
                  subtitle:
                      'Set the controller duration to the composition duration.',
                  color: Color(0xFFEA580C),
                ),
              ],
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

class _LottieErrorPanel extends StatelessWidget {
  const _LottieErrorPanel({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withValues(alpha: 0.18)),
      ),
      child: Text(
        'Unable to load the remote Lottie animation.\n$error',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
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
            if (description case final String description) ...<Widget>[
              const SizedBox(height: 8),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard({required this.title, required this.code});

  final String title;
  final String code;

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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                code.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}
