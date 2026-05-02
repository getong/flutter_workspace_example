import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:widget_layout_example2/app_navigation.dart';

const List<({String title, String detail, Color color, IconData icon})>
_featurePages = <({String title, String detail, Color color, IconData icon})>[
  (
    title: 'Welcome',
    detail:
        'Tie the indicator directly to a PageController and animate dots '
        'from real scroll offset.',
    color: Color(0xFF2563EB),
    icon: Icons.rocket_launch_outlined,
  ),
  (
    title: 'Customize',
    detail:
        'Swap effects, colors, spacing, dot size, axis direction, and tap '
        'behavior without changing the PageView.',
    color: Color(0xFF0F766E),
    icon: Icons.tune_outlined,
  ),
  (
    title: 'Scale',
    detail:
        'Use ScrollingDotsEffect when your page count is larger and you do '
        'not want dozens of visible dots.',
    color: Color(0xFF7C3AED),
    icon: Icons.view_carousel_outlined,
  ),
  (
    title: 'Decouple',
    detail:
        'AnimatedSmoothIndicator works without a PageController when your '
        'active index comes from app state.',
    color: Color(0xFFEA580C),
    icon: Icons.animation_outlined,
  ),
];

const List<({String label, Color color})> _galleryPages =
    <({String label, Color color})>[
      (label: '01', color: Color(0xFF1D4ED8)),
      (label: '02', color: Color(0xFF0F766E)),
      (label: '03', color: Color(0xFF7C3AED)),
      (label: '04', color: Color(0xFFEA580C)),
      (label: '05', color: Color(0xFFDC2626)),
      (label: '06', color: Color(0xFF0284C7)),
      (label: '07', color: Color(0xFF4F46E5)),
      (label: '08', color: Color(0xFF059669)),
      (label: '09', color: Color(0xFFB45309)),
      (label: '10', color: Color(0xFFBE185D)),
    ];

@RoutePage(name: RouteName.smoothPageIndicator)
class SmoothPageIndicatorPage extends StatefulWidget {
  const SmoothPageIndicatorPage({super.key});

  @override
  State<SmoothPageIndicatorPage> createState() =>
      _SmoothPageIndicatorPageState();
}

class _SmoothPageIndicatorPageState extends State<SmoothPageIndicatorPage> {
  final PageController _featureController = PageController(
    viewportFraction: 0.90,
  );
  final PageController _galleryController = PageController();
  int _activeShowcaseIndex = 1;

  @override
  void dispose() {
    _featureController.dispose();
    _galleryController.dispose();
    super.dispose();
  }

