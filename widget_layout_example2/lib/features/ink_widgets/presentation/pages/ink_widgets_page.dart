import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.inkWidgets)
class InkWidgetsPage extends StatefulWidget {
  const InkWidgetsPage({super.key});

  @override
  State<InkWidgetsPage> createState() => _InkWidgetsPageState();
}

class _InkWidgetsPageState extends State<InkWidgetsPage> {
  int _inkWellCount = 0;
  int _inkResponseCount = 0;
  bool _highlightCard = false;
  bool _featureEnabled = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ink, InkWell, InkResponse Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Material ink effects for decorated surfaces and touch feedback.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `Ink`, `Ink.image`, `InkWell`, '
              '`InkResponse`, `overlayColor`, `onHighlightChanged`, '
              '`customBorder`, and ripple behavior on different shapes.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Why Ink Matters',
              description:
                  'Use `Ink` when you need decoration to live on a Material so '
                  'the splash paints above the background instead of hiding '
                  'under an opaque Container.',
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        colorScheme.primaryContainer,
                        colorScheme.tertiaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      setState(() {
                        _highlightCard = !_highlightCard;
                      });
                    },
                    onHighlightChanged: (bool value) {
                      setState(() {
                        _highlightCard = value;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _highlightCard
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          width: _highlightCard ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.water_drop_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Ink on top of Material decoration',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _highlightCard
                                      ? 'The ripple and highlight are active.'
                                      : 'Tap the card to see the ripple render across the decorated surface.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'InkWell Examples',
              description:
                  'Use `InkWell` for rectangular or rounded tap targets with '
                  'common gesture callbacks and ripple feedback.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'Basic Card Tap',
                    subtitle:
                        'A rounded rectangular tap target with splash, hover, and pressed states.',
                    child: Material(
                      color: Colors.transparent,
                      child: Ink(
                        width: 230,
                        height: 130,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.65,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return colorScheme.primary.withValues(
                                  alpha: 0.18,
                                );
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return colorScheme.primary.withValues(
                                  alpha: 0.08,
                                );
                              }
                              return null;
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _inkWellCount += 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.touch_app_outlined,
                                  color: colorScheme.primary,
                                ),
                                const Spacer(),
                                Text(
                                  'Tapped $_inkWellCount times',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rounded card with `InkWell`.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _DemoTile(
                    title: 'List Row Interaction',
                    subtitle:
                        'A common pattern for settings rows, inbox items, or menus.',
                    child: SizedBox(
                      width: 260,
                      child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer.withValues(
                              alpha: 0.55,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                _featureEnabled = !_featureEnabled;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    _featureEnabled
                                        ? Icons.notifications_active_outlined
                                        : Icons.notifications_off_outlined,
                                    color: colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Realtime alerts',
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _featureEnabled
                                              ? 'Enabled. Tap to disable.'
                                              : 'Disabled. Tap to enable.',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _featureEnabled,
                                    onChanged: (_) {
                                      setState(() {
                                        _featureEnabled = !_featureEnabled;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'InkResponse Examples',
              description:
                  'Use `InkResponse` when the interactive area is not a simple rectangle or when you want tighter control over shape and radius.',
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  _DemoTile(
                    title: 'Circular Ripple',
                    subtitle:
                        'A circular target, useful for icons, avatars, and floating actions.',
                    child: Material(
                      color: Colors.transparent,
                      child: InkResponse(
                        radius: 44,
                        containedInkWell: false,
                        highlightShape: BoxShape.circle,
                        splashColor: colorScheme.tertiary.withValues(
                          alpha: 0.2,
                        ),
                        onTap: () {
                          setState(() {
                            _inkResponseCount += 1;
                          });
                        },
                        child: Ink(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.tertiaryContainer,
                          ),
                          child: Icon(
                            Icons.bolt_outlined,
                            color: colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _DemoTile(
                    title: 'Custom Border',
                    subtitle:
                        'A non-rectangular splash boundary using a StadiumBorder.',
                    child: Material(
                      color: Colors.transparent,
                      child: InkResponse(
                        containedInkWell: true,
                        customBorder: const StadiumBorder(),
                        splashColor: colorScheme.primary.withValues(
                          alpha: 0.16,
                        ),
                        highlightColor: colorScheme.primary.withValues(
                          alpha: 0.06,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('InkResponse action triggered.'),
                            ),
                          );
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(
                              alpha: 0.82,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.send_outlined,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Send update',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Ink.image Composition',
              description:
                  'Use `Ink.image` when the surface itself is an image but you still want proper Material ripples on top.',
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(24),
                child: Ink.image(
                  image: const AssetImage(
                    'assets/images/image_module_demo.png',
                  ),
                  height: 220,
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Ink.image tapped. InkResponse total: $_inkResponseCount',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[
                            Colors.black.withValues(alpha: 0.58),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Ink.image keeps the ripple visible over image content.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
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

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            height: 1.5,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Material('),
              Text('  child: Ink('),
              Text('    decoration: ... ,'),
              Text('    child: InkWell(onTap: ...),'),
              Text('  ),'),
              Text(')'),
              SizedBox(height: 8),
              Text('InkResponse('),
              Text('  customBorder: StadiumBorder(),'),
              Text('  child: Ink(...),'),
              Text(')'),
            ],
          ),
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

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: child),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}
