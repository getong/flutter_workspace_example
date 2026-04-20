import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WrapPage extends StatefulWidget {
  const WrapPage({super.key});

  @override
  State<WrapPage> createState() => _WrapPageState();
}

class _WrapPageState extends State<WrapPage> {
  static const List<String> _skills = <String>[
    'Flutter',
    'Dart',
    'Desktop',
    'Animations',
    'Accessibility',
    'Testing',
    'SQLite',
    'Responsive UI',
    'Tooling',
    'Performance',
  ];

  final Set<String> _selectedSkills = <String>{'Flutter', 'Responsive UI'};

  double _spacing = 12;
  double _runSpacing = 12;
  WrapAlignment _alignment = WrapAlignment.start;
  VerticalDirection _verticalDirection = VerticalDirection.down;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Wrap Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Lay out children across multiple horizontal or vertical runs.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `Wrap`, `spacing`, `runSpacing`, '
              '`alignment`, `runAlignment`, `crossAxisAlignment`, '
              '`direction`, and `verticalDirection` with practical UI examples.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Why Use Wrap',
              description:
                  'Unlike Row, Wrap automatically moves children onto a new line when space runs out.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _Pill(label: 'Short', color: colorScheme.primary),
                    _Pill(label: 'Medium length', color: colorScheme.secondary),
                    _Pill(
                      label: 'A much longer pill that wraps to a new run',
                      color: colorScheme.tertiary,
                    ),
                    _Pill(label: 'Another', color: Colors.indigo),
                    _Pill(label: 'Compact', color: Colors.deepOrange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Responsive Filter Chips',
              description:
                  'Wrap is a strong fit for chip clouds, tags, filters, and compact option selectors.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _skills.map((String skill) {
                      final bool selected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: selected,
                        onSelected: (bool value) {
                          setState(() {
                            if (value) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Selected: ${_selectedSkills.isEmpty ? 'none' : _selectedSkills.join(', ')}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Interactive Spacing',
              description:
                  'Tune spacing and run spacing to understand how Wrap distributes items across lines.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'spacing: ${_spacing.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    value: _spacing,
                    min: 0,
                    max: 28,
                    divisions: 14,
                    onChanged: (double value) {
                      setState(() {
                        _spacing = value;
                      });
                    },
                  ),
                  Text(
                    'runSpacing: ${_runSpacing.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    value: _runSpacing,
                    min: 0,
                    max: 28,
                    divisions: 14,
                    onChanged: (double value) {
                      setState(() {
                        _runSpacing = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Wrap(
                      spacing: _spacing,
                      runSpacing: _runSpacing,
                      children: List<Widget>.generate(8, (int index) {
                        return Container(
                          width: index.isEven ? 72 : 108,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors
                                .primaries[index % Colors.primaries.length]
                                .withValues(alpha: 0.86),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Item ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Alignment Modes',
              description:
                  'Wrap supports main-axis alignment for each run and additional control for runs themselves.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      ChoiceChip(
                        label: const Text('start'),
                        selected: _alignment == WrapAlignment.start,
                        onSelected: (_) {
                          setState(() {
                            _alignment = WrapAlignment.start;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('center'),
                        selected: _alignment == WrapAlignment.center,
                        onSelected: (_) {
                          setState(() {
                            _alignment = WrapAlignment.center;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('end'),
                        selected: _alignment == WrapAlignment.end,
                        onSelected: (_) {
                          setState(() {
                            _alignment = WrapAlignment.end;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('spaceBetween'),
                        selected: _alignment == WrapAlignment.spaceBetween,
                        onSelected: (_) {
                          setState(() {
                            _alignment = WrapAlignment.spaceBetween;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(
                        alpha: 0.55,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: _alignment,
                      runAlignment: WrapAlignment.spaceAround,
                      children: <Widget>[
                        _MetricTile(label: 'Users', value: '12.4k'),
                        _MetricTile(label: 'Revenue', value: '\$84k'),
                        _MetricTile(label: 'Errors', value: '19'),
                        _MetricTile(label: 'Latency', value: '122ms'),
                        _MetricTile(label: 'Deploys', value: '7'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Vertical Wrap',
              description:
                  'Wrap can also flow vertically by changing direction, which is useful for narrow side panels or compact palettes.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      ChoiceChip(
                        label: const Text('down'),
                        selected: _verticalDirection == VerticalDirection.down,
                        onSelected: (_) {
                          setState(() {
                            _verticalDirection = VerticalDirection.down;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('up'),
                        selected: _verticalDirection == VerticalDirection.up,
                        onSelected: (_) {
                          setState(() {
                            _verticalDirection = VerticalDirection.up;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 240,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 10,
                      runSpacing: 14,
                      verticalDirection: _verticalDirection,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        _ToolButton(icon: Icons.brush_outlined, label: 'Brush'),
                        _ToolButton(icon: Icons.crop_outlined, label: 'Crop'),
                        _ToolButton(icon: Icons.text_fields, label: 'Text'),
                        _ToolButton(
                          icon: Icons.palette_outlined,
                          label: 'Color',
                        ),
                        _ToolButton(
                          icon: Icons.layers_outlined,
                          label: 'Layers',
                        ),
                        _ToolButton(icon: Icons.tune, label: 'Adjust'),
                      ],
                    ),
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
              Text('Wrap('),
              Text('  spacing: 12,'),
              Text('  runSpacing: 12,'),
              Text('  children: <Widget>[...],'),
              Text(')'),
              SizedBox(height: 8),
              Text('Wrap('),
              Text('  direction: Axis.vertical,'),
              Text('  runSpacing: 14,'),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 96,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
