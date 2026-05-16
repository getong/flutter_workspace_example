import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

enum _TransitionSection { overview, activity, settings }

@RoutePage(name: RouteName.animationsPackage)
class AnimationsPage extends StatefulWidget {
  const AnimationsPage({super.key});

  @override
  State<AnimationsPage> createState() => _AnimationsPageState();
}

class _AnimationsPageState extends State<AnimationsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeScaleController;

  _TransitionSection _fadeThroughSection = _TransitionSection.overview;
  bool _showInsights = false;
  SharedAxisTransitionType _sharedAxisType =
      SharedAxisTransitionType.horizontal;
  bool _showDetailsStep = false;

  @override
  void initState() {
    super.initState();
    _fadeScaleController = AnimationController(
      value: 1,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 120),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fadeScaleController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    if (_fadeScaleController.status == AnimationStatus.completed ||
        _fadeScaleController.status == AnimationStatus.forward) {
      _fadeScaleController.reverse();
      return;
    }

    _fadeScaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('animations Module')),
      floatingActionButton: AnimatedBuilder(
        animation: _fadeScaleController,
        builder: (BuildContext context, Widget? child) {
          return FadeScaleTransition(
            animation: _fadeScaleController,
            child: child,
          );
        },
        child: Visibility(
          visible: _fadeScaleController.status != AnimationStatus.dismissed,
          child: FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Quick Action'),
          ),
        ),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'The `animations` package ships Material motion primitives that are more opinionated than core Flutter widgets: container transform, shared axis, fade through, fade scale, and modal transitions.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates practical app usage with `OpenContainer`, `PageTransitionSwitcher`, `SharedAxisTransition`, `FadeThroughTransition`, `FadeScaleTransition`, and `showModal` so you can see where each widget fits.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'OpenContainer',
              description:
                  'Container transform is useful when a card, list row, or FAB opens a richer detail surface and you want the navigation motion to feel spatially connected.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: <Widget>[
                      _OpenContainerTile(
                        color: const Color(0xFF2563EB),
                        title: 'Revenue Digest',
                        subtitle:
                            'Open a summary card into a full analytics detail page.',
                        icon: Icons.insights_outlined,
                      ),
                      _OpenContainerTile(
                        color: const Color(0xFF059669),
                        title: 'Design Review',
                        subtitle:
                            'Use the same pattern from boards or task lists.',
                        icon: Icons.draw_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OpenContainer<void>(
                    transitionDuration: const Duration(milliseconds: 450),
                    closedElevation: 0,
                    closedColor: colorScheme.primary,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    openBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                          return const _AnimationsDetailPage(
                            title: 'Create Workflow',
                            subtitle:
                                'OpenContainer also works well for FAB-like entry points into task creation or onboarding flows.',
                            color: Color(0xFF1D4ED8),
                          );
                        },
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                          return SizedBox(
                            width: 220,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: colorScheme.onPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Open from CTA',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'SharedAxisTransition',
              description:
                  'Shared axis motion is useful for stepped flows where the user perceives movement through related content on the X, Y, or Z axis.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SegmentedButton<SharedAxisTransitionType>(
                    segments: const <ButtonSegment<SharedAxisTransitionType>>[
                      ButtonSegment<SharedAxisTransitionType>(
                        value: SharedAxisTransitionType.horizontal,
                        label: Text('X'),
                      ),
                      ButtonSegment<SharedAxisTransitionType>(
                        value: SharedAxisTransitionType.vertical,
                        label: Text('Y'),
                      ),
                      ButtonSegment<SharedAxisTransitionType>(
                        value: SharedAxisTransitionType.scaled,
                        label: Text('Z'),
                      ),
                    ],
                    selected: <SharedAxisTransitionType>{_sharedAxisType},
                    onSelectionChanged: (Set<SharedAxisTransitionType> value) {
                      setState(() {
                        _sharedAxisType = value.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: PageTransitionSwitcher(
                      reverse: !_showDetailsStep,
                      transitionBuilder:
                          (
                            Widget child,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                          ) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: _sharedAxisType,
                              child: child,
                            );
                          },
                      child: _showDetailsStep
                          ? _SharedAxisCard(
                              key: const ValueKey<String>('details'),
                              color: const Color(0xFF0F766E),
                              title: 'Step 2: Review Changes',
                              description:
                                  'Shared axis keeps the next step feeling related to the previous surface.',
                              bullet:
                                  'Good for onboarding, checkout, and multi-step editors.',
                            )
                          : _SharedAxisCard(
                              key: const ValueKey<String>('intro'),
                              color: const Color(0xFF7C3AED),
                              title: 'Step 1: Set Preferences',
                              description:
                                  'Choose categories and pacing before the workflow advances.',
                              bullet:
                                  'Motion communicates progression, not a totally new destination.',
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      TextButton(
                        onPressed: _showDetailsStep
                            ? () {
                                setState(() => _showDetailsStep = false);
                              }
                            : null,
                        child: const Text('Back'),
                      ),
                      FilledButton(
                        onPressed: !_showDetailsStep
                            ? () {
                                setState(() => _showDetailsStep = true);
                              }
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'FadeThroughTransition',
              description:
                  'Fade through works well for lateral swaps between sibling destinations such as tabs, filters, or dashboard sections.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 260,
                    child: PageTransitionSwitcher(
                      transitionBuilder:
                          (
                            Widget child,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                          ) {
                            return FadeThroughTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              child: child,
                            );
                          },
                      child: _FadeThroughPane(
                        key: ValueKey<_TransitionSection>(_fadeThroughSection),
                        section: _fadeThroughSection,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  NavigationBar(
                    selectedIndex: _fadeThroughSection.index,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _fadeThroughSection = _TransitionSection.values[index];
                      });
                    },
                    destinations: const <NavigationDestination>[
                      NavigationDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard),
                        label: 'Overview',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.graphic_eq_outlined),
                        selectedIcon: Icon(Icons.graphic_eq),
                        label: 'Activity',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'FadeScaleTransition and Modal',
              description:
                  'Fade scale is a good fit for surfaces that appear above the current page, such as floating actions, dialogs, and lightweight pickers.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () {
                          showModal<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return const _RecommendationModal();
                            },
                          );
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Show modal'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _toggleFab,
                        icon: const Icon(Icons.flip),
                        label: Text(
                          _fadeScaleController.status ==
                                      AnimationStatus.completed ||
                                  _fadeScaleController.status ==
                                      AnimationStatus.forward
                              ? 'Hide FAB'
                              : 'Show FAB',
                        ),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.auto_graph, size: 18),
                        label: Text(
                          _showInsights
                              ? 'Show compact insight'
                              : 'Show expanded insight',
                        ),
                        onPressed: () {
                          setState(() {
                            _showInsights = !_showInsights;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (
                          Widget child,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return FadeScaleTransition(
                            animation: animation,
                            child: child,
                          );
                        },
                    child: _showInsights
                        ? Container(
                            key: const ValueKey<String>('expanded'),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Expanded insight',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Use FadeScaleTransition when the next surface should feel like it appears above the current context instead of replacing it spatially.',
                                ),
                              ],
                            ),
                          )
                        : Container(
                            key: const ValueKey<String>('compact'),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Compact insight card',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),
                ],
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
                fontWeight: FontWeight.w700,
              ),
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

