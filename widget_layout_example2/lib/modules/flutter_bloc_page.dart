import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum _ActivityFilter { all, evenOnly, oddOnly }

enum _SaveSnapshotStatus { idle, saving, success, failure }

abstract class _CounterEvent {
  const _CounterEvent();
}

class _CounterIncrementPressed extends _CounterEvent {
  const _CounterIncrementPressed();
}

class _CounterDecrementPressed extends _CounterEvent {
  const _CounterDecrementPressed();
}

class _CounterResetPressed extends _CounterEvent {
  const _CounterResetPressed();
}

class _CounterStepChanged extends _CounterEvent {
  const _CounterStepChanged(this.step);

  final int step;
}

abstract class _ActivityFilterEvent {
  const _ActivityFilterEvent();
}

class _ActivityFilterChanged extends _ActivityFilterEvent {
  const _ActivityFilterChanged(this.filter);

  final _ActivityFilter filter;
}

abstract class _SaveSnapshotEvent {
  const _SaveSnapshotEvent();
}

class _SaveSnapshotRequested extends _SaveSnapshotEvent {
  const _SaveSnapshotRequested(this.count);

  final int count;
}

class _SaveSnapshotStatusCleared extends _SaveSnapshotEvent {
  const _SaveSnapshotStatusCleared();
}

class _CounterActivity {
  const _CounterActivity({
    required this.message,
    required this.count,
    required this.time,
  });

  final String message;
  final int count;
  final DateTime time;
}

class _CounterState {
  const _CounterState({
    required this.count,
    required this.step,
    required this.activities,
  });

  const _CounterState.initial()
    : count = 0,
      step = 1,
      activities = const <_CounterActivity>[];

  final int count;
  final int step;
  final List<_CounterActivity> activities;

  bool get isEven => count.isEven;

  _CounterState copyWith({
    int? count,
    int? step,
    List<_CounterActivity>? activities,
  }) {
    return _CounterState(
      count: count ?? this.count,
      step: step ?? this.step,
      activities: activities ?? this.activities,
    );
  }
}

class _CounterRepository {
  Future<String> persistSnapshot(int count) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (count == 13) {
      throw StateError(
        '13 is treated as a simulated persistence failure in this demo.',
      );
    }
    return 'Saved counter snapshot with value $count';
  }
}

class _CounterBloc extends Bloc<_CounterEvent, _CounterState> {
  _CounterBloc() : super(const _CounterState.initial()) {
    on<_CounterIncrementPressed>(_onIncrementPressed);
    on<_CounterDecrementPressed>(_onDecrementPressed);
    on<_CounterResetPressed>(_onResetPressed);
    on<_CounterStepChanged>(_onStepChanged);
  }

  void _onIncrementPressed(
    _CounterIncrementPressed event,
    Emitter<_CounterState> emit,
  ) {
    _updateCount(
      emit,
      state.count + state.step,
      'Incremented by ${state.step}',
    );
  }

  void _onDecrementPressed(
    _CounterDecrementPressed event,
    Emitter<_CounterState> emit,
  ) {
    _updateCount(
      emit,
      state.count - state.step,
      'Decremented by ${state.step}',
    );
  }

  void _onResetPressed(
    _CounterResetPressed event,
    Emitter<_CounterState> emit,
  ) {
    emit(
      state.copyWith(
        count: 0,
        activities: _prependActivity('Reset counter to zero', 0),
      ),
    );
  }

  void _onStepChanged(_CounterStepChanged event, Emitter<_CounterState> emit) {
    emit(
      state.copyWith(
        step: event.step,
        activities: _prependActivity(
          'Changed step to ${event.step}',
          state.count,
        ),
      ),
    );
  }

  void _updateCount(
    Emitter<_CounterState> emit,
    int nextCount,
    String message,
  ) {
    emit(
      state.copyWith(
        count: nextCount,
        activities: _prependActivity(message, nextCount),
      ),
    );
  }

  List<_CounterActivity> _prependActivity(String message, int count) {
    return <_CounterActivity>[
      _CounterActivity(message: message, count: count, time: DateTime.now()),
      ...state.activities,
    ].take(18).toList();
  }
}

class _ActivityFilterBloc extends Bloc<_ActivityFilterEvent, _ActivityFilter> {
  _ActivityFilterBloc() : super(_ActivityFilter.all) {
    on<_ActivityFilterChanged>(_onFilterChanged);
  }

  void _onFilterChanged(
    _ActivityFilterChanged event,
    Emitter<_ActivityFilter> emit,
  ) {
    emit(event.filter);
  }
}

class _SaveSnapshotState {
  const _SaveSnapshotState({required this.status, this.message});

  const _SaveSnapshotState.idle()
    : status = _SaveSnapshotStatus.idle,
      message = null;

  final _SaveSnapshotStatus status;
  final String? message;

