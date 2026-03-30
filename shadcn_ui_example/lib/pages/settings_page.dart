import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../widgets/demo_page_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _projectController = TextEditingController(
    text: 'Row + Column Lab',
  );

  static const Map<String, String> _environments = <String, String>{
    'prototype': 'Prototype',
    'staging': 'Staging',
    'production': 'Production',
  };

  String _environment = 'staging';
  bool _compactNavigation = true;
  bool _prefetchSlugs = true;

  double get _completion {
    double score = 0.35;
    if (_compactNavigation) {
      score += 0.25;
    }
    if (_prefetchSlugs) {
      score += 0.25;
    }
    if (_environment == 'production') {
      score += 0.15;
    }
    return score.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _projectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return DemoPageScaffold(
      eyebrow: 'Stateful page',
      title: 'UI Settings Playground',
      description:
          'These controls are local-only state. The goal is to show how shadcn_ui '
          'form components fit into routed pages without needing a backend.',
      actions: <Widget>[
        ShadButton(
          onPressed: () => context.go('/examples'),
          child: const Text('Back To Examples'),
        ),
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stacked = constraints.maxWidth < 940;
          final Widget formCard = ShadCard(
            title: const Text('App preferences'),
            description: const Text(
              'Pretend these settings shape the router shell for a production app.',
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Project name', style: theme.textTheme.small),
                  const SizedBox(height: 8),
                  ShadInput(
                    controller: _projectController,
                    placeholder: const Text('Project name'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Text('Environment', style: theme.textTheme.small),
                  const SizedBox(height: 8),
                  ShadSelect<String>(
                    initialValue: _environment,
                    placeholder: const Text('Select environment'),
                    options: _environments.entries
                        .map(
                          (MapEntry<String, String> entry) => ShadOption(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(growable: false),
                    selectedOptionBuilder:
                        (BuildContext context, String value) {
                          return Text(_environments[value]!);
                        },
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _environment = value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _SwitchRow(
                    title: 'Compact navigation rail',
                    subtitle: 'Prefer a denser shell for wider displays.',
                    value: _compactNavigation,
                    onChanged: (bool value) {
                      setState(() => _compactNavigation = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _SwitchRow(
                    title: 'Prefetch detail slugs',
                    subtitle: 'Warm likely routes after the catalog loads.',
                    value: _prefetchSlugs,
                    onChanged: (bool value) {
                      setState(() => _prefetchSlugs = value);
                    },
                  ),
                ],
              ),
            ),
          );

          final Widget summaryColumn = Column(
            children: <Widget>[
              ShadCard(
                title: const Text('Preview'),
                description: const Text(
                  'A lightweight summary card driven by the local widget state.',
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _projectController.text.isEmpty
                            ? 'Unnamed project'
                            : _projectController.text,
                        style: theme.textTheme.h4,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          ShadBadge(child: Text(_environments[_environment]!)),
                          ShadBadge.secondary(
                            child: Text(
                              _compactNavigation
                                  ? 'Compact shell'
                                  : 'Relaxed shell',
                            ),
                          ),
                          ShadBadge.outline(
                            child: Text(
                              _prefetchSlugs
                                  ? 'Slug prefetch on'
                                  : 'Slug prefetch off',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShadCard(
                title: const Text('Completion'),
                description: const Text(
                  'A progress bar makes the page state immediately legible.',
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ShadProgress(value: _completion),
                      const SizedBox(height: 8),
                      Text(
                        '${(_completion * 100).round()}% configured',
                        style: theme.textTheme.small,
                      ),
                      const SizedBox(height: 16),
                      ShadButton.outline(
                        onPressed: () => context.go('/layouts/row-chips'),
                        child: const Text('Open Example Using This Shell'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

          if (stacked) {
            return Column(
              children: <Widget>[
                formCard,
                const SizedBox(height: 16),
                summaryColumn,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 3, child: formCard),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: summaryColumn),
            ],
          );
        },
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.textTheme.small),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.muted),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ShadSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
