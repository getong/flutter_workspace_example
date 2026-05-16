import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.onboardingOverlay)
class OnboardingOverlayPage extends StatefulWidget {
  const OnboardingOverlayPage({super.key});

  @override
  State<OnboardingOverlayPage> createState() => _OnboardingOverlayPageState();
}

class _OnboardingOverlayPageState extends State<OnboardingOverlayPage> {
  final GlobalKey<OnboardingState> _onboardingKey =
      GlobalKey<OnboardingState>();
  final FocusNode _tourButtonFocusNode = FocusNode(
    debugLabel: 'tour-button-focus',
  );
  final FocusNode _analyticsCardFocusNode = FocusNode(
    debugLabel: 'analytics-card-focus',
  );
  final FocusNode _ctaButtonFocusNode = FocusNode(
    debugLabel: 'cta-button-focus',
  );
  final FocusNode _settingsTileFocusNode = FocusNode(
    debugLabel: 'settings-tile-focus',
  );

  int _currentStep = -1;
  String _status =
      'Press "Start Tour" to render the onboarding overlay on top of the dashboard preview.';
  List<String> _eventLog = <String>[];

  List<OnboardingStep> get _steps => <OnboardingStep>[
    OnboardingStep(
      focusNode: _tourButtonFocusNode,
      titleText: 'Start the walkthrough',
      bodyText:
          'This step highlights the launch control. It uses a label box, arrow, custom overlay color, and a translucent overlay tap behavior.',
      overlayColor: const Color(0xCC0F172A),
      overlayBehavior: HitTestBehavior.translucent,
      hasLabelBox: true,
      hasArrow: true,
      labelBoxDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      titleTextColor: const Color(0xFF0F172A),
      bodyTextColor: const Color(0xFF334155),
      onTapCallback: (TapArea area, VoidCallback next, VoidCallback close) {
        if (area == TapArea.hole || area == TapArea.label) {
          next();
        }
      },
    ),
    OnboardingStep(
      focusNode: _analyticsCardFocusNode,
      titleText: 'Highlight insight surfaces',
      bodyText:
          'This card shows a non-fullscreen step with pulse animation and a rounded overlay hole so you can focus one dashboard region at a time.',
      fullscreen: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      overlayShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      overlayColor: const Color(0xCC1D4ED8),
      hasLabelBox: true,
      hasArrow: true,
      showPulseAnimation: true,
      labelBoxDecoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextColor: const Color(0xFF0F172A),
      bodyTextColor: const Color(0xFF334155),
    ),
    OnboardingStep(
      focusNode: _ctaButtonFocusNode,
      titleText: 'Use a custom stepBuilder',
      bodyText:
          'The package also lets you replace the default tooltip UI completely.',
      overlayColor: const Color(0xD90F766E),
      shape: const StadiumBorder(),
      overlayShape: const StadiumBorder(),
      overlayBehavior: HitTestBehavior.deferToChild,
      stepBuilder: (BuildContext context, OnboardingStepRenderInfo renderInfo) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 24,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  renderInfo.titleText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(renderInfo.bodyText, style: const TextStyle(height: 1.4)),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: renderInfo.close,
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: renderInfo.nextStep,
                      child: const Text('Next Step'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    OnboardingStep(
      focusNode: _settingsTileFocusNode,
      titleText: 'Finish with a contextual step',
      bodyText:
          'Use the final step to route users to settings, permissions, or first-run configuration screens.',
      overlayColor: const Color(0xCC7C2D12),
      hasLabelBox: true,
      hasArrow: true,
      labelBoxDecoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      titleTextColor: const Color(0xFF7C2D12),
      bodyTextColor: const Color(0xFF92400E),
    ),
  ];

  @override
  void dispose() {
    _tourButtonFocusNode.dispose();
    _analyticsCardFocusNode.dispose();
    _ctaButtonFocusNode.dispose();
    _settingsTileFocusNode.dispose();
    super.dispose();
  }

  void _logEvent(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog = <String>[
        '$timestamp  $message',
        ..._eventLog,
      ].take(12).toList();
    });
  }

  void _startTour() {
    _onboardingKey.currentState?.show();
    _logEvent('Started onboarding from step 0');
  }

