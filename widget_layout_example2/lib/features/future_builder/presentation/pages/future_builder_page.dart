import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.futureBuilder)
class FutureBuilderPage extends StatefulWidget {
  const FutureBuilderPage({super.key});

  @override
  State<FutureBuilderPage> createState() => _FutureBuilderPageState();
}

class _FutureBuilderPageState extends State<FutureBuilderPage> {
  final _FutureBuilderRepository _repository = _FutureBuilderRepository();

  DemoResultMode _resultMode = DemoResultMode.success;
  late Future<String> _headlineFuture;
  late Future<List<String>> _taskFuture;
  late Future<_DashboardSummary> _summaryFuture;
  late Future<DateTime> _lastSyncedFuture;

  @override
  void initState() {
    super.initState();
    _headlineFuture = _repository.loadHeadline();
    _taskFuture = _repository.loadTasks(mode: _resultMode);
    _summaryFuture = _repository.loadDashboardSummary();
    _lastSyncedFuture = _repository.loadLastSyncedAt();
  }

  void _refreshAll() {
    setState(() {
      _headlineFuture = _repository.loadHeadline();
      _taskFuture = _repository.loadTasks(mode: _resultMode);
      _summaryFuture = _repository.loadDashboardSummary();
      _lastSyncedFuture = _repository.loadLastSyncedAt();
    });
  }

