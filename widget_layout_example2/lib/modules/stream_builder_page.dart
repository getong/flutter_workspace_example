import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.streamBuilder)
class StreamBuilderPage extends StatefulWidget {
  const StreamBuilderPage({super.key});

  @override
  State<StreamBuilderPage> createState() => _StreamBuilderPageState();
}

class _StreamBuilderPageState extends State<StreamBuilderPage> {
  final _StreamBuilderRepository _repository = _StreamBuilderRepository();
  final StreamController<List<String>> _activityController =
      StreamController<List<String>>.broadcast();

  late Stream<int> _tickerStream;
  late Stream<_ConnectionPhase> _phaseStream;
  late Stream<double> _cpuStream;

  List<String> _activityEvents = <String>[];
  int _activityCount = 0;

  @override
  void initState() {
    super.initState();
    _restartDemoStreams();
    _activityController.add(_activityEvents);
  }

  @override
  void dispose() {
    _activityController.close();
    super.dispose();
  }

  void _restartDemoStreams() {
    _tickerStream = _repository.buildTickerStream().asBroadcastStream();
    _phaseStream = _repository.buildConnectionPhaseStream().asBroadcastStream();
    _cpuStream = _repository.buildCpuUsageStream().asBroadcastStream();
  }

  void _restartTickerStream() {
    setState(() {
      _tickerStream = _repository.buildTickerStream().asBroadcastStream();
    });
  }

  void _restartPhaseStream() {
    setState(() {
      _phaseStream = _repository
          .buildConnectionPhaseStream()
          .asBroadcastStream();
    });
  }

  void _restartCpuStream() {
    setState(() {
      _cpuStream = _repository.buildCpuUsageStream().asBroadcastStream();
    });
  }

  void _refreshTimedStreams() {
    setState(_restartDemoStreams);
  }

