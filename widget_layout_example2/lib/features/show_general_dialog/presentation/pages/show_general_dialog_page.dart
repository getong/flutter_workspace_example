import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.showGeneralDialog)
class ShowGeneralDialogPage extends StatefulWidget {
  const ShowGeneralDialogPage({super.key});

  @override
  State<ShowGeneralDialogPage> createState() => _ShowGeneralDialogPageState();
}

class _ShowGeneralDialogPageState extends State<ShowGeneralDialogPage> {
  String _lastResult = 'No general dialog action yet.';
  int _openCount = 0;
  int _barrierDismissCount = 0;

  Future<void> _showCenteredDialog() async {
    final String? result = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss publish dialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 24,
                    borderRadius: BorderRadius.circular(28),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.publish_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Ship release notes?',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'showGeneralDialog gives you direct control over the barrier, transition, and page content when a stock dialog layout is not enough.',
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const <Widget>[
                              Chip(label: Text('Fade animation')),
                              Chip(label: Text('Scale animation')),
                              Chip(label: Text('Barrier dismissible')),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('Draft'),
                                child: const Text('Save draft'),
                              ),
                              const SizedBox(width: 12),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('Published'),
                                child: const Text('Publish'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final Animation<double> curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.92,
                  end: 1,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _openCount += 1;
      if (result == null) {
        _barrierDismissCount += 1;
        _lastResult = 'Centered dialog dismissed by tapping the barrier.';
        return;
      }

      _lastResult = 'Centered dialog result: $result';
    });
  }

  Future<void> _showSlideDialog() async {
    final String? result = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss bottom sheet dialog',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Quick scheduling actions',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This version uses showGeneralDialog to behave like a custom animated action sheet instead of a centered alert.',
                        ),
                        const SizedBox(height: 20),
                        ...<MapEntry<IconData, String>>[
                          const MapEntry(
                            Icons.today_outlined,
                            'Schedule for today',
                          ),
                          const MapEntry(
                            Icons.calendar_view_week,
                            'Plan this week',
                          ),
                          const MapEntry(
                            Icons.snooze_outlined,
                            'Snooze until later',
                          ),
                        ].map((MapEntry<IconData, String> item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(item.key),
                              title: Text(item.value),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  Navigator.of(context).pop(item.value),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final Animation<double> curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _openCount += 1;
      if (result == null) {
        _barrierDismissCount += 1;
        _lastResult = 'Slide dialog dismissed before choosing an action.';
        return;
      }

      _lastResult = 'Slide dialog selected: $result';
    });
  }

  Future<void> _showFullscreenOverlay() async {
    final String? result = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Close onboarding overlay',
      barrierColor: Colors.black.withValues(alpha: 0.78),
      transitionDuration: const Duration(milliseconds: 360),
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            final ThemeData theme = Theme.of(context);

            return Material(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF0D47A1), Color(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Fullscreen onboarding overlay',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).pop('Closed'),
                                color: Colors.white,
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Because pageBuilder can return any widget tree, showGeneralDialog can cover the screen with an immersive guided flow instead of a small dialog card.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                _OverlayStepCard(
                                  icon: Icons.filter_1,
                                  title: 'Explain the flow',
                                  description:
                                      'Use a bold hero area when the user needs context before taking action.',
                                ),
                                _OverlayStepCard(
                                  icon: Icons.filter_2,
                                  title: 'Show progressive steps',
                                  description:
                                      'List cards, checklists, or media previews just like a full page route.',
                                ),
                                _OverlayStepCard(
                                  icon: Icons.filter_3,
                                  title: 'Return a result',
                                  description:
                                      'Complete the flow with Navigator.pop(result) so the caller receives a value.',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              OutlinedButton(
                                onPressed: () => Navigator.of(
                                  context,
                                ).pop('Skipped onboarding'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white70),
                                ),
                                child: const Text('Skip'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(
                                  context,
                                ).pop('Completed onboarding'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF0D47A1),
                                ),
                                child: const Text('Finish walkthrough'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final Animation<double> curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
              reverseCurve: Curves.easeInQuart,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _openCount += 1;
      _lastResult = 'Fullscreen overlay result: ${result ?? 'Dismissed'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('showGeneralDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'showGeneralDialog is the low-level Flutter API for building custom modal routes with your own barrier behavior, animations, and page content.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _CodeCard(
              title: 'Centered custom dialog',
              code: '''
showGeneralDialog<String>(
  context: context,
  barrierDismissible: true,
  barrierLabel: 'Dismiss',
  barrierColor: Colors.black54,
  transitionDuration: const Duration(milliseconds: 260),
  pageBuilder: (context, animation, secondaryAnimation) {
    return const Center(child: Material(child: Text('Custom dialog')));
  },
  transitionBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation, child: child),
    );
  },
);
''',
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Slide-up custom sheet',
              code: '''
showGeneralDialog<String>(
  context: context,
  barrierDismissible: true,
  barrierLabel: 'Dismiss actions',
  pageBuilder: (context, animation, secondaryAnimation) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(child: ActionList()),
    );
  },
  transitionBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
);
''',
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Fullscreen overlay flow',
              code: '''
showGeneralDialog<String>(
  context: context,
  barrierDismissible: false,
  barrierLabel: 'Onboarding overlay',
  barrierColor: Colors.black87,
  transitionDuration: const Duration(milliseconds: 360),
  pageBuilder: (context, animation, secondaryAnimation) {
    return SafeArea(child: WalkthroughOverlay());
  },
  transitionBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(opacity: animation, child: child);
  },
);
''',
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Basic Modal With Barrier Dismiss',
              description:
                  'This example uses showGeneralDialog for a centered modal card and returns a String result when the user picks an action.',
              child: FilledButton.icon(
                onPressed: _showCenteredDialog,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open centered dialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Custom Transition Builder',
              description:
                  'This one slides from the bottom, which is useful when you want modal actions to feel closer to a custom bottom sheet.',
              child: OutlinedButton.icon(
                onPressed: _showSlideDialog,
                icon: const Icon(Icons.swipe_up),
                label: const Text('Open slide dialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Fullscreen Modal Overlay',
              description:
                  'Because pageBuilder can return any widget tree, you can build a route-sized dialog experience without leaving the current page.',
              child: FilledButton.tonalIcon(
                onPressed: _showFullscreenOverlay,
                icon: const Icon(Icons.fullscreen),
                label: const Text('Open fullscreen overlay'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'The Future returned by showGeneralDialog makes it easy to keep state in sync with whatever action or dismissal happened inside the modal.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_lastResult),
                  const SizedBox(height: 8),
                  Text('Dialogs opened: $_openCount'),
                  const SizedBox(height: 4),
                  Text('Barrier dismissals: $_barrierDismissCount'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Parameters To Know',
              description:
                  'These fields are the main reason to reach for showGeneralDialog instead of higher-level helpers.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ParameterLine(
                    label: 'barrierDismissible',
                    text:
                        'Allows or blocks dismissing the modal by tapping outside it.',
                  ),
                  SizedBox(height: 8),
                  _ParameterLine(
                    label: 'barrierLabel',
                    text: 'Accessibility label for the modal barrier.',
                  ),
                  SizedBox(height: 8),
                  _ParameterLine(
                    label: 'barrierColor',
                    text:
                        'Controls the dimming or visual treatment behind the modal.',
                  ),
                  SizedBox(height: 8),
                  _ParameterLine(
                    label: 'transitionDuration',
                    text: 'Sets how quickly the route animates in and out.',
                  ),
                  SizedBox(height: 8),
                  _ParameterLine(
                    label: 'pageBuilder',
                    text:
                        'Builds the actual modal widget tree you want to show.',
                  ),
                  SizedBox(height: 8),
                  _ParameterLine(
                    label: 'transitionBuilder',
                    text:
                        'Wraps the modal with fade, slide, scale, or any custom animation.',
                  ),
                ],
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

class _OverlayStepCard extends StatelessWidget {
  const _OverlayStepCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.14),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D47A1),
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        ),
      ),
    );
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

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParameterLine extends StatelessWidget {
  const _ParameterLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <InlineSpan>[
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