  _SaveSnapshotState copyWith({_SaveSnapshotStatus? status, String? message}) {
    return _SaveSnapshotState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class _SaveSnapshotBloc extends Bloc<_SaveSnapshotEvent, _SaveSnapshotState> {
  _SaveSnapshotBloc(this._repository) : super(const _SaveSnapshotState.idle()) {
    on<_SaveSnapshotRequested>(_onSaveSnapshotRequested);
    on<_SaveSnapshotStatusCleared>(_onSaveSnapshotStatusCleared);
  }

  final _CounterRepository _repository;

  Future<void> _onSaveSnapshotRequested(
    _SaveSnapshotRequested event,
    Emitter<_SaveSnapshotState> emit,
  ) async {
    emit(
      const _SaveSnapshotState(
        status: _SaveSnapshotStatus.saving,
        message: 'Persisting counter state...',
      ),
    );

    try {
      final String message = await _repository.persistSnapshot(event.count);
      emit(
        _SaveSnapshotState(
          status: _SaveSnapshotStatus.success,
          message: message,
        ),
      );
    } catch (error) {
      emit(
        _SaveSnapshotState(
          status: _SaveSnapshotStatus.failure,
          message: '$error',
        ),
      );
    }
  }

  void _onSaveSnapshotStatusCleared(
    _SaveSnapshotStatusCleared event,
    Emitter<_SaveSnapshotState> emit,
  ) {
    emit(const _SaveSnapshotState.idle());
  }
}

@RoutePage(name: 'FlutterBlocRoute')
class FlutterBlocPage extends StatelessWidget {
  const FlutterBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<_CounterRepository>(
      create: (BuildContext context) => _CounterRepository(),
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<_CounterBloc>(
            create: (BuildContext context) => _CounterBloc(),
          ),
          BlocProvider<_ActivityFilterBloc>(
            create: (BuildContext context) => _ActivityFilterBloc(),
          ),
          BlocProvider<_SaveSnapshotBloc>(
            create: (BuildContext context) =>
                _SaveSnapshotBloc(context.read<_CounterRepository>()),
          ),
        ],
        child: const _FlutterBlocView(),
      ),
    );
  }
}

class _FlutterBlocView extends StatelessWidget {
  const _FlutterBlocView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<_SaveSnapshotBloc, _SaveSnapshotState>(
          listenWhen:
              (_SaveSnapshotState previous, _SaveSnapshotState current) =>
                  previous.status != current.status &&
                  (current.status == _SaveSnapshotStatus.success ||
                      current.status == _SaveSnapshotStatus.failure),
          listener: (BuildContext context, _SaveSnapshotState state) {
            final bool isSuccess = state.status == _SaveSnapshotStatus.success;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'No message'),
                  backgroundColor: isSuccess ? Colors.green : Colors.red,
                ),
              );
          },
        ),
        BlocListener<_CounterBloc, _CounterState>(
          listenWhen: (_CounterState previous, _CounterState current) {
            return current.count > previous.count &&
                current.count != 0 &&
                current.count % 3 == 0;
          },
          listener: (BuildContext context, _CounterState state) {
            unawaited(_showMultipleOfThreeToast(context, state.count));
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('flutter_bloc Module')),
        body: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: const <Widget>[
              _IntroCard(),
              SizedBox(height: 16),
              _ArchitectureCard(),
              SizedBox(height: 16),
              _CounterControlsCard(),
              SizedBox(height: 16),
              _ActivityFilterCard(),
              SizedBox(height: 16),
              _SaveConsumerCard(),
              SizedBox(height: 16),
              _CodeSampleCard(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.router.replacePath('/'),
          icon: const Icon(Icons.home),
          label: const Text('Home'),
        ),
      ),
    );
  }

  Future<void> _showMultipleOfThreeToast(
    BuildContext context,
    int count,
  ) async {
    final String message = 'Count $count is a multiple of 3';
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    try {
      await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF7C3AED),
        textColor: Colors.white,
        webBgColor: 'linear-gradient(to right, #7c3aed, #a855f7)',
        webPosition: 'right',
      );
    } on MissingPluginException {
      _showToastFallbackSnackBar(messenger, message);
    } on PlatformException {
      _showToastFallbackSnackBar(messenger, message);
    } catch (_) {
      _showToastFallbackSnackBar(messenger, message);
    }
  }

  void _showToastFallbackSnackBar(
    ScaffoldMessengerState messenger,
    String message,
  ) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$message (fluttertoast fallback)'),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isEven = context.select<_CounterBloc, bool>(
      (_CounterBloc bloc) => bloc.state.isEven,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Manage UI state with providers, blocs, builders, selectors, listeners, and consumers.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `RepositoryProvider`, `MultiBlocProvider`, '
              '`Bloc`, `BlocBuilder`, `BlocSelector`, `BlocListener`, '
              '`BlocConsumer`, `context.read`, and `context.select` using a '
              'counter flow, activity filtering, and an async save operation.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                Chip(
                  label: Text(
                    'Parity via context.select: ${isEven ? 'Even' : 'Odd'}',
                  ),
                ),
                Chip(
                  label: Text(
                    'Active filter: ${context.watch<_ActivityFilterBloc>().state.name}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Interactive Architecture',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'RepositoryProvider creates a fake persistence layer. '
              'MultiBlocProvider wires three blocs into the page: one for the counter state, '
              'one for activity filtering, and one for async save status. '
              'The UI then dispatches events and reacts to state changes through several flutter_bloc widgets.',
            ),
            const SizedBox(height: 16),
            const _ArchitectureDiagram(),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureDiagram extends StatelessWidget {
  const _ArchitectureDiagram();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const <Widget>[
        _DiagramChip(label: 'RepositoryProvider', color: Color(0xFF1D4ED8)),
        _DiagramChip(label: 'MultiBlocProvider', color: Color(0xFF0F766E)),
        _DiagramChip(label: 'CounterBloc', color: Color(0xFF7C3AED)),
        _DiagramChip(label: 'ActivityFilterBloc', color: Color(0xFFB45309)),
        _DiagramChip(label: 'SaveSnapshotBloc', color: Color(0xFFDC2626)),
        _DiagramChip(
          label: 'BlocBuilder/Selector/Consumer',
          color: Color(0xFF111827),
        ),
      ],
    );
  }
}