  void _updateResultMode(DemoResultMode? nextMode) {
    if (nextMode == null || nextMode == _resultMode) {
      return;
    }

    setState(() {
      _resultMode = nextMode;
      _taskFuture = _repository.loadTasks(mode: nextMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureBuilder Module'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh examples',
            onPressed: _refreshAll,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FutureBuilder rebuilds a section of the widget tree when a Future changes state. This page shows common patterns you will use in Flutter apps.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Each card below demonstrates a different FutureBuilder flow: loading, success, empty, error, refresh, and combining multiple futures.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _InfoCard(
              title: 'Why store futures in State?',
              description:
                  'Creating the Future in initState avoids firing a new async request every time build runs. When you actually want a reload, replace the Future inside setState.',
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Useful snapshot fields',
              description:
                  'connectionState tells you whether the Future is waiting or done. hasData and hasError help branch your UI safely before reading data or error.',
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: '1. Basic async text',
              subtitle:
                  'A simple Future<String> example with loading, success, and a small status summary.',
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _headlineFuture,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return _ExampleCard(
                  title: 'Delayed headline',
                  builderSource:
                      'FutureBuilder<String>(future: _headlineFuture, builder: ...)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _SnapshotStatusRow(snapshot: snapshot),
                      const SizedBox(height: 16),
                      if (snapshot.connectionState != ConnectionState.done)
                        const _LoadingPanel(
                          message: 'Fetching a message from a fake backend...',
                        )
                      else if (snapshot.hasError)
                        _ErrorPanel(error: snapshot.error)
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            snapshot.data ?? 'No message received.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: '2. Empty and error states',
              subtitle:
                  'One FutureBuilder<List<String>> that changes behavior based on a dropdown.',
            ),
            const SizedBox(height: 12),
            _ExampleCard(
              title: 'Task list request',
              builderSource:
                  'FutureBuilder<List<String>>(future: _taskFuture, builder: ...)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Select response type',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<DemoResultMode>(
                        value: _resultMode,
                        isExpanded: true,
                        items: DemoResultMode.values
                            .map(
                              (DemoResultMode mode) =>
                                  DropdownMenuItem<DemoResultMode>(
                                    value: mode,
                                    child: Text(mode.label),
                                  ),
                            )
                            .toList(),
                        onChanged: _updateResultMode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<String>>(
                    future: _taskFuture,
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<List<String>> snapshot,
                        ) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _SnapshotStatusRow(snapshot: snapshot),
                              const SizedBox(height: 16),
                              if (snapshot.connectionState !=
                                  ConnectionState.done)
                                const _LoadingPanel(
                                  message: 'Loading your task list...',
                                )
                              else if (snapshot.hasError)
                                _ErrorPanel(error: snapshot.error)
                              else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty)
                                const _EmptyPanel(
                                  message:
                                      'The request finished successfully, but there is nothing to show.',
                                )
                              else
                                Column(
                                  children: snapshot.data!
                                      .map(
                                        (String task) => ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(
                                            Icons.check_circle_outline,
                                          ),
                                          title: Text(task),
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          );
                        },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: '3. Combining multiple futures',
              subtitle:
                  'This wraps Future.wait inside a repository method and renders a small dashboard summary.',
            ),
            const SizedBox(height: 12),
            FutureBuilder<_DashboardSummary>(
              future: _summaryFuture,
              builder: (BuildContext context, AsyncSnapshot<_DashboardSummary> snapshot) {
                return _ExampleCard(
                  title: 'Dashboard summary',
                  builderSource:
                      'FutureBuilder<_DashboardSummary>(future: _summaryFuture, builder: ...)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _SnapshotStatusRow(snapshot: snapshot),
                      const SizedBox(height: 16),
                      if (snapshot.connectionState != ConnectionState.done)
                        const _LoadingPanel(
                          message:
                              'Aggregating profile, analytics, and sync data...',
                        )
                      else if (snapshot.hasError)
                        _ErrorPanel(error: snapshot.error)
                      else if (snapshot.hasData)
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            _MetricTile(
                              label: 'Pending tasks',
                              value: '${snapshot.data!.pendingTasks}',
                              color: Colors.teal,
                            ),
                            _MetricTile(
                              label: 'Completion rate',
                              value:
                                  '${(snapshot.data!.completionRate * 100).toStringAsFixed(0)}%',
                              color: Colors.orange,
                            ),
                            _MetricTile(
                              label: 'Next reminder',
                              value: snapshot.data!.nextReminder,
                              color: Colors.pink,
                            ),
                          ],
                        )
                      else
                        const _EmptyPanel(
                          message: 'No summary data was returned.',
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: '4. Refreshing one Future only',
              subtitle:
                  'This FutureBuilder<DateTime> updates independently from the other examples.',
            ),
            const SizedBox(height: 12),
            _ExampleCard(
              title: 'Last sync time',
              builderSource:
                  'FutureBuilder<DateTime>(future: _lastSyncedFuture, builder: ...)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _lastSyncedFuture = _repository.loadLastSyncedAt();
                      });
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('Refresh timestamp only'),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<DateTime>(
                    future: _lastSyncedFuture,
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<DateTime> snapshot,
                        ) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _SnapshotStatusRow(snapshot: snapshot),
                              const SizedBox(height: 16),
                              if (snapshot.connectionState !=
                                  ConnectionState.done)
                                const _LoadingPanel(
                                  message:
                                      'Checking the latest sync timestamp...',
                                )
                              else if (snapshot.hasError)
                                _ErrorPanel(error: snapshot.error)
                              else if (snapshot.hasData)
                                Text(
                                  'Last synced at: ${_formatTime(snapshot.data!)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                )
                              else
                                const _EmptyPanel(
                                  message: 'The timestamp is unavailable.',
                                ),
                            ],
                          );
                        },
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

  String _formatTime(DateTime value) {
    final String hour = value.hour.toString().padLeft(2, '0');
    final String minute = value.minute.toString().padLeft(2, '0');
    final String second = value.second.toString().padLeft(2, '0');
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} $hour:$minute:$second';
  }
}

enum DemoResultMode {
  success('Success data'),
  empty('Empty data'),
  error('Error state');

  const DemoResultMode(this.label);

  final String label;
}

class _FutureBuilderRepository {
  Future<String> loadHeadline() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return 'FutureBuilder is best when you want UI that reacts to one async computation.';
  }

  Future<List<String>> loadTasks({required DemoResultMode mode}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    switch (mode) {
      case DemoResultMode.success:
        return const <String>[
          'Warm up the cache before the user opens the screen',
          'Request profile data from the API',
          'Render a skeleton while waiting for the response',
          'Handle empty and error results explicitly',
        ];
      case DemoResultMode.empty:
        return const <String>[];
      case DemoResultMode.error:
        throw Exception('Server returned HTTP 500 for /tasks');
    }
  }

  Future<_DashboardSummary> loadDashboardSummary() async {
    final List<Object> values = await Future.wait<Object>(<Future<Object>>[
      _loadPendingTasksCount(),
      _loadCompletionRate(),
      _loadNextReminder(),
    ]);

    return _DashboardSummary(
      pendingTasks: values[0] as int,
      completionRate: values[1] as double,
      nextReminder: values[2] as String,
    );
  }

  Future<DateTime> loadLastSyncedAt() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return DateTime.now();
  }

  Future<int> _loadPendingTasksCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return 7;
  }

  Future<double> _loadCompletionRate() async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    return 0.84;
  }

  Future<String> _loadNextReminder() async {
    await Future<void>.delayed(const Duration(milliseconds: 950));
    return '14:30 review';
  }
}

class _DashboardSummary {
  const _DashboardSummary({
    required this.pendingTasks,
    required this.completionRate,
    required this.nextReminder,
  });

  final int pendingTasks;
  final double completionRate;
  final String nextReminder;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.builderSource,
    required this.child,
  });

  final String title;
  final String builderSource;
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
            Text(
              builderSource,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          ],
        ),
      ),
    );
  }
}

class _SnapshotStatusRow<T> extends StatelessWidget {
  const _SnapshotStatusRow({required this.snapshot});

  final AsyncSnapshot<T> snapshot;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        _StatusChip(
          label: 'connectionState: ${snapshot.connectionState.name}',
          color: Colors.blueGrey,
        ),
        _StatusChip(label: 'hasData: ${snapshot.hasData}', color: Colors.green),
        _StatusChip(label: 'hasError: ${snapshot.hasError}', color: Colors.red),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(message)),
      ],
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
