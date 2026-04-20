import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ThemeDataVisualDensityPage extends StatelessWidget {
  const ThemeDataVisualDensityPage({super.key});

  static const VisualDensity _explicitStandard = VisualDensity(
    horizontal: 0,
    vertical: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ThemeData VisualDensity Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ThemeData.visualDensity adjusts the default spacing and hit area '
              'for many Material widgets. Use it at the app level or override '
              'it for a subtree when you want denser admin tooling or more '
              'comfortable touch layouts.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _VisualDensityCard(
              title: 'Standard Density With ThemeData',
              description:
                  'The practical current API is either visualDensity: '
                  'VisualDensity.standard or an explicit zero/zero density. '
                  'Both examples below render the same spacing.',
              api:
                  'Uses: ThemeData(visualDensity: VisualDensity.standard) and ThemeData(visualDensity: VisualDensity(horizontal: 0, vertical: 0))',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DensityPreviewPanel(
                    title: 'VisualDensity.standard',
                    note: 'Built-in standard profile',
                    density: VisualDensity.standard,
                  ),
                  _DensityPreviewPanel(
                    title: 'Explicit Standard',
                    note: 'Equivalent to horizontal: 0, vertical: 0',
                    density: _explicitStandard,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _VisualDensityCard(
              title: 'Compact, Standard, Comfortable',
              description:
                  'Predefined profiles make it easy to compare how the same '
                  'controls behave with tighter or looser spacing.',
              api:
                  'Uses: VisualDensity.compact, VisualDensity.standard, VisualDensity.comfortable',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DensityPreviewPanel(
                    title: 'Compact',
                    note: 'Dense toolbar and settings UI',
                    density: VisualDensity.compact,
                  ),
                  _DensityPreviewPanel(
                    title: 'Standard',
                    note: 'Balanced default Material spacing',
                    density: VisualDensity.standard,
                  ),
                  _DensityPreviewPanel(
                    title: 'Comfortable',
                    note: 'Airier spacing for touch-first surfaces',
                    density: VisualDensity.comfortable,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _VisualDensityCard(
              title: 'Local Subtree Override',
              description:
                  'You do not have to change the whole app. Wrap a subtree in '
                  'Theme and copy the parent ThemeData with a different '
                  'visualDensity.',
              api:
                  'Uses: Theme(data: Theme.of(context).copyWith(visualDensity: ...))',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Outer page stays standard, but the inline action bar below '
                    'is made compact.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Icon(Icons.folder_open_outlined),
                          ),
                          title: Text('Workspace Files'),
                          subtitle: Text(
                            'The surrounding content uses standard density.',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(visualDensity: VisualDensity.compact),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              FilledButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                label: const Text('New'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download_outlined),
                                label: const Text('Export'),
                              ),
                              IconButton.filledTonal(
                                onPressed: () {},
                                icon: const Icon(Icons.filter_list),
                                tooltip: 'Filter',
                              ),
                              Chip(
                                label: const Text('3 selected'),
                                avatar: const Icon(Icons.check_circle_outline),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
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

class _VisualDensityCard extends StatelessWidget {
  const _VisualDensityCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
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
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _DensityPreviewPanel extends StatelessWidget {
  const _DensityPreviewPanel({
    required this.title,
    required this.note,
    required this.density,
  });

  final String title;
  final String note;
  final VisualDensity density;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(visualDensity: density),
      child: Builder(
        builder: (BuildContext context) {
          final ThemeData theme = Theme.of(context);
          return Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(note, style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Icon(Icons.tune)),
                  title: Text('Project Settings'),
                  subtitle: Text('ListTile spacing reacts to density'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Archive'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const <Widget>[
                    Chip(label: Text('beta')),
                    Chip(label: Text('desktop')),
                  ],
                ),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Branch name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