  void _pushActivity() {
    _activityCount += 1;
    _activityEvents = <String>[
      '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')} event $_activityCount',
      ..._activityEvents,
    ];
    _activityController.add(_activityEvents);
  }

  void _emitActivityError() {
    _activityController.addError(
      Exception('Simulated stream failure while listening for activities'),
    );
  }

  void _clearActivities() {
    _activityEvents = <String>[];
    _activityController.add(_activityEvents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamBuilder Module'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Restart timed streams',
            onPressed: _refreshTimedStreams,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const Text(
            'StreamBuilder listens to a Stream and rebuilds whenever a new event arrives. It is useful for timers, sockets, sensors, controllers, and any data source that changes over time.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates single-value updates, active multi-event streams, initialData, done states, and manual StreamController usage. Each timed example below also has its own restart button so you can trigger emissions again.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const _InfoCard(
            title: 'When to use StreamBuilder',
            description:
                'Use FutureBuilder for one async result. Use StreamBuilder when values continue arriving over time or when you need to react to a sequence of async events.',
          ),
          const SizedBox(height: 16),
          const _InfoCard(
            title: 'Important snapshot states',
            description:
                'A stream commonly moves through waiting, active, and done. During active, the builder may run many times with new data while the stream stays open.',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: '1. Periodic counter stream',
            subtitle: 'A basic Stream<int> example driven by Stream.periodic.',
          ),
          const SizedBox(height: 12),
          StreamBuilder<int>(
            stream: _tickerStream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return _ExampleCard(
                title: 'Tick stream',
                builderSource:
                    'StreamBuilder<int>(stream: _tickerStream, builder: ...)',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: _restartTickerStream,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Restart tick stream'),
                    ),
                    const SizedBox(height: 16),
                    _SnapshotStatusRow(snapshot: snapshot),
                    const SizedBox(height: 16),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const _LoadingPanel(
                        message: 'Waiting for the first tick...',
                      )
                    else if (snapshot.hasError)
                      _ErrorPanel(error: snapshot.error)
                    else if (snapshot.hasData)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Current tick: ${snapshot.data}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      )
                    else
                      const _EmptyPanel(
                        message: 'The stream finished without values.',
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: '2. Progress through multiple states',
            subtitle:
                'An async* generator that yields several connection phases before completing.',
          ),
          const SizedBox(height: 12),
          StreamBuilder<_ConnectionPhase>(
            stream: _phaseStream,
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<_ConnectionPhase> snapshot,
                ) {
                  return _ExampleCard(
                    title: 'Connection phases',
                    builderSource:
                        'StreamBuilder<_ConnectionPhase>(stream: _phaseStream, builder: ...)',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        OutlinedButton.icon(
                          onPressed: _restartPhaseStream,
                          icon: const Icon(Icons.sync),
                          label: const Text('Restart phase stream'),
                        ),
                        const SizedBox(height: 16),
                        _SnapshotStatusRow(snapshot: snapshot),
                        const SizedBox(height: 16),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const _LoadingPanel(
                            message: 'Preparing to connect...',
                          )
                        else if (snapshot.hasError)
                          _ErrorPanel(error: snapshot.error)
                        else if (snapshot.hasData)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: snapshot.data!.color.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: snapshot.data!.color.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  snapshot.data!.icon,
                                  color: snapshot.data!.color,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(snapshot.data!.description),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const _EmptyPanel(
                            message:
                                'The stream completed without a phase update.',
                          ),
                      ],
                    ),
                  );
                },
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: '3. initialData for immediate UI',
            subtitle:
                'This StreamBuilder<double> shows a placeholder value before the first event arrives.',
          ),
          const SizedBox(height: 12),
          StreamBuilder<double>(
            stream: _cpuStream,
            initialData: 18,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              final double usage = snapshot.data ?? 0;
              final Color color = usage < 45
                  ? Colors.green
                  : usage < 75
                  ? Colors.orange
                  : Colors.red;

              return _ExampleCard(
                title: 'CPU usage monitor',
                builderSource:
                    'StreamBuilder<double>(stream: _cpuStream, initialData: 18, builder: ...)',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: _restartCpuStream,
                      icon: const Icon(Icons.memory),
                      label: const Text('Restart CPU stream'),
                    ),
                    const SizedBox(height: 16),
                    _SnapshotStatusRow(snapshot: snapshot),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: usage / 100,
                        minHeight: 16,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.18),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Usage: ${usage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: '4. Manual StreamController events',
            subtitle:
                'This example pushes values and errors into a controller-backed stream.',
          ),
          const SizedBox(height: 12),
          _ExampleCard(
            title: 'Interactive activity feed',
            builderSource:
                'StreamBuilder<List<String>>(stream: _activityController.stream, initialData: const <String>[], builder: ...)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _pushActivity,
                      icon: const Icon(Icons.add),
                      label: const Text('Add event'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _emitActivityError,
                      icon: const Icon(Icons.warning_amber_outlined),
                      label: const Text('Emit error'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _clearActivities,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear events'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                StreamBuilder<List<String>>(
                  stream: _activityController.stream,
                  initialData: const <String>[],
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<List<String>> snapshot,
                      ) {
                        final List<String> events =
                            snapshot.data ?? const <String>[];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _SnapshotStatusRow(snapshot: snapshot),
                            const SizedBox(height: 16),
                            if (snapshot.hasError)
                              _ErrorPanel(error: snapshot.error),
                            if (!snapshot.hasError && events.isEmpty)
                              const _EmptyPanel(
                                message:
                                    'No events yet. Press "Add event" to push data into the stream.',
                              ),
                            if (events.isNotEmpty)
                              Column(
                                children: events
                                    .map(
                                      (String event) => ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(Icons.bolt),
                                        title: Text(event),
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

class _StreamBuilderRepository {
  Stream<int> buildTickerStream() {
    return Stream<int>.periodic(
      const Duration(milliseconds: 700),
      (int index) => index + 1,
    ).take(6);
  }

  Stream<_ConnectionPhase> buildConnectionPhaseStream() async* {
    yield const _ConnectionPhase(
      title: 'Connecting',
      description: 'Opening the socket to the backend service.',
      icon: Icons.wifi_tethering,
      color: Colors.indigo,
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));
    yield const _ConnectionPhase(
      title: 'Authorizing',
      description: 'Validating the token and loading session metadata.',
      icon: Icons.verified_user,
      color: Colors.orange,
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));
    yield const _ConnectionPhase(
      title: 'Subscribed',
      description: 'The channel is live and ready to receive updates.',
      icon: Icons.check_circle,
      color: Colors.green,
    );
  }

  Stream<double> buildCpuUsageStream() async* {
    const List<double> values = <double>[26, 34, 58, 42, 73, 61];
    for (final double value in values) {
      await Future<void>.delayed(const Duration(milliseconds: 550));
      yield value;
    }
  }
}

class _ConnectionPhase {
  const _ConnectionPhase({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
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
