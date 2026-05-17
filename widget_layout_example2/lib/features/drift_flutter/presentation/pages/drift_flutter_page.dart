import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/features/drift_flutter/data/datasources/drift_showcase_database.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

final DriftShowcaseDatabase _driftShowcaseDatabase = DriftShowcaseDatabase();

@RoutePage(name: RouteName.driftFlutter)
class DriftFlutterPage extends StatefulWidget {
  const DriftFlutterPage({super.key});

  @override
  State<DriftFlutterPage> createState() => _DriftFlutterPageState();
}

class _DriftFlutterPageState extends State<DriftFlutterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _hideCompleted = false;
  int _priority = 3;
  String _category = 'Development';

  static const List<String> _categories = <String>[
    'Development',
    'Planning',
    'UX',
    'Maintenance',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _driftShowcaseDatabase.seedDemoData();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addTodo() async {
    final String title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a title before inserting a row.')),
      );
      return;
    }

    await _driftShowcaseDatabase.addTodo(
      title: title,
      category: _category,
      priority: _priority,
      notes: _notesController.text,
    );

    _titleController.clear();
    _notesController.clear();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Inserted a new drift row.')));
  }

  Future<void> _runRenamePending() async {
    final int updated = await _driftShowcaseDatabase.renameFirstPending();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated == 0
              ? 'No pending row was available to rename.'
              : 'Renamed the highest-priority pending row.',
        ),
      ),
    );
  }

  Future<void> _clearCompleted() async {
    final int removed = await _driftShowcaseDatabase.clearCompleted();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed $removed completed row(s).')),
    );
  }

  Future<void> _resetDemo() async {
    await _driftShowcaseDatabase.resetDemo();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database reset and seeded again.')),
    );
  }

  Future<void> _markCategoryDone(String category) async {
    final int changed = await _driftShowcaseDatabase.markCategoryDone(category);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          changed == 0
              ? 'No pending rows found in $category.'
              : 'Marked $changed row(s) done in $category.',
        ),
      ),
    );
  }

  Widget _buildIntro(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'A local SQLite-backed demo powered by drift and drift_flutter.',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'This module demonstrates real Drift usage without Provider or Riverpod: '
          'table definitions, generated companions, inserts, updates, deletes, '
          'filtered watches, custom SQL summaries, and transactions.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildInsertSection(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return _SectionCard(
      title: 'Insert Rows',
      description:
          'Create data with generated companions and write directly into a local drift database.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Task title',
              hintText: 'Add a drift demo item',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Optional note stored in SQLite',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Category',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((String category) {
              final bool selected = _category == category;
              return ChoiceChip(
                label: Text(category),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _category = category;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Priority: $_priority',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _priority.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$_priority',
            onChanged: (double value) {
              setState(() {
                _priority = value.round();
              });
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: _addTodo,
                icon: const Icon(Icons.add_task),
                label: const Text('Insert Row'),
              ),
              OutlinedButton.icon(
                onPressed: () => _driftShowcaseDatabase.seedDemoData(),
                icon: const Icon(Icons.playlist_add_check_circle_outlined),
                label: const Text('Seed Demo Data'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return StreamBuilder<DriftTodoSummary>(
      stream: _driftShowcaseDatabase.watchSummary(),
      builder: (BuildContext context, AsyncSnapshot<DriftTodoSummary> snapshot) {
        final DriftTodoSummary summary =
            snapshot.data ??
            const DriftTodoSummary(
              total: 0,
              completed: 0,
              pending: 0,
              highPriority: 0,
            );

        return _SectionCard(
          title: 'Reactive Summary',
          description:
              'This summary comes from a watched custom SQL query over the same drift table.',
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: <Widget>[
              _StatTile(
                label: 'Total',
                value: summary.total.toString(),
                accentColor: const Color(0xFF1D4ED8),
              ),
              _StatTile(
                label: 'Pending',
                value: summary.pending.toString(),
                accentColor: const Color(0xFFC2410C),
              ),
              _StatTile(
                label: 'Completed',
                value: summary.completed.toString(),
                accentColor: const Color(0xFF0F766E),
              ),
              _StatTile(
                label: 'Priority >= 4',
                value: summary.highPriority.toString(),
                accentColor: const Color(0xFF7C3AED),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection() {
    return StreamBuilder<List<DriftCategoryCount>>(
      stream: _driftShowcaseDatabase.watchCategoryCounts(),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<DriftCategoryCount>> snapshot,
          ) {
            final List<DriftCategoryCount> categories =
                snapshot.data ?? const <DriftCategoryCount>[];

            return _SectionCard(
              title: 'Category Aggregation',
              description:
                  'Another watched query using grouped SQL output from Drift.',
              child: categories.isEmpty
                  ? const Text('No categories yet.')
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: categories.map((DriftCategoryCount category) {
                        return ActionChip(
                          avatar: const Icon(Icons.done_all, size: 18),
                          label: Text(
                            '${category.category}  ${category.completedCount}/${category.itemCount}',
                          ),
                          onPressed: () => _markCategoryDone(category.category),
                        );
                      }).toList(),
                    ),
            );
          },
    );
  }

  Widget _buildWatchSection(BuildContext context) {
    return _SectionCard(
      title: 'Watch And Filter Rows',
      description:
          'This list is backed by a StreamBuilder watching a filtered drift select query.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search title, category, or notes',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _hideCompleted,
            title: const Text('Hide completed rows'),
            subtitle: const Text('Filters the watched select query'),
            onChanged: (bool value) {
              setState(() {
                _hideCompleted = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildWatchedTodoList(context),
        ],
      ),
    );
  }

  Widget _buildWatchedTodoList(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return StreamBuilder<List<DriftTodoEntry>>(
      stream: _driftShowcaseDatabase.watchTodos(
        search: _searchController.text,
        hideCompleted: _hideCompleted,
      ),
      builder:
          (BuildContext context, AsyncSnapshot<List<DriftTodoEntry>> snapshot) {
            final List<DriftTodoEntry> rows =
                snapshot.data ?? const <DriftTodoEntry>[];

            if (rows.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.42,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'No rows match the current filter. Insert a row or reset the demo data.',
                ),
              );
            }

            return Column(
              children: rows
                  .map((DriftTodoEntry entry) => _buildTodoCard(context, entry))
                  .toList(),
            );
          },
    );
  }

  Widget _buildTodoCard(BuildContext context, DriftTodoEntry entry) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Checkbox(
          value: entry.completed,
          onChanged: (_) {
            _driftShowcaseDatabase.toggleCompleted(entry);
          },
        ),
        title: Text(
          entry.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            decoration: entry.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  Chip(label: Text(entry.category)),
                  Chip(label: Text('Priority ${entry.priority}')),
                  Chip(
                    label: Text(
                      entry.createdAt.toLocal().toString().split('.').first,
                    ),
                  ),
                  Chip(label: Text('UUID ${entry.uuidV7.toString()}')),
                  Chip(
                    label: Text(
                      entry.createdAtWithTimezone.toIso8601String(),
                    ),
                  ),
                ],
              ),
              if ((entry.notes ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(entry.notes!),
              ],
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              tooltip: 'Increase priority',
              onPressed: () {
                _driftShowcaseDatabase.increasePriority(
                  entry.id,
                  entry.priority,
                );
              },
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              tooltip: 'Delete row',
              onPressed: () {
                _driftShowcaseDatabase.deleteTodo(entry.id);
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMutationSection() {
    return _SectionCard(
      title: 'Mutation Actions',
      description:
          'These buttons demonstrate updates, deletes, and a transaction-based reset on the same database instance.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          FilledButton.tonalIcon(
            onPressed: _runRenamePending,
            icon: const Icon(Icons.edit_note),
            label: const Text('Rename First Pending'),
          ),
          FilledButton.tonalIcon(
            onPressed: _clearCompleted,
            icon: const Icon(Icons.cleaning_services_outlined),
            label: const Text('Clear Completed'),
          ),
          FilledButton.tonalIcon(
            onPressed: _resetDemo,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset Demo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('drift + drift_flutter Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            _buildIntro(theme),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _buildInsertSection(context),
            const SizedBox(height: 16),
            _buildSummarySection(),
            const SizedBox(height: 16),
            _buildCategorySection(),
            const SizedBox(height: 16),
            _buildWatchSection(context),
            const SizedBox(height: 16),
            _buildMutationSection(),
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
              Text('@DriftDatabase(tables: [DriftTodos])'),
              Text(
                'class DriftShowcaseDatabase extends _\$DriftShowcaseDatabase {',
              ),
              Text(
                "  DriftShowcaseDatabase(): super(driftDatabase(name: 'demo'));",
              ),
              Text('}'),
              SizedBox(height: 8),
              Text('into(driftTodos).insert(...)'),
              Text('select(driftTodos).watch()'),
              Text("customSelect('SELECT COUNT(*) ...').watchSingle()"),
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

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
