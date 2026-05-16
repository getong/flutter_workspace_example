import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

class _HugeiconsSpec {
  const _HugeiconsSpec({
    required this.label,
    required this.caption,
    required this.icon,
    required this.color,
  });

  final String label;
  final String caption;
  final List<List<dynamic>> icon;
  final Color color;
}

const List<_HugeiconsSpec> _iconSpecs = <_HugeiconsSpec>[
  _HugeiconsSpec(
    label: 'Home 01',
    caption: 'Top-level destinations, launchers, and dashboard entry points.',
    icon: HugeIcons.strokeRoundedHome01,
    color: Color(0xFF2563EB),
  ),
  _HugeiconsSpec(
    label: 'Dashboard Square 01',
    caption: 'Analytics panels, information architecture, and admin shells.',
    icon: HugeIcons.strokeRoundedDashboardSquare01,
    color: Color(0xFF0F766E),
  ),
  _HugeiconsSpec(
    label: 'Search 01',
    caption: 'Global search, quick commands, and discovery tools.',
    icon: HugeIcons.strokeRoundedSearch01,
    color: Color(0xFF7C3AED),
  ),
  _HugeiconsSpec(
    label: 'Mail 01',
    caption: 'Inbox rows, notifications, and support workflows.',
    icon: HugeIcons.strokeRoundedMail01,
    color: Color(0xFFDC2626),
  ),
  _HugeiconsSpec(
    label: 'Message 01',
    caption: 'Chat surfaces, collaboration spaces, and comment streams.',
    icon: HugeIcons.strokeRoundedMessage01,
    color: Color(0xFF0891B2),
  ),
  _HugeiconsSpec(
    label: 'Notification 01',
    caption: 'System alerts, reminders, and activity center badges.',
    icon: HugeIcons.strokeRoundedNotification01,
    color: Color(0xFFD97706),
  ),
  _HugeiconsSpec(
    label: 'Shopping Bag 01',
    caption: 'Commerce actions, carts, and order overview surfaces.',
    icon: HugeIcons.strokeRoundedShoppingBag01,
    color: Color(0xFFEA580C),
  ),
  _HugeiconsSpec(
    label: 'User Circle',
    caption: 'Profiles, account menus, and identity-focused touch points.',
    icon: HugeIcons.strokeRoundedUserCircle,
    color: Color(0xFF2563EB),
  ),
  _HugeiconsSpec(
    label: 'Settings 01',
    caption: 'Configuration flows, preferences, and app management.',
    icon: HugeIcons.strokeRoundedSettings01,
    color: Color(0xFF475569),
  ),
  _HugeiconsSpec(
    label: 'Analytics 01',
    caption: 'Insight cards, charts, and progress summaries.',
    icon: HugeIcons.strokeRoundedAnalytics01,
    color: Color(0xFF16A34A),
  ),
  _HugeiconsSpec(
    label: 'Rocket 01',
    caption: 'Launch states, product highlights, and promotion banners.',
    icon: HugeIcons.strokeRoundedRocket01,
    color: Color(0xFFDB2777),
  ),
  _HugeiconsSpec(
    label: 'AI Brain 01',
    caption: 'Assistant features, smart workflows, and automation actions.',
    icon: HugeIcons.strokeRoundedAiBrain01,
    color: Color(0xFF4F46E5),
  ),
];

const List<String> _usageSnippets = <String>[
  '''
HugeIcon(
  icon: HugeIcons.strokeRoundedHome01,
  size: 28,
  color: Color(0xFF2563EB),
)
''',
  '''
FilledButton.icon(
  onPressed: () {},
  icon: HugeIcon(
    icon: HugeIcons.strokeRoundedRocket01,
    size: 20,
    color: Colors.white,
    strokeWidth: 2,
  ),
  label: const Text('Launch'),
)
''',
  '''
NavigationDestination(
  icon: HugeIcon(icon: HugeIcons.strokeRoundedDashboardSquare01),
  selectedIcon: HugeIcon(
    icon: HugeIcons.strokeRoundedDashboardSquare01,
    color: Colors.indigo,
  ),
  label: 'Dashboard',
)
''',
];

@RoutePage(name: RouteName.hugeicons)
class HugeiconsPage extends StatefulWidget {
  const HugeiconsPage({super.key});

  @override
  State<HugeiconsPage> createState() => _HugeiconsPageState();
}