class _DiagramChip extends StatelessWidget {
  const _DiagramChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CounterControlsCard extends StatelessWidget {
  const _CounterControlsCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BlocBuilder + BlocSelector',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The large counter panel is rebuilt with `BlocBuilder`, while the compact parity badges use `BlocSelector` so only the selected derived values are recalculated. Actions dispatch explicit events to a bloc instead of calling direct state mutator methods.',
            ),
            const SizedBox(height: 16),
            const _MultipleOfThreeNote(),
            const SizedBox(height: 16),
            BlocBuilder<_CounterBloc, _CounterState>(
              builder: (BuildContext context, _CounterState state) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Count: ${state.count}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Step: ${state.step}',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: () => context.read<_CounterBloc>().add(
                              const _CounterIncrementPressed(),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Increment'),
                          ),
                          FilledButton.icon(
                            onPressed: () => context.read<_CounterBloc>().add(
                              const _CounterDecrementPressed(),
                            ),
                            icon: const Icon(Icons.remove),
                            label: const Text('Decrement'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => context.read<_CounterBloc>().add(
                              const _CounterResetPressed(),
                            ),
                            icon: const Icon(Icons.replay),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const <Widget>[
                _SelectedValueChip(
                  label: 'Parity',
                  selector: _SelectedCounterValue.parity,
                ),
                _SelectedValueChip(
                  label: 'Absolute Value',
                  selector: _SelectedCounterValue.absoluteValue,
                ),
                _SelectedValueChip(
                  label: 'Step',
                  selector: _SelectedCounterValue.step,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _StepChooser(),
          ],
        ),
      ),
    );
  }
}

class _MultipleOfThreeNote extends StatelessWidget {
  const _MultipleOfThreeNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Extra listener: when incrementing reaches a multiple of 3, such as 3 or 6, this demo triggers fluttertoast.',
      ),
    );
  }
}

enum _SelectedCounterValue { parity, absoluteValue, step }

class _SelectedValueChip extends StatelessWidget {
  const _SelectedValueChip({required this.label, required this.selector});

  final String label;
  final _SelectedCounterValue selector;

  @override
  Widget build(BuildContext context) {
    switch (selector) {
      case _SelectedCounterValue.parity:
        return BlocSelector<_CounterBloc, _CounterState, String>(
          selector: (_CounterState state) => state.isEven ? 'Even' : 'Odd',
          builder: (BuildContext context, String value) {
            return Chip(label: Text('$label: $value'));
          },
        );
      case _SelectedCounterValue.absoluteValue:
        return BlocSelector<_CounterBloc, _CounterState, int>(
          selector: (_CounterState state) => state.count.abs(),
          builder: (BuildContext context, int value) {
            return Chip(label: Text('$label: $value'));
          },
        );
      case _SelectedCounterValue.step:
        return BlocSelector<_CounterBloc, _CounterState, int>(
          selector: (_CounterState state) => state.step,
          builder: (BuildContext context, int value) {
            return Chip(label: Text('$label: $value'));
          },
        );
    }
  }
}

class _StepChooser extends StatelessWidget {
  const _StepChooser();