  Future<void> _animateFeaturePage(int index) {
    return _featureController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _animateGalleryPage(int index) {
    return _galleryController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('smooth_page_indicator Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'Animate page dots from a real scroll position or from app state',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '`smooth_page_indicator` provides linked indicators for `PageView` '
            'and a self-animated variant for state-driven flows. This page '
            'covers `SmoothPageIndicator`, `AnimatedSmoothIndicator`, '
            '`WormEffect`, `ExpandingDotsEffect`, `ScrollingDotsEffect`, '
            '`SwapEffect`, `CustomizableEffect`, `onDotClicked`, and vertical '
            'layout support.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const _CodeSampleCard(
            title: 'Linked to PageController',
            code: r'''
final controller = PageController();

SmoothPageIndicator(
  controller: controller,
  count: 4,
  effect: WormEffect(),
  onDotClicked: (index) {
    controller.animateToPage(
      index,
      duration: Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  },
)
''',
          ),
          const SizedBox(height: 16),
          const _CodeSampleCard(
            title: 'State-driven indicator',
            code: r'''
AnimatedSmoothIndicator(
  activeIndex: activeStep,
  count: 5,
  effect: ExpandingDotsEffect(
    dotHeight: 10,
    dotWidth: 10,
  ),
)
''',
          ),
          const SizedBox(height: 16),
          const _CodeSampleCard(
            title: 'Vertical and customizable',
            code: r'''
SmoothPageIndicator(
  controller: controller,
  count: 6,
  axisDirection: Axis.vertical,
  effect: CustomizableEffect(
    dotDecoration: DotDecoration(
      width: 12,
      height: 12,
      color: Colors.black12,
    ),
    activeDotDecoration: DotDecoration(
      width: 28,
      height: 12,
      color: Colors.indigo,
      borderRadius: BorderRadius.circular(24),
    ),
  ),
)
''',
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Live Demo A: PageView + WormEffect',
            description:
                'The active dot follows the real scroll offset. Tap any dot to '
                'jump to that page.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 240,
                  child: PageView.builder(
                    controller: _featureController,
                    itemCount: _featurePages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final page = _featurePages[index];
                      return _FeaturePreviewCard(
                        title: page.title,
                        detail: page.detail,
                        color: page.color,
                        icon: page.icon,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: SmoothPageIndicator(
                    controller: _featureController,
                    count: _featurePages.length,
                    onDotClicked: _animateFeaturePage,
                    effect: const WormEffect(
                      dotWidth: 12,
                      dotHeight: 12,
                      spacing: 10,
                      dotColor: Color(0xFFD1D5DB),
                      activeDotColor: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Live Demo B: ScrollingDotsEffect',
            description:
                'This pattern works better when you have many pages and do not '
                'want the indicator row to become too wide.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 130,
                  child: PageView.builder(
                    controller: _galleryController,
                    itemCount: _galleryPages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final page = _galleryPages[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: page.color.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            'Story ${page.label}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: SmoothPageIndicator(
                    controller: _galleryController,
                    count: _galleryPages.length,
                    onDotClicked: _animateGalleryPage,
                    effect: const ScrollingDotsEffect(
                      maxVisibleDots: 5,
                      activeDotScale: 1.35,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 8,
                      dotColor: Color(0xFFCBD5E1),
                      activeDotColor: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Live Demo C: AnimatedSmoothIndicator',
            description:
                'No PageController is required here. The widget only needs the '
                'current active index, which is useful for BLoC, Riverpod, or '
                'any state-driven wizard.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _featurePages[_activeShowcaseIndex].color.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _featurePages[_activeShowcaseIndex].color
                          .withValues(alpha: 0.22),
                    ),
                  ),
                  child: Text(
                    'Active step: ${_activeShowcaseIndex + 1}'
                    ' of ${_featurePages.length}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _activeShowcaseIndex,
                    count: _featurePages.length,
                    effect: const ExpandingDotsEffect(
                      expansionFactor: 3.2,
                      dotWidth: 12,
                      dotHeight: 12,
                      spacing: 8,
                      activeDotColor: Color(0xFF0F172A),
                      dotColor: Color(0xFFCBD5E1),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _activeShowcaseIndex,
                    count: _featurePages.length,
                    effect: const SwapEffect(
                      dotWidth: 12,
                      dotHeight: 12,
                      spacing: 10,
                      activeDotColor: Color(0xFF7C3AED),
                      dotColor: Color(0xFFD8B4FE),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _activeShowcaseIndex,
                    count: _featurePages.length,
                    effect: CustomizableEffect(
                      spacing: 8,
                      dotDecoration: DotDecoration(
                        width: 12,
                        height: 12,
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      activeDotDecoration: DotDecoration(
                        width: 28,
                        height: 12,
                        color: const Color(0xFFEA580C),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _activeShowcaseIndex > 0
                          ? () {
                              setState(() {
                                _activeShowcaseIndex -= 1;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Previous'),
                    ),
                    FilledButton.icon(
                      onPressed: _activeShowcaseIndex < _featurePages.length - 1
                          ? () {
                              setState(() {
                                _activeShowcaseIndex += 1;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Next'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _activeShowcaseIndex = 0;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
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

class _FeaturePreviewCard extends StatelessWidget {
  const _FeaturePreviewCard({
    required this.title,
    required this.detail,
    required this.color,
    required this.icon,
  });

  final String title;
  final String detail;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              color.withValues(alpha: 0.95),
              color.withValues(alpha: 0.72),
              Colors.black.withValues(alpha: 0.88),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const Spacer(),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              detail,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.90),
                height: 1.45,
              ),
            ),
          ],
        ),
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