  void _startFromCallToAction() {
    _onboardingKey.currentState?.showFromIndex(2);
    _logEvent('Started onboarding from step 2');
  }

  void _closeTour() {
    _onboardingKey.currentState?.hide();
    _logEvent('Closed onboarding overlay');
    setState(() {
      _status = 'Closed the onboarding overlay manually.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('onboarding_overlay Module')),
      body: SelectionArea(
        child: Onboarding(
          key: _onboardingKey,
          steps: _steps,
          autoSizeTexts: true,
          onChanged: (int index) {
            setState(() {
              _currentStep = index;
              _status = 'Onboarding changed to step $index.';
            });
            _logEvent('onChanged fired for step $index');
          },
          onEnd: (int index) {
            setState(() {
              _currentStep = index;
              _status = 'Onboarding finished from step $index.';
            });
            _logEvent('onEnd fired from step $index');
          },
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Guide users through live interface elements with a focus-aware overlay.',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This module demonstrates `Onboarding`, '
                        '`OnboardingStep`, `OnboardingState.show`, '
                        '`showFromIndex`, `hide`, custom `stepBuilder`, '
                        '`overlayBehavior`, `overlayShape`, `showPulseAnimation`, '
                        '`hasLabelBox`, and `hasArrow`.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: _startTour,
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Start Tour'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _startFromCallToAction,
                            icon: const Icon(Icons.ads_click_outlined),
                            label: const Text('Jump To CTA'),
                          ),
                          TextButton.icon(
                            onPressed: _closeTour,
                            icon: const Icon(Icons.close),
                            label: const Text('Close Overlay'),
                          ),
                          Chip(label: Text('Current step: $_currentStep')),
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Dashboard Preview',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Focus(
                            focusNode: _tourButtonFocusNode,
                            child: FilledButton.icon(
                              onPressed: _startTour,
                              icon: const Icon(Icons.rocket_launch_outlined),
                              label: const Text('Start Tour'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Focus(
                        focusNode: _analyticsCardFocusNode,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFFDBEAFE),
                                Color(0xFFE0F2FE),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Analytics Card',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: const <Widget>[
                                  _MetricPill(
                                    label: 'Activation',
                                    value: '82%',
                                    color: Color(0xFF1D4ED8),
                                  ),
                                  _MetricPill(
                                    label: 'Retention',
                                    value: '67%',
                                    color: Color(0xFF0F766E),
                                  ),
                                  _MetricPill(
                                    label: 'Tasks',
                                    value: '14',
                                    color: Color(0xFF7C3AED),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              color: const Color(0xFFF8FAFC),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Primary action',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Use onboarding to explain the most important next action.',
                                    ),
                                    const SizedBox(height: 16),
                                    Focus(
                                      focusNode: _ctaButtonFocusNode,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          _logEvent(
                                            'Tapped CTA button inside preview',
                                          );
                                          setState(() {
                                            _status =
                                                'Tapped the primary call to action.';
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.play_arrow_rounded,
                                        ),
                                        label: const Text('Launch Campaign'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Focus(
                              focusNode: _settingsTileFocusNode,
                              child: Card(
                                color: const Color(0xFFFFFBEB),
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.settings_suggest_outlined,
                                  ),
                                  title: Text('Review onboarding settings'),
                                  subtitle: Text(
                                    'Use the last step to point users toward permissions and preferences.',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _CodeCard(
                title: 'Core onboarding_overlay Pattern',
                code: '''
final onboardingKey = GlobalKey<OnboardingState>();

Onboarding(
  key: onboardingKey,
  onChanged: (index) {},
  onEnd: (index) {},
  steps: [
    OnboardingStep(
      focusNode: focusNode,
      titleText: 'Welcome',
      bodyText: 'Guide users through the interface',
      hasLabelBox: true,
      hasArrow: true,
    ),
  ],
  child: DashboardPreview(),
)
''',
              ),
              const SizedBox(height: 16),
              _EventLogCard(
                entries: _eventLog,
                emptyLabel: 'No onboarding events recorded yet.',
              ),
            ],
          ),
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

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
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
      child: Padding(
        padding: const EdgeInsets.all(18),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace', height: 1.4),
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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text(emptyLabel)
            else
              ...entries.map(
                (String entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