  @override
  Widget build(BuildContext context) {
    final int selectedStep = context.select<_CounterBloc, int>(
      (_CounterBloc bloc) => bloc.state.step,
    );

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <int>[1, 2, 5].map((int step) {
        return ChoiceChip(
          label: Text('Step $step'),
          selected: selectedStep == step,
          onSelected: (_) =>
              context.read<_CounterBloc>().add(_CounterStepChanged(step)),
        );
      }).toList(),
    );
  }
}

class _ActivityFilterCard extends StatelessWidget {
  const _ActivityFilterCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _ActivityFilter activeFilter = context
        .watch<_ActivityFilterBloc>()
        .state;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'context.read + Filter Bloc',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The filter chips dispatch changes via `context.read`, and the activity list recomputes from the counter state plus the active filter bloc.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _ActivityFilter.values.map((_ActivityFilter filter) {
                return ChoiceChip(
                  label: Text(_filterLabel(filter)),
                  selected: activeFilter == filter,
                  onSelected: (_) => context.read<_ActivityFilterBloc>().add(
                    _ActivityFilterChanged(filter),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            BlocBuilder<_CounterBloc, _CounterState>(
              builder: (BuildContext context, _CounterState counterState) {
                final List<_CounterActivity> filteredActivities = counterState
                    .activities
                    .where((_CounterActivity activity) {
                      switch (activeFilter) {
                        case _ActivityFilter.all:
                          return true;
                        case _ActivityFilter.evenOnly:
                          return activity.count.isEven;
                        case _ActivityFilter.oddOnly:
                          return activity.count.isOdd;
                      }
                    })
                    .toList();

                if (filteredActivities.isEmpty) {
                  return const Text('No matching activity records yet.');
                }

                return Column(
                  children: filteredActivities.map((_CounterActivity activity) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Text(activity.count.toString()),
                      ),
                      title: Text(activity.message),
                      subtitle: Text(
                        '${activity.time.hour.toString().padLeft(2, '0')}:${activity.time.minute.toString().padLeft(2, '0')}:${activity.time.second.toString().padLeft(2, '0')}',
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(_ActivityFilter filter) {
    switch (filter) {
      case _ActivityFilter.all:
        return 'All';
      case _ActivityFilter.evenOnly:
        return 'Even Counts';
      case _ActivityFilter.oddOnly:
        return 'Odd Counts';
    }
  }
}

class _SaveConsumerCard extends StatelessWidget {
  const _SaveConsumerCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BlocConsumer + Async Save',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The save panel uses `BlocConsumer`: the builder renders loading and result states, while the page-level `BlocListener` shows SnackBars after success or failure. This also demonstrates dispatching one bloc event using state from another bloc.',
            ),
            const SizedBox(height: 16),
            BlocConsumer<_SaveSnapshotBloc, _SaveSnapshotState>(
              listener: (BuildContext context, _SaveSnapshotState state) {
                if (state.status == _SaveSnapshotStatus.success) {
                  context.read<_SaveSnapshotBloc>().add(
                    const _SaveSnapshotStatusCleared(),
                  );
                }
              },
              builder: (BuildContext context, _SaveSnapshotState state) {
                final int count = context.select<_CounterBloc, int>(
                  (_CounterBloc bloc) => bloc.state.count,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current count ready to save: $count',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: state.status == _SaveSnapshotStatus.saving
                              ? null
                              : () => context.read<_SaveSnapshotBloc>().add(
                                  _SaveSnapshotRequested(
                                    context.read<_CounterBloc>().state.count,
                                  ),
                                ),
                          icon: state.status == _SaveSnapshotStatus.saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            state.status == _SaveSnapshotStatus.saving
                                ? 'Saving...'
                                : 'Save Snapshot',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.read<_CounterBloc>().add(
                            const _CounterIncrementPressed(),
                          ),
                          icon: const Icon(Icons.add_chart),
                          label: const Text('Change Then Save'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(state.message ?? 'No save operation triggered yet.'),
                    const SizedBox(height: 8),
                    Text(
                      'Tip: set the counter to 13 and save to trigger the failure branch.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    const String code = r'''
RepositoryProvider(
  create: (_) => CounterRepository(),
  child: MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => CounterBloc()),
      BlocProvider(create: (_) => ActivityFilterBloc()),
      BlocProvider(
        create: (context) => SaveSnapshotBloc(
          context.read<CounterRepository>(),
        ),
      ),
    ],
    child: BlocListener<SaveSnapshotBloc, SaveSnapshotState>(
      listener: (context, state) {},
      child: BlocConsumer<SaveSnapshotBloc, SaveSnapshotState>(
        listener: (context, state) {},
        builder: (context, state) {
          final count = context.select<CounterBloc, int>(
            (bloc) => bloc.state.count,
          );
          return Text('count=$count');
        },
      ),
    ),
  ),
);
''';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Core flutter_bloc Pattern',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: SelectableText(
                code,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