class _HugeiconsPageState extends State<HugeiconsPage> {
  final TextEditingController _searchController = TextEditingController();

  double _iconSize = 28;
  double _strokeWidth = 1.8;
  String _query = '';
  int _navIndex = 0;
  _HugeiconsSpec _selected = _iconSpecs.first;

  List<_HugeiconsSpec> get _filteredIcons {
    if (_query.isEmpty) {
      return _iconSpecs;
    }

    final String normalized = _query.toLowerCase();
    return _iconSpecs
        .where((_HugeiconsSpec spec) {
          return spec.label.toLowerCase().contains(normalized) ||
              spec.caption.toLowerCase().contains(normalized);
        })
        .toList(growable: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHugeIcon(
    List<List<dynamic>> icon, {
    Color? color,
    double? size,
    double? strokeWidth,
  }) {
    return HugeIcon(
      icon: icon,
      color: color,
      size: size ?? _iconSize,
      strokeWidth: strokeWidth ?? _strokeWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<_HugeiconsSpec> visibleIcons = _filteredIcons;

    return Scaffold(
      appBar: AppBar(title: const Text('hugeicons Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'hugeicons exposes a large stroke-rounded icon set through the `HugeIcon` widget, so the same icon asset can plug into buttons, inputs, list rows, chips, and navigation surfaces.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module focuses on practical Flutter usage rather than a raw catalog: interactive sizing controls, curated icon selection, buttons, chips, `TextField`, `ListTile`, and `NavigationBar` examples.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool useColumn = constraints.maxWidth < 760;
                    final Widget preview = Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            _selected.color.withValues(alpha: 0.14),
                            colorScheme.surfaceContainerHighest,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: _buildHugeIcon(
                                  _selected.icon,
                                  color: _selected.color,
                                  size: _iconSize + 38,
                                  strokeWidth: _strokeWidth,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _selected.label,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(_selected.caption),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              _MetaPill(
                                label: 'Size ${_iconSize.toStringAsFixed(0)}',
                              ),
                              _MetaPill(
                                label:
                                    'Stroke ${_strokeWidth.toStringAsFixed(1)}',
                              ),
                              const _MetaPill(label: 'Widget: HugeIcon'),
                            ],
                          ),
                        ],
                      ),
                    );

                    final Widget controls = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Interactive controls',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Filter the curated set, then tune the rendered size and stroke width to see how the same icon reads across different UI densities.',
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Filter icons',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: _buildHugeIcon(
                                HugeIcons.strokeRoundedSearch02,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                          ),
                          onChanged: (String value) {
                            setState(() => _query = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Icon size: ${_iconSize.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium,
                        ),
                        Slider(
                          value: _iconSize,
                          min: 18,
                          max: 52,
                          divisions: 17,
                          label: _iconSize.toStringAsFixed(0),
                          onChanged: (double value) {
                            setState(() => _iconSize = value);
                          },
                        ),
                        Text(
                          'Stroke width: ${_strokeWidth.toStringAsFixed(1)}',
                          style: theme.textTheme.titleMedium,
                        ),
                        Slider(
                          value: _strokeWidth,
                          min: 1,
                          max: 3,
                          divisions: 8,
                          label: _strokeWidth.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() => _strokeWidth = value);
                          },
                        ),
                      ],
                    );