class _OpenContainerTile extends StatelessWidget {
  const _OpenContainerTile({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<void>(
      transitionDuration: const Duration(milliseconds: 450),
      closedElevation: 0,
      closedColor: color.withValues(alpha: 0.08),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      openBuilder: (BuildContext context, VoidCallback openContainer) {
        return _AnimationsDetailPage(
          title: title,
          subtitle: subtitle,
          color: color,
        );
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          width: 280,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  child: Icon(icon),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(subtitle),
                const SizedBox(height: 16),
                Text(
                  'Tap to open',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimationsDetailPage extends StatelessWidget {
  const _AnimationsDetailPage({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(subtitle),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'OpenContainer is best when the closed and open surfaces represent the same conceptual object, such as a list card opening into a detailed destination.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedAxisCard extends StatelessWidget {
  const _SharedAxisCard({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.bullet,
  });

  final Color color;
  final String title;
  final String description;
  final String bullet;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(description),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Icon(Icons.check_circle_outline, color: color),
              const SizedBox(width: 10),
              Expanded(child: Text(bullet)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FadeThroughPane extends StatelessWidget {
  const _FadeThroughPane({super.key, required this.section});

  final _TransitionSection section;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _TransitionSection.overview => _FadeThroughCard(
        color: const Color(0xFF2563EB),
        title: 'Overview',
        lines: const <String>[
          'Portfolio health is up 12% this week.',
          'Two campaigns are close to target.',
          'Use FadeThrough for tab or destination swaps.',
        ],
      ),
      _TransitionSection.activity => _FadeThroughCard(
        color: const Color(0xFF059669),
        title: 'Activity',
        lines: const <String>[
          '14 new comments landed in the review queue.',
          '5 items changed status in the last hour.',
          'The old page fades away before the new one enters.',
        ],
      ),
      _TransitionSection.settings => _FadeThroughCard(
        color: const Color(0xFF7C3AED),
        title: 'Settings',
        lines: const <String>[
          'Notifications and digest timing can be updated here.',
          'Surface swaps feel softer than a shared-axis progression.',
          'Best for sibling destinations, not sequential steps.',
        ],
      ),
    };
  }
}

class _FadeThroughCard extends StatelessWidget {
  const _FadeThroughCard({
    required this.color,
    required this.title,
    required this.lines,
  });

  final Color color;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[color.withValues(alpha: 0.16), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ...lines.map(
            (String line) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.circle, size: 10, color: color),
                  const SizedBox(width: 10),
                  Expanded(child: Text(line)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationModal extends StatelessWidget {
  const _RecommendationModal();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'FadeScale modal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The package `showModal` helper uses a fade-scale entrance by default, which is useful for compact overlays and lightweight confirmations.',
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
