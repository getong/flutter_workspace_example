import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.hero)
class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  bool _heroEnabled = true;

  void _openBasicDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const _HeroDetailPage(
          title: 'Basic Hero',
          subtitle: 'A single tag connects the source and destination widgets.',
          tag: 'hero-basic-card',
          color: Color(0xFF2563EB),
          icon: Icons.landscape_rounded,
          facts: <String>[
            '`Hero(tag: ...)` must exist on both routes.',
            'The widget trees can differ, but the tags must match.',
            'This is useful for cards opening into detail pages.',
          ],
        ),
      ),
    );
  }

  void _openArcDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const _HeroDetailPage(
          title: 'Arc Tween Hero',
          subtitle:
              'This demo uses `createRectTween` to produce a more material-style flight path.',
          tag: 'hero-arc-avatar',
          color: Color(0xFF7C3AED),
          icon: Icons.auto_awesome_rounded,
          facts: <String>[
            '`createRectTween` changes the hero flight geometry.',
            'Material arc tweens feel more natural for large cards and avatars.',
            'This is useful when the default linear flight looks too abrupt.',
          ],
          useArcTween: true,
        ),
      ),
    );
  }

  void _openShuttleDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const _HeroDetailPage(
          title: 'Custom Shuttle Hero',
          subtitle:
              'This demo customizes the in-flight widget with `flightShuttleBuilder` and keeps the source visible with `placeholderBuilder`.',
          tag: 'hero-shuttle-chip',
          color: Color(0xFF0F766E),
          icon: Icons.rocket_launch_rounded,
          facts: <String>[
            '`flightShuttleBuilder` lets you style the widget while it flies.',
            '`placeholderBuilder` avoids awkward empty space on the source route.',
            'This is useful for branded motion or more readable in-flight states.',
          ],
          useCustomShuttle: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Hero Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Hero animates a shared element between routes so the transition '
              'feels spatially connected instead of abrupt.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates `Hero`, `HeroMode`, `createRectTween`, '
              '`flightShuttleBuilder`, `placeholderBuilder`, and '
              '`transitionOnUserGestures` with practical navigation examples.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _HeroDemoCard(
              title: 'Basic Hero transition',
              description:
                  'Start with a normal source card and a matching detail header. The shared tag is enough for Flutter to animate between routes.',
              hero: Hero(
                tag: 'hero-basic-card',
                flightShuttleBuilder: _basicFlightShuttleBuilder(
                  color: const Color(0xFF2563EB),
                  icon: Icons.landscape_rounded,
                  label: 'Product Story',
                ),
                transitionOnUserGestures: true,
                child: _DemoSurface(
                  color: const Color(0xFF2563EB),
                  icon: Icons.landscape_rounded,
                  title: 'Product Story',
                  subtitle: 'Open a compact card into a full detail screen.',
                ),
              ),
              footer:
                  'Good for cards, gallery items, articles, products, and dashboards.',
              actionLabel: 'Open Basic Demo',
              onPressed: _openBasicDemo,
            ),
            const SizedBox(height: 16),
            _HeroDemoCard(
              title: 'Custom flight path with createRectTween',
              description:
                  'When the default flight feels too plain, `createRectTween` gives you control over how the shared element travels.',
              hero: Hero(
                tag: 'hero-arc-avatar',
                createRectTween: (Rect? begin, Rect? end) =>
                    MaterialRectCenterArcTween(begin: begin, end: end),
                flightShuttleBuilder: _basicFlightShuttleBuilder(
                  color: const Color(0xFF7C3AED),
                  icon: Icons.auto_awesome_rounded,
                  label: 'Arc Tween',
                ),
                transitionOnUserGestures: true,
                child: const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFF7C3AED),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              footer:
                  'Useful when large avatars, thumbnails, or feature cards should travel with a smoother arc.',
              actionLabel: 'Open Arc Demo',
              onPressed: _openArcDemo,
            ),
            const SizedBox(height: 16),
            _HeroDemoCard(
              title: 'Custom in-flight widget',
              description:
                  'Use `flightShuttleBuilder` to restyle the hero while it is moving and `placeholderBuilder` to keep the source layout stable.',
              hero: Hero(
                tag: 'hero-shuttle-chip',
                placeholderBuilder:
                    (BuildContext context, Size heroSize, Widget child) =>
                        Opacity(opacity: 0.18, child: child),
                flightShuttleBuilder:
                    (
                      BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext,
                    ) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.scale(
                            scale: Tween<double>(
                              begin: 0.92,
                              end: 1.06,
                            ).evaluate(animation),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color.lerp(
                                  const Color(0xFF0F766E),
                                  const Color(0xFF14B8A6),
                                  animation.value,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.14),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Icon(
                                Icons.rocket_launch_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Launch plan',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                transitionOnUserGestures: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(Icons.rocket_launch_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Launch plan',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              footer:
                  'Useful when you want branded motion, special shadows, or a more legible flying state.',
              actionLabel: 'Open Shuttle Demo',
              onPressed: _openShuttleDemo,
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'HeroMode toggle',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '`HeroMode` lets you opt a subtree in or out of hero participation. This is useful when a list, overlay, or tab should not animate shared elements temporarily.',
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable hero animation'),
                      subtitle: Text(
                        _heroEnabled
                            ? 'HeroMode is enabled. Opening the preview will animate the shared card.'
                            : 'HeroMode is disabled. The next route opens without a hero flight.',
                      ),
                      value: _heroEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _heroEnabled = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    HeroMode(
                      enabled: _heroEnabled,
                      child: Hero(
                        tag: 'hero-mode-preview',
                        flightShuttleBuilder: _basicFlightShuttleBuilder(
                          color: const Color(0xFFEA580C),
                          icon: Icons.visibility_rounded,
                          label: 'Conditional hero',
                        ),
                        transitionOnUserGestures: true,
                        child: _DemoSurface(
                          color: const Color(0xFFEA580C),
                          icon: Icons.visibility_rounded,
                          title: 'Conditional hero',
                          subtitle:
                              'Turn HeroMode off to compare the route transition.',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const _HeroDetailPage(
                              title: 'HeroMode Preview',
                              subtitle:
                                  'This destination uses the same tag. If HeroMode is disabled on the source, the route still opens but skips the shared-element animation.',
                              tag: 'hero-mode-preview',
                              color: Color(0xFFEA580C),
                              icon: Icons.visibility_rounded,
                              facts: <String>[
                                '`HeroMode(enabled: false)` disables all Hero widgets in that subtree.',
                                'The destination route can stay unchanged; only the source behavior changes.',
                                'This is useful for tabs, overlays, or duplicate hero tags you want to suppress temporarily.',
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.compare_arrows_rounded),
                      label: const Text('Compare With HeroMode'),
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

class _HeroDemoCard extends StatelessWidget {
  const _HeroDemoCard({
    required this.title,
    required this.description,
    required this.hero,
    required this.footer,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final Widget hero;
  final String footer;
  final String actionLabel;
  final VoidCallback onPressed;

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
            const SizedBox(height: 18),
            Center(child: hero),
            const SizedBox(height: 18),
            Text(footer, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _DemoSurface extends StatelessWidget {
  const _DemoSurface({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool tinySurface =
            (constraints.hasBoundedHeight && constraints.maxHeight < 40) ||
            (constraints.hasBoundedWidth && constraints.maxWidth < 140);
        final bool compactHeight =
            constraints.hasBoundedHeight && constraints.maxHeight < 96;
        final bool ultraCompactHeight =
            constraints.hasBoundedHeight && constraints.maxHeight < 80;
        final bool compactWidth =
            constraints.hasBoundedWidth && constraints.maxWidth < 340;

        if (tinySurface) {
          return Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 12),
              ),
            ),
          );
        }

        final double surfacePadding = ultraCompactHeight
            ? 10
            : compactHeight
            ? 12
            : 20;
        final double iconSize = ultraCompactHeight
            ? 36
            : compactHeight
            ? 42
            : 56;
        final double iconRadius = ultraCompactHeight
            ? 12
            : compactHeight
            ? 14
            : 18;
        final double spacing = ultraCompactHeight
            ? 10
            : compactHeight
            ? 12
            : 16;
        final int subtitleLines = ultraCompactHeight
            ? 0
            : compactHeight
            ? 1
            : 2;

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: EdgeInsets.all(surfacePadding),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              ultraCompactHeight
                  ? 18
                  : compactHeight
                  ? 20
                  : 28,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(iconRadius),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: ultraCompactHeight
                      ? 20
                      : compactHeight
                      ? 22
                      : 28,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: ultraCompactHeight
                            ? 16
                            : compactWidth
                            ? 18
                            : null,
                        height: ultraCompactHeight ? 1.0 : null,
                      ),
                    ),
                    if (subtitleLines > 0) ...<Widget>[
                      SizedBox(height: compactHeight ? 2 : 6),
                      Text(
                        subtitle,
                        maxLines: subtitleLines,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: compactHeight ? 1.15 : null,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroDetailPage extends StatelessWidget {
  const _HeroDetailPage({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.color,
    required this.icon,
    required this.facts,
    this.useArcTween = false,
    this.useCustomShuttle = false,
  });

  final String title;
  final String subtitle;
  final String tag;
  final Color color;
  final IconData icon;
  final List<String> facts;
  final bool useArcTween;
  final bool useCustomShuttle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Hero(
            tag: tag,
            transitionOnUserGestures: true,
            createRectTween: useArcTween
                ? (Rect? begin, Rect? end) =>
                      MaterialRectCenterArcTween(begin: begin, end: end)
                : null,
            placeholderBuilder: useCustomShuttle
                ? (BuildContext context, Size heroSize, Widget child) =>
                      Opacity(opacity: 0.18, child: child)
                : null,
            flightShuttleBuilder: useCustomShuttle
                ? (
                    BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext,
                  ) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.scale(
                          scale: Tween<double>(
                            begin: 0.96,
                            end: 1.08,
                          ).evaluate(animation),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                color,
                                Colors.tealAccent.shade400,
                                animation.value,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: _FlightBadge(icon: icon, label: title),
                    );
                  }
                : _basicFlightShuttleBuilder(
                    color: color,
                    icon: icon,
                    label: title,
                  ),
            child: _DemoSurface(
              color: color,
              icon: icon,
              title: title,
              subtitle: subtitle,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'What this route shows',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...facts.map(
            (String fact) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(fact)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Practical usage notes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Keep hero tags unique per shared element. If two unrelated widgets reuse the same tag on the same route subtree, the transition becomes ambiguous.',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hero works best when the destination element is meaningfully related to the source element, such as thumbnail-to-detail or card-to-screen.',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Use placeholderBuilder or HeroMode when layouts flicker, collapse, or contain duplicate shared elements you want to suppress temporarily.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlightBadge extends StatelessWidget {
  const _FlightBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

HeroFlightShuttleBuilder _basicFlightShuttleBuilder({
  required Color color,
  required IconData icon,
  required String label,
}) {
  return (
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _FlightBadge(icon: icon, label: label),
            ),
          ),
        ),
      ),
    );
  };
}
