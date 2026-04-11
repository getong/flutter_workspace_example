import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

@RoutePage(name: 'IntroductionScreenRoute')
class IntroductionScreenPage extends StatefulWidget {
  const IntroductionScreenPage({super.key});

  @override
  State<IntroductionScreenPage> createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  int _currentPage = 0;
  String _status = 'Preview the onboarding flow below.';
  final List<String> _eventLog = <String>[];

  List<PageViewModel> _pages(BuildContext context) {
    const PageDecoration decoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      bodyTextStyle: TextStyle(fontSize: 16, height: 1.45),
      imagePadding: EdgeInsets.only(top: 24),
      bodyPadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      pageColor: Color(0xFFF8FAFC),
      imageFlex: 3,
      bodyFlex: 2,
    );

    return <PageViewModel>[
      PageViewModel(
        title: 'Welcome',
        body:
            'IntroductionScreen is useful for first-run product tours, feature announcements, and onboarding flows.',
        decoration: decoration,
        useRowInLandscape: true,
        image: const _IntroIllustration(
          color: Color(0xFF1D4ED8),
          icon: Icons.rocket_launch_outlined,
          label: 'PageViewModel',
        ),
        footer: const _FooterLabel(label: 'Footer widget on page 1'),
      ),
      PageViewModel(
        titleWidget: const Text(
          'Configurable Controls',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        bodyWidget: const Text(
          'This page uses titleWidget/bodyWidget rather than plain strings, and the whole flow enables skip, back, next, done, onChange, dotsDecorator, controlsPadding, and a global footer.',
          textAlign: TextAlign.center,
        ),
        decoration: decoration.copyWith(pageColor: const Color(0xFFF0FDF4)),
        image: const _IntroIllustration(
          color: Color(0xFF0F766E),
          icon: Icons.tune,
          label: 'Controls',
        ),
        reverse: true,
        footer: FilledButton.tonal(
          onPressed: () {
            setState(() {
              _status =
                  'Tapped a page footer button inside the onboarding flow.';
            });
            _addLog('Tapped the page-level footer action.');
          },
          child: const Text('Page Footer Action'),
        ),
      ),
      PageViewModel(
        title: 'Completion',
        body:
            'Use onDone and onSkip callbacks to connect onboarding to your real app state or persistence layer.',
        decoration: decoration.copyWith(pageColor: const Color(0xFFFEF2F2)),
        image: const _IntroIllustration(
          color: Color(0xFFDC2626),
          icon: Icons.done_all,
          label: 'Done',
        ),
        useScrollView: false,
      ),
    ];
  }

  void _addLog(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog.insert(0, '$stamp  $message');
      if (_eventLog.length > 12) {
        _eventLog.removeRange(12, _eventLog.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('introduction_screen Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Build onboarding flows with pre-wired skip, next, done, and progress controls.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This module demonstrates `IntroductionScreen`, `PageViewModel`, '
                    '`onChange`, `onDone`, `onSkip`, `showBackButton`, '
                    '`globalFooter`, `DotsDecorator`, `controlsPadding`, and '
                    '`PageDecoration`.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      Chip(label: Text('Current page: $_currentPage')),
                      Chip(label: Text(_status)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 640,
              child: IntroductionScreen(
                pages: _pages(context),
                globalHeader: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 24, right: 24),
                    child: Icon(Icons.auto_awesome, color: Color(0xFF1D4ED8)),
                  ),
                ),
                globalFooter: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _status =
                            'Global footer tapped while previewing the onboarding flow.';
                      });
                      _addLog('Tapped the global footer.');
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Global Footer'),
                  ),
                ),
                showBackButton: true,
                showSkipButton: true,
                skip: const Text('Skip'),
                next: const Icon(Icons.arrow_forward),
                back: const Icon(Icons.arrow_back),
                done: const Text('Done'),
                onChange: (int index) {
                  setState(() {
                    _currentPage = index;
                    _status = 'onChange fired for page $index.';
                  });
                  _addLog('Changed to page $index.');
                },
                onDone: () {
                  setState(() {
                    _status = 'onDone fired from the onboarding flow.';
                  });
                  _addLog('Pressed Done.');
                },
                onSkip: () {
                  setState(() {
                    _status = 'onSkip fired from the onboarding flow.';
                  });
                  _addLog('Pressed Skip.');
                },
                controlsMargin: const EdgeInsets.all(12),
                controlsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                bodyPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                dotsDecorator: const DotsDecorator(
                  size: Size(9, 9),
                  activeSize: Size(24, 9),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  color: Color(0xFFCBD5E1),
                  activeColor: Color(0xFF1D4ED8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CodeCard(
            title: 'Core introduction_screen Pattern',
            code: '''
IntroductionScreen(
  pages: <PageViewModel>[
    PageViewModel(
      title: 'Welcome',
      body: 'Explain your product',
      image: MyIllustration(),
    ),
  ],
  showBackButton: true,
  showSkipButton: true,
  skip: const Text('Skip'),
  next: const Icon(Icons.arrow_forward),
  done: const Text('Done'),
  onChange: (index) {},
  onDone: () {},
  onSkip: () {},
  dotsDecorator: const DotsDecorator(
    activeColor: Color(0xFF1D4ED8),
  ),
);
''',
          ),
          const SizedBox(height: 16),
          _EventLogCard(
            entries: _eventLog,
            emptyLabel: 'No onboarding events yet.',
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

class _IntroIllustration extends StatelessWidget {
  const _IntroIllustration({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 54, color: color),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _FooterLabel extends StatelessWidget {
  const _FooterLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge,
      textAlign: TextAlign.center,
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({required this.entries, required this.emptyLabel});

  final List<String> entries;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Event Log',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text(emptyLabel)
            else
              ...entries.map(
                (String entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(entry),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
