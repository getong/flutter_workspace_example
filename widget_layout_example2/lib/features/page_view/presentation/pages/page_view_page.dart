import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.pageView)
class PageViewPage extends StatefulWidget {
  const PageViewPage({super.key});

  @override
  State<PageViewPage> createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<_PageViewSlide> _slides = <_PageViewSlide>[
    _PageViewSlide(
      title: 'Paged Content',
      subtitle: 'One screen-sized page at a time',
      icon: Icons.view_carousel_outlined,
      color: Color(0xFF3155D6),
      description:
          'PageView lays out children as pages and lets users swipe horizontally or vertically between them.',
    ),
    _PageViewSlide(
      title: 'Gesture Navigation',
      subtitle: 'Swipe left or right to move',
      icon: Icons.swipe_outlined,
      color: Color(0xFF00897B),
      description:
          'It is useful for onboarding, galleries, dashboards, or any flow where each page should fill the available viewport.',
    ),
    _PageViewSlide(
      title: 'Controller Support',
      subtitle: 'Jump or animate from code',
      icon: Icons.animation_outlined,
      color: Color(0xFFE67E22),
      description:
          'A PageController lets code drive the current page, which is useful for buttons, indicators, and synced UI.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int index, {required bool animated}) async {
    final int clampedIndex = index.clamp(0, _slides.length - 1);
    if (animated) {
      await _pageController.animateToPage(
        clampedIndex,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    _pageController.jumpToPage(clampedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _PageViewSlide activeSlide = _slides[_currentPage];

    return Scaffold(
      appBar: AppBar(title: const Text('PageView Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: <Widget>[
            const Text(
              'PageView arranges children as full pages. Users swipe between pages, and a PageController can change the visible page from code.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This makes PageView a good fit for onboarding flows, product tours, image galleries, and dashboards with snap-to-page navigation.',
              style: theme.textTheme.bodyLarge,
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
                      'Swipe And Programmatic Paging',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Swipe the cards below, or use the buttons to jump and animate between pages.',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final _PageViewSlide slide = _slides[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    slide.color,
                                    slide.color.withValues(alpha: 0.68),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                      foregroundColor: slide.color,
                                      child: Icon(slide.icon, size: 30),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      slide.title,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      slide.subtitle,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.92,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      slide.description,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.92,
                                            ),
                                            height: 1.4,
                                          ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Page ${index + 1} of ${_slides.length}',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        OutlinedButton.icon(
                          onPressed: _currentPage == 0
                              ? null
                              : () =>
                                    _goToPage(_currentPage - 1, animated: true),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                        ),
                        FilledButton.icon(
                          onPressed: _currentPage == _slides.length - 1
                              ? null
                              : () =>
                                    _goToPage(_currentPage + 1, animated: true),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                        ),
                        TextButton(
                          onPressed: () => _goToPage(0, animated: false),
                          child: const Text('Jump To First'),
                        ),
                        TextButton(
                          onPressed: () =>
                              _goToPage(_slides.length - 1, animated: false),
                          child: const Text('Jump To Last'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(_slides.length, (
                        int index,
                      ) {
                        final bool selected = index == _currentPage;
                        return ChoiceChip(
                          label: Text('Page ${index + 1}'),
                          selected: selected,
                          onSelected: (_) => _goToPage(index, animated: true),
                        );
                      }),
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
                      'Current Page Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The highlighted card below updates from `onPageChanged`, which is the usual way to sync a `PageView` with indicators or app state.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: activeSlide.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: activeSlide.color.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            activeSlide.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: activeSlide.color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activeSlide.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

class _PageViewSlide {
  const _PageViewSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String description;
}