                    if (useColumn) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          preview,
                          const SizedBox(height: 20),
                          controls,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(flex: 11, child: preview),
                        const SizedBox(width: 20),
                        Expanded(flex: 9, child: controls),
                      ],
                    );
                  },
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
                    Text(
                      'Buttons and chips',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Because `HugeIcon` is a normal widget, it drops into `FilledButton.icon`, `OutlinedButton.icon`, `ActionChip`, and `Chip` without adapter code.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: () {
                            setState(() => _selected = _iconSpecs[10]);
                          },
                          icon: _buildHugeIcon(
                            HugeIcons.strokeRoundedRocket01,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text('Launch build'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _selected = _iconSpecs[3]);
                          },
                          icon: _buildHugeIcon(
                            HugeIcons.strokeRoundedMail01,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          label: const Text('Email team'),
                        ),
                        ActionChip(
                          avatar: _buildHugeIcon(
                            HugeIcons.strokeRoundedFavourite,
                            color: const Color(0xFFDB2777),
                            size: 18,
                          ),
                          label: const Text('Pin favorite'),
                          onPressed: () {
                            setState(() => _selected = _iconSpecs[6]);
                          },
                        ),
                        Chip(
                          avatar: _buildHugeIcon(
                            HugeIcons.strokeRoundedAiBrain01,
                            color: const Color(0xFF4F46E5),
                            size: 18,
                          ),
                          label: const Text('Smart mode'),
                        ),
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
                    Text(
                      'ListTile and input usage',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The package also works well in denser business UI, especially in `TextField` affordances and `ListTile` rows that need clear visual anchors.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Search projects',
                        hintText: 'Dashboard, alerts, onboarding...',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _buildHugeIcon(
                            HugeIcons.strokeRoundedSearch01,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _buildHugeIcon(
                            HugeIcons.strokeRoundedFilterHorizontal,
                            color: colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card.outlined(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _iconSpecs[1].color.withValues(
                                alpha: 0.14,
                              ),
                              child: _buildHugeIcon(
                                _iconSpecs[1].icon,
                                color: _iconSpecs[1].color,
                                size: 20,
                              ),
                            ),
                            title: const Text('Analytics workspace'),
                            subtitle: const Text(
                              'Use Hugeicons to give data-heavy pages a softer stroke language.',
                            ),
                            trailing: _buildHugeIcon(
                              HugeIcons.strokeRoundedChart,
                              color: _iconSpecs[9].color,
                              size: 20,
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _iconSpecs[5].color.withValues(
                                alpha: 0.14,
                              ),
                              child: _buildHugeIcon(
                                _iconSpecs[5].icon,
                                color: _iconSpecs[5].color,
                                size: 20,
                              ),
                            ),
                            title: const Text('Notifications center'),
                            subtitle: const Text(
                              'Stroke-rounded icons stay legible even when rows are visually compact.',
                            ),
                            trailing: _buildHugeIcon(
                              HugeIcons.strokeRoundedCalendar01,
                              color: _iconSpecs[5].color,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
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
                    Text(
                      'Navigation surfaces',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '`NavigationDestination` accepts widgets, so Hugeicons can drive tabs and destination bars while keeping the same visual language across the app.',
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: NavigationBar(
                        selectedIndex: _navIndex,
                        onDestinationSelected: (int index) {
                          setState(() => _navIndex = index);
                        },
                        destinations: <NavigationDestination>[
                          NavigationDestination(
                            icon: _buildHugeIcon(
                              HugeIcons.strokeRoundedHome01,
                              color: colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                            selectedIcon: _buildHugeIcon(
                              HugeIcons.strokeRoundedHome01,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                            label: 'Home',
                          ),
                          NavigationDestination(
                            icon: _buildHugeIcon(
                              HugeIcons.strokeRoundedDashboardSquare01,
                              color: colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                            selectedIcon: _buildHugeIcon(
                              HugeIcons.strokeRoundedDashboardSquare01,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                            label: 'Stats',
                          ),
                          NavigationDestination(
                            icon: _buildHugeIcon(
                              HugeIcons.strokeRoundedUserCircle,
                              color: colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                            selectedIcon: _buildHugeIcon(
                              HugeIcons.strokeRoundedUserCircle,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                            label: 'Profile',
                          ),
                        ],
                      ),
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
                    Text(
                      'Curated icon picker',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap an item to update the preview. ${visibleIcons.length} icon samples currently match the filter.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: visibleIcons
                          .map((_HugeiconsSpec spec) {
                            final bool isSelected = identical(spec, _selected);
                            return SizedBox(
                              width: 168,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  setState(() => _selected = spec);
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? spec.color.withValues(alpha: 0.12)
                                        : colorScheme.surfaceContainerLow,
                                    border: Border.all(
                                      color: isSelected
                                          ? spec.color
                                          : colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Center(
                                          child: _buildHugeIcon(
                                            spec.icon,
                                            color: spec.color,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        spec.label,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        spec.caption,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                    if (visibleIcons.isEmpty) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        'No curated icons match the current filter.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
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
                    Text(
                      'Usage snippets',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These snippets match the practical widget combinations demonstrated above.',
                    ),
                    const SizedBox(height: 16),
                    ..._usageSnippets.map(
                      (String snippet) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CodeSnippet(snippet: snippet),
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(label),
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.snippet});

  final String snippet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        snippet.trim(),
        style: const TextStyle(
          color: Color(0xFFE2E8F0),
          fontFamily: 'monospace',
          height: 1.45,
        ),
      ),
    );
  }
}
