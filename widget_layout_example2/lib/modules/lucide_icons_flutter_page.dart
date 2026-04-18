import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage(name: 'LucideIconsFlutterRoute')
class LucideIconsFlutterPage extends StatefulWidget {
  const LucideIconsFlutterPage({super.key});

  @override
  State<LucideIconsFlutterPage> createState() => _LucideIconsFlutterPageState();
}

class _LucideIconsFlutterPageState extends State<LucideIconsFlutterPage> {
  final TextEditingController _searchController = TextEditingController();

  static const List<_LucideIconSpec> _icons = <_LucideIconSpec>[
    _LucideIconSpec('activity', LucideIcons.activity, 'Status pulse'),
    _LucideIconSpec('search', LucideIcons.search, 'Search UI'),
    _LucideIconSpec('mail', LucideIcons.mail, 'Email CTA'),
    _LucideIconSpec('layoutGrid', LucideIcons.layoutGrid, 'Dashboard layout'),
    _LucideIconSpec('palette', LucideIcons.palette, 'Design tools'),
    _LucideIconSpec('monitor', LucideIcons.monitor, 'Desktop surface'),
    _LucideIconSpec('panelLeft', LucideIcons.panelLeft, 'Sidebar'),
    _LucideIconSpec('serverCog', LucideIcons.serverCog, 'Backend settings'),
    _LucideIconSpec('rocket', LucideIcons.rocket, 'Launch action'),
    _LucideIconSpec('sparkles', LucideIcons.sparkles, 'Highlight'),
  ];

  double _iconSize = 30;
  String _query = '';
  _LucideIconSpec _selected = _icons[0];

  List<_LucideIconSpec> get _filteredIcons {
    if (_query.isEmpty) {
      return _icons;
    }

    final String normalized = _query.toLowerCase();
    return _icons
        .where((_LucideIconSpec icon) {
          return icon.label.toLowerCase().contains(normalized) ||
              icon.description.toLowerCase().contains(normalized);
        })
        .toList(growable: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectIcon(_LucideIconSpec icon) {
    setState(() {
      _selected = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('lucide_icons_flutter Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'lucide_icons_flutter exposes the Lucide icon set as Flutter `IconData`, including alternate stroke weights and RTL-aware directional variants.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates regular icons, heavier and lighter stroke families, `Dir` icons for RTL support, icons inside buttons and chips, plus a searchable icon grid.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Search and sizing',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Filter a curated subset of Lucide icons and adjust their display size.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Filter icons',
                      prefixIcon: const Icon(LucideIcons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(LucideIcons.check),
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
                    max: 44,
                    divisions: 13,
                    label: _iconSize.toStringAsFixed(0),
                    onChanged: (double value) {
                      setState(() => _iconSize = value);
                    },
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
                    'App-style usage',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lucide icons work anywhere Flutter expects `IconData`: buttons, chips, navigation affordances, and list tiles.',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () => _selectIcon(_icons[8]),
                        icon: const Icon(LucideIcons.rocket),
                        label: const Text('Deploy'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _selectIcon(_icons[2]),
                        icon: const Icon(LucideIcons.mail),
                        label: const Text('Email team'),
                      ),
                      ActionChip(
                        avatar: const Icon(LucideIcons.sparkles, size: 18),
                        label: const Text('Featured'),
                        onPressed: () => _selectIcon(_icons[9]),
                      ),
                      Chip(
                        avatar: const Icon(LucideIcons.serverCog, size: 18),
                        label: const Text('Backend'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          _selected.icon,
                          size: _iconSize + 8,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _selected.label,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(_selected.description),
                              const SizedBox(height: 8),
                              Text(
                                'codePoint: ${_selected.icon.codePoint}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
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
                    'Stroke weight variants',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The package publishes separate font families such as `activity100` through `activity600`, which gives direct control over stroke thickness.',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      _WeightChip(label: '100', icon: LucideIcons.activity100),
                      _WeightChip(label: '200', icon: LucideIcons.activity200),
                      _WeightChip(label: '300', icon: LucideIcons.activity300),
                      _WeightChip(label: '400', icon: LucideIcons.activity400),
                      _WeightChip(label: '500', icon: LucideIcons.activity500),
                      _WeightChip(label: '600', icon: LucideIcons.activity600),
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
                    'Directional icons in RTL',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '`Dir` variants opt into `matchTextDirection`, which matters for arrows and other directional glyphs.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: _DirectionPreview(
                            title: 'Plain icon in RTL',
                            icon: LucideIcons.aArrowDown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: _DirectionPreview(
                            title: 'Dir icon in RTL',
                            icon: LucideIcons.aArrowDownDir,
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
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Searchable icon grid',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Filtered icons: ${_filteredIcons.length} / ${_icons.length}',
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredIcons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.55,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      final _LucideIconSpec icon = _filteredIcons[index];
                      final bool selected = identical(icon, _selected);
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _selectIcon(icon),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                            ),
                            color: selected
                                ? colorScheme.primaryContainer
                                : colorScheme.surface,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  icon.icon,
                                  size: _iconSize,
                                  color: selected
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.primary,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      icon.label,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      icon.description,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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

class _LucideIconSpec {
  const _LucideIconSpec(this.label, this.icon, this.description);

  final String label;
  final IconData icon;
  final String description;
}

class _WeightChip extends StatelessWidget {
  const _WeightChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text('activity$label'));
  }
}

class _DirectionPreview extends StatelessWidget {
  const _DirectionPreview({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: Icon(icon, size: 34)),
        ],
      ),
    );
  }
}
