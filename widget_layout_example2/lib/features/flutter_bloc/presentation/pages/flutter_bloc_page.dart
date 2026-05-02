import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:widget_layout_example2/app_navigation.dart';

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

class _BlocReferenceRepository {
  const _BlocReferenceRepository();

  List<String> get widgetNames => const <String>[
    'RepositoryProvider',
    'MultiRepositoryProvider',
    'BlocProvider',
    'MultiBlocProvider',
    'BlocBuilder',
    'BlocSelector',
    'BlocListener',
    'MultiBlocListener',
    'BlocConsumer',
  ];
}

class _ProviderNarrativeRepository {
  const _ProviderNarrativeRepository();

  String describe({required int count, required _ActivityFilter filter}) {
    return 'RepositoryProvider.of reads this helper repository inside the '
        'page. The standalone BlocProvider owns CounterBloc with count=$count, '
        'while MultiBlocProvider adds ActivityFilterBloc and SaveSnapshotBloc. '
        'The active filter is ${filter.name}.';
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

// ---------------------------------------------------------------------------
// Demo Fetch Bloc — simulates async data loading with random success/failure
// ---------------------------------------------------------------------------

abstract class _DemoFetchEvent {
  const _DemoFetchEvent();
}

class _DemoFetchRequested extends _DemoFetchEvent {
  const _DemoFetchRequested();
}

class _DemoFetchReset extends _DemoFetchEvent {
  const _DemoFetchReset();
}

enum _DemoFetchStatus { initial, loading, success, failure }

class _DemoFetchState {
  const _DemoFetchState({required this.status, this.data, this.error});

  const _DemoFetchState.initial()
    : status = _DemoFetchStatus.initial,
      data = null,
      error = null;

  final _DemoFetchStatus status;
  final List<String>? data;
  final String? error;
}

class _DemoFetchBloc extends Bloc<_DemoFetchEvent, _DemoFetchState> {
  _DemoFetchBloc() : super(const _DemoFetchState.initial()) {
    on<_DemoFetchRequested>(_onFetchRequested);
    on<_DemoFetchReset>(_onFetchReset);
  }

  Future<void> _onFetchRequested(
    _DemoFetchRequested event,
    Emitter<_DemoFetchState> emit,
  ) async {
    emit(const _DemoFetchState(status: _DemoFetchStatus.loading));
    await Future<void>.delayed(const Duration(seconds: 1));
    if (DateTime.now().millisecond.isEven) {
      emit(
        const _DemoFetchState(
          status: _DemoFetchStatus.success,
          data: <String>[
            'User Profile',
            'Settings',
            'Notifications',
            'Dashboard',
          ],
        ),
      );
    } else {
      emit(
        const _DemoFetchState(
          status: _DemoFetchStatus.failure,
          error: 'Simulated network timeout — tap Fetch again to retry.',
        ),
      );
    }
  }

  void _onFetchReset(_DemoFetchReset event, Emitter<_DemoFetchState> emit) {
    emit(const _DemoFetchState.initial());
  }
}

// ---------------------------------------------------------------------------
// Scoped Counter Bloc — independent counter for scoped BlocProvider demo
// ---------------------------------------------------------------------------

abstract class _ScopedCounterEvent {
  const _ScopedCounterEvent();
}

class _ScopedIncrement extends _ScopedCounterEvent {
  const _ScopedIncrement();
}

class _ScopedDecrement extends _ScopedCounterEvent {
  const _ScopedDecrement();
}

class _ScopedCounterBloc extends Bloc<_ScopedCounterEvent, int> {
  _ScopedCounterBloc() : super(0) {
    on<_ScopedIncrement>(
      (_ScopedIncrement event, Emitter<int> emit) => emit(state + 1),
    );
    on<_ScopedDecrement>(
      (_ScopedDecrement event, Emitter<int> emit) => emit(state - 1),
    );
  }
}

@RoutePage(name: RouteName.flutterBloc)
class FlutterBlocPage extends StatelessWidget {
  const FlutterBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<_CounterRepository>(
          create: (BuildContext context) => _CounterRepository(),
        ),
        RepositoryProvider<_BlocReferenceRepository>(
          create: (BuildContext context) => const _BlocReferenceRepository(),
        ),
      ],
      child: RepositoryProvider<_ProviderNarrativeRepository>(
        create: (BuildContext context) => const _ProviderNarrativeRepository(),
        child: BlocProvider<_CounterBloc>(
          create: (BuildContext context) => _CounterBloc(),
          child: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<_ActivityFilterBloc>(
                create: (BuildContext context) => _ActivityFilterBloc(),
              ),
              BlocProvider<_SaveSnapshotBloc>(
                create: (BuildContext context) =>
                    _SaveSnapshotBloc(context.read<_CounterRepository>()),
              ),
              BlocProvider<_DemoFetchBloc>(
                create: (BuildContext context) => _DemoFetchBloc(),
              ),
            ],
            child: const _FlutterBlocView(),
          ),
        ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const <Widget>[
                _IntroCard(),
                SizedBox(height: 16),
                _ArchitectureCard(),
                SizedBox(height: 16),
                _ProviderSetupCard(),
                SizedBox(height: 16),
                _CounterControlsCard(),
                SizedBox(height: 16),
                _BlocBuilderStatesCard(),
                SizedBox(height: 16),
                _BlocSelectorRebuildTrackerCard(),
                SizedBox(height: 16),
                _RepositoryProviderAccessCard(),
                SizedBox(height: 16),
                _ScopedBlocProviderCard(),
                SizedBox(height: 16),
                _ActivityFilterCard(),
                SizedBox(height: 16),
                _MultiBlocWidgetListenerCard(),
                SizedBox(height: 16),
                _BlocListenerEffectsCard(),
                SizedBox(height: 16),
                _SaveConsumerCard(),
                SizedBox(height: 16),
                _CodeSampleCard(),
              ],
            ),
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
              'This module demonstrates `RepositoryProvider`, '
              '`MultiRepositoryProvider`, `BlocProvider`, `MultiBlocProvider`, '
              '`BlocBuilder`, `BlocSelector`, `BlocListener`, '
              '`MultiBlocListener`, `BlocConsumer`, `context.read`, and '
              '`context.select` using a counter flow, activity filtering, '
              'and an async save operation.',
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

class _ProviderSetupCard extends StatelessWidget {
  const _ProviderSetupCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _BlocReferenceRepository references = context
        .read<_BlocReferenceRepository>();
    final _ProviderNarrativeRepository narrative =
        RepositoryProvider.of<_ProviderNarrativeRepository>(context);
    final int count = context.select<_CounterBloc, int>(
      (_CounterBloc bloc) => bloc.state.count,
    );
    final _ActivityFilter filter = context
        .select<_ActivityFilterBloc, _ActivityFilter>(
          (_ActivityFilterBloc bloc) => bloc.state,
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Provider Setup',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              narrative.describe(count: count, filter: filter),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: references.widgetNames.map((String name) {
                return Chip(label: Text(name));
              }).toList(),
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
              'MultiRepositoryProvider shares demo dependencies, a nested '
              'RepositoryProvider adds page-specific copy, BlocProvider owns '
              'the main counter bloc, and MultiBlocProvider wires the '
              'remaining blocs for activity filtering and async save status. '
              'The UI then dispatches events and reacts through several '
              'flutter_bloc widgets.',
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
        _DiagramChip(
          label: 'MultiRepositoryProvider',
          color: Color(0xFF1D4ED8),
        ),
        _DiagramChip(label: 'RepositoryProvider', color: Color(0xFF2563EB)),
        _DiagramChip(label: 'BlocProvider', color: Color(0xFF4338CA)),
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

class _MultiBlocWidgetListenerCard extends StatelessWidget {
  const _MultiBlocWidgetListenerCard();

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
              'UI Widget Listening To Multiple Blocs',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This panel is wrapped with `MultiBlocListener`. It listens to '
              'three different blocs and updates a local widget log whenever '
              'counter, filter, or save status changes. This is the focused '
              'widget-level pattern for reacting to multiple bloc streams in one place.',
            ),
            const SizedBox(height: 16),
            const _MultiBlocStatusWidget(),
          ],
        ),
      ),
    );
  }
}

class _MultiBlocStatusWidget extends StatefulWidget {
  const _MultiBlocStatusWidget();

  @override
  State<_MultiBlocStatusWidget> createState() => _MultiBlocStatusWidgetState();
}

class _MultiBlocStatusWidgetState extends State<_MultiBlocStatusWidget> {
  final List<String> _events = <String>[];
  Color _accentColor = const Color(0xFF1D4ED8);

  void _record(String message, Color color) {
    if (!mounted) {
      return;
    }

    setState(() {
      _accentColor = color;
      _events.insert(0, message);
      if (_events.length > 6) {
        _events.removeRange(6, _events.length);
      }
    });
  }

  void _cycleFilter(BuildContext context) {
    final _ActivityFilter current = context.read<_ActivityFilterBloc>().state;
    final List<_ActivityFilter> filters = _ActivityFilter.values;
    final int nextIndex = (filters.indexOf(current) + 1) % filters.length;
    context.read<_ActivityFilterBloc>().add(
      _ActivityFilterChanged(filters[nextIndex]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<_CounterBloc, _CounterState>(
          listenWhen: (_CounterState previous, _CounterState current) =>
              previous.count != current.count,
          listener: (BuildContext context, _CounterState state) {
            _record(
              'Counter listener fired: count=${state.count}, step=${state.step}',
              const Color(0xFF7C3AED),
            );
          },
        ),
        BlocListener<_ActivityFilterBloc, _ActivityFilter>(
          listener: (BuildContext context, _ActivityFilter state) {
            _record(
              'Filter listener fired: ${state.name}',
              const Color(0xFFB45309),
            );
          },
        ),
        BlocListener<_SaveSnapshotBloc, _SaveSnapshotState>(
          listenWhen:
              (_SaveSnapshotState previous, _SaveSnapshotState current) =>
                  previous.status != current.status,
          listener: (BuildContext context, _SaveSnapshotState state) {
            _record(
              'Save listener fired: ${state.status.name}',
              switch (state.status) {
                _SaveSnapshotStatus.success => const Color(0xFF15803D),
                _SaveSnapshotStatus.failure => const Color(0xFFDC2626),
                _SaveSnapshotStatus.saving => const Color(0xFF0F766E),
                _SaveSnapshotStatus.idle => const Color(0xFF1D4ED8),
              },
            );
          },
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final int count = context.select<_CounterBloc, int>(
            (_CounterBloc bloc) => bloc.state.count,
          );
          final int step = context.select<_CounterBloc, int>(
            (_CounterBloc bloc) => bloc.state.step,
          );
          final _ActivityFilter filter = context
              .watch<_ActivityFilterBloc>()
              .state;
          final _SaveSnapshotStatus saveStatus = context
              .select<_SaveSnapshotBloc, _SaveSnapshotStatus>(
                (_SaveSnapshotBloc bloc) => bloc.state.status,
              );

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _accentColor.withValues(alpha: 0.45)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    Chip(label: Text('Count: $count')),
                    Chip(label: Text('Step: $step')),
                    Chip(label: Text('Filter: ${_filterLabel(filter)}')),
                    Chip(label: Text('Save: ${saveStatus.name}')),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    FilledButton.tonalIcon(
                      onPressed: () => context.read<_CounterBloc>().add(
                        const _CounterIncrementPressed(),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Trigger Counter'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => _cycleFilter(context),
                      icon: const Icon(Icons.filter_alt_outlined),
                      label: const Text('Cycle Filter'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: saveStatus == _SaveSnapshotStatus.saving
                          ? null
                          : () => context.read<_SaveSnapshotBloc>().add(
                              _SaveSnapshotRequested(
                                context.read<_CounterBloc>().state.count,
                              ),
                            ),
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Trigger Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Widget-local listener log',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (_events.isEmpty)
                  const Text(
                    'No listener events yet. Use the buttons above to trigger multiple blocs.',
                  )
                else
                  ..._events.map(
                    (String event) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(event),
                    ),
                  ),
              ],
            ),
          );
        },
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
MultiRepositoryProvider(
  providers: [
    RepositoryProvider(create: (_) => CounterRepository()),
    RepositoryProvider(create: (_) => BlocReferenceRepository()),
  ],
  child: RepositoryProvider(
    create: (_) => ProviderNarrativeRepository(),
    child: BlocProvider(
      create: (_) => CounterBloc(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ActivityFilterBloc()),
          BlocProvider(
            create: (context) => SaveSnapshotBloc(
              context.read<CounterRepository>(),
            ),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<CounterBloc, CounterState>(
              listener: (context, state) {},
            ),
            BlocListener<ActivityFilterBloc, ActivityFilter>(
              listener: (context, state) {},
            ),
          ],
          child: BlocConsumer<SaveSnapshotBloc, SaveSnapshotState>(
            listener: (context, state) {},
            builder: (context, state) {
              final count = context.select<CounterBloc, int>(
                (bloc) => bloc.state.count,
              );
              return BlocSelector<CounterBloc, CounterState, bool>(
                selector: (state) => state.count.isEven,
                builder: (context, isEven) {
                  return Text('count=$count even=$isEven');
                },
              );
            },
          ),
        ),
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

// ---------------------------------------------------------------------------
// BlocBuilder — Visual State Machine Card
// ---------------------------------------------------------------------------

class _BlocBuilderStatesCard extends StatelessWidget {
  const _BlocBuilderStatesCard();

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
              'BlocBuilder — Visual State Machine',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'BlocBuilder rebuilds its subtree whenever the bloc emits a new '
              'state. Below, a simulated fetch cycles through Initial → '
              'Loading → Success or Failure, each rendered with a distinct '
              'visual treatment. Results vary randomly to show both branches.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () => context.read<_DemoFetchBloc>().add(
                    const _DemoFetchRequested(),
                  ),
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text('Fetch Data'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.read<_DemoFetchBloc>().add(
                    const _DemoFetchReset(),
                  ),
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<_DemoFetchBloc, _DemoFetchState>(
              builder: (BuildContext context, _DemoFetchState state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildFetchStateWidget(context, state),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFetchStateWidget(BuildContext context, _DemoFetchState state) {
    final ThemeData theme = Theme.of(context);

    switch (state.status) {
      case _DemoFetchStatus.initial:
        return Container(
          key: const ValueKey<String>('initial'),
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.cloud_queue,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'No data loaded yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap "Fetch Data" to trigger the BlocBuilder cycle.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );

      case _DemoFetchStatus.loading:
        return Container(
          key: const ValueKey<String>('loading'),
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F766E).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF0F766E).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading…',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF0F766E),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text('BlocBuilder is showing the Loading state.'),
            ],
          ),
        );

      case _DemoFetchStatus.success:
        return Container(
          key: const ValueKey<String>('success'),
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF15803D).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF15803D).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.check_circle, color: Color(0xFF15803D)),
                  const SizedBox(width: 8),
                  Text(
                    'Fetch Successful',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF15803D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (state.data ?? <String>[]).map((String item) {
                  return Chip(
                    avatar: const Icon(Icons.article_outlined, size: 18),
                    label: Text(item),
                  );
                }).toList(),
              ),
            ],
          ),
        );

      case _DemoFetchStatus.failure:
        return Container(
          key: const ValueKey<String>('failure'),
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFDC2626).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                  const SizedBox(width: 8),
                  Text(
                    'Fetch Failed',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFDC2626),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(state.error ?? 'Unknown error'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.read<_DemoFetchBloc>().add(
                  const _DemoFetchRequested(),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// BlocSelector — Rebuild Optimization Tracker
// ---------------------------------------------------------------------------

class _BlocSelectorRebuildTrackerCard extends StatelessWidget {
  const _BlocSelectorRebuildTrackerCard();

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
              'BlocSelector — Rebuild Optimization',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'BlocSelector rebuilds only when the selected value changes. '
              'Compare the rebuild counts below: the BlocBuilder panel '
              'rebuilds on every state change, while BlocSelector panels '
              'only rebuild when their derived value actually differs.',
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
                  label: const Text('Increment (triggers rebuilds)'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _RebuildComparisonRow(),
          ],
        ),
      ),
    );
  }
}

class _RebuildComparisonRow extends StatelessWidget {
  const _RebuildComparisonRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 500) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: _BuilderRebuildPanel()),
              SizedBox(width: 12),
              Expanded(child: _SelectorParityRebuildPanel()),
              SizedBox(width: 12),
              Expanded(child: _SelectorSignRebuildPanel()),
            ],
          );
        }
        return const Column(
          children: <Widget>[
            _BuilderRebuildPanel(),
            SizedBox(height: 12),
            _SelectorParityRebuildPanel(),
            SizedBox(height: 12),
            _SelectorSignRebuildPanel(),
          ],
        );
      },
    );
  }
}

class _BuilderRebuildPanel extends StatefulWidget {
  const _BuilderRebuildPanel();

  @override
  State<_BuilderRebuildPanel> createState() => _BuilderRebuildPanelState();
}

class _BuilderRebuildPanelState extends State<_BuilderRebuildPanel> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_CounterBloc, _CounterState>(
      builder: (BuildContext context, _CounterState state) {
        _rebuildCount++;
        return _RebuildInfoBox(
          title: 'BlocBuilder',
          subtitle: 'Rebuilds on every state change',
          value: 'count=${state.count}',
          rebuildCount: _rebuildCount,
          color: const Color(0xFFDC2626),
        );
      },
    );
  }
}

class _SelectorParityRebuildPanel extends StatefulWidget {
  const _SelectorParityRebuildPanel();

  @override
  State<_SelectorParityRebuildPanel> createState() =>
      _SelectorParityRebuildPanelState();
}

class _SelectorParityRebuildPanelState
    extends State<_SelectorParityRebuildPanel> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<_CounterBloc, _CounterState, bool>(
      selector: (_CounterState state) => state.isEven,
      builder: (BuildContext context, bool isEven) {
        _rebuildCount++;
        return _RebuildInfoBox(
          title: 'BlocSelector (parity)',
          subtitle: 'Rebuilds only when even/odd flips',
          value: isEven ? 'Even' : 'Odd',
          rebuildCount: _rebuildCount,
          color: const Color(0xFF7C3AED),
        );
      },
    );
  }
}

class _SelectorSignRebuildPanel extends StatefulWidget {
  const _SelectorSignRebuildPanel();

  @override
  State<_SelectorSignRebuildPanel> createState() =>
      _SelectorSignRebuildPanelState();
}

class _SelectorSignRebuildPanelState extends State<_SelectorSignRebuildPanel> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<_CounterBloc, _CounterState, String>(
      selector: (_CounterState state) => state.count > 0
          ? 'Positive'
          : (state.count < 0 ? 'Negative' : 'Zero'),
      builder: (BuildContext context, String sign) {
        _rebuildCount++;
        return _RebuildInfoBox(
          title: 'BlocSelector (sign)',
          subtitle: 'Rebuilds only when sign changes',
          value: sign,
          rebuildCount: _rebuildCount,
          color: const Color(0xFF0F766E),
        );
      },
    );
  }
}

class _RebuildInfoBox extends StatelessWidget {
  const _RebuildInfoBox({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.rebuildCount,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String value;
  final int rebuildCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          Text('Value: $value', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            'Rebuilds: $rebuildCount',
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RepositoryProvider + MultiRepositoryProvider Showcase
// ---------------------------------------------------------------------------

class _RepositoryProviderAccessCard extends StatelessWidget {
  const _RepositoryProviderAccessCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _BlocReferenceRepository refs = context
        .read<_BlocReferenceRepository>();
    final _ProviderNarrativeRepository narrative =
        RepositoryProvider.of<_ProviderNarrativeRepository>(context);
    final _CounterRepository counterRepo = context.read<_CounterRepository>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'RepositoryProvider + MultiRepositoryProvider',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'RepositoryProvider makes a single repository instance available '
              'to the widget subtree. MultiRepositoryProvider groups several '
              'RepositoryProvider widgets into one. Access them with '
              '`context.read<T>()` or `RepositoryProvider.of<T>(context)`.',
            ),
            const SizedBox(height: 16),
            _RepoAccessTile(
              icon: Icons.storage_outlined,
              title: 'CounterRepository',
              access: 'context.read<CounterRepository>()',
              detail: 'Type: ${counterRepo.runtimeType}',
              color: const Color(0xFF1D4ED8),
            ),
            const SizedBox(height: 10),
            _RepoAccessTile(
              icon: Icons.list_alt,
              title: 'BlocReferenceRepository',
              access: 'context.read<BlocReferenceRepository>()',
              detail: '${refs.widgetNames.length} widget names available',
              color: const Color(0xFF7C3AED),
            ),
            const SizedBox(height: 10),
            _RepoAccessTile(
              icon: Icons.description_outlined,
              title: 'ProviderNarrativeRepository',
              access:
                  'RepositoryProvider.of<ProviderNarrativeRepository>(context)',
              detail: 'Returns a dynamic description string',
              color: const Color(0xFF0F766E),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Live Narrative Output',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<_CounterBloc, _CounterState>(
                    builder:
                        (BuildContext context, _CounterState counterState) {
                          final _ActivityFilter filter = context
                              .watch<_ActivityFilterBloc>()
                              .state;
                          return Text(
                            narrative.describe(
                              count: counterState.count,
                              filter: filter,
                            ),
                            style: theme.textTheme.bodyMedium,
                          );
                        },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'BlocReferenceRepository — Widget Names',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: refs.widgetNames.map((String name) {
                      return Chip(
                        avatar: const Icon(Icons.widgets_outlined, size: 16),
                        label: Text(name),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RepoAccessTile extends StatelessWidget {
  const _RepoAccessTile({
    required this.icon,
    required this.title,
    required this.access,
    required this.detail,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String access;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  access,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(detail, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scoped BlocProvider Card
// ---------------------------------------------------------------------------

class _ScopedBlocProviderCard extends StatelessWidget {
  const _ScopedBlocProviderCard();

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
              'Scoped BlocProvider',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'A BlocProvider can be scoped to a subtree. The local counter '
              'below lives in its own BlocProvider and is completely '
              'independent from the page-level CounterBloc above. When this '
              'card leaves the widget tree, the scoped bloc is automatically '
              'closed.',
            ),
            const SizedBox(height: 16),
            BlocProvider<_ScopedCounterBloc>(
              create: (BuildContext context) => _ScopedCounterBloc(),
              child: const _ScopedCounterContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScopedCounterContent extends StatelessWidget {
  const _ScopedCounterContent();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int scopedCount = context.watch<_ScopedCounterBloc>().state;
    final int mainCount = context.select<_CounterBloc, int>(
      (_CounterBloc bloc) => bloc.state.count,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF4338CA).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4338CA).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _ScopedCounterBox(
                  label: 'Scoped Counter',
                  count: scopedCount,
                  color: const Color(0xFF4338CA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScopedCounterBox(
                  label: 'Main Counter',
                  count: mainCount,
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => context.read<_ScopedCounterBloc>().add(
                  const _ScopedIncrement(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Scoped +1'),
              ),
              FilledButton.icon(
                onPressed: () => context.read<_ScopedCounterBloc>().add(
                  const _ScopedDecrement(),
                ),
                icon: const Icon(Icons.remove),
                label: const Text('Scoped \u22121'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.read<_CounterBloc>().add(
                  const _CounterIncrementPressed(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Main +1'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Notice: each counter operates independently.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ScopedCounterBox extends StatelessWidget {
  const _ScopedCounterBox({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BlocListener — Side Effects Card
// ---------------------------------------------------------------------------

class _BlocListenerEffectsCard extends StatelessWidget {
  const _BlocListenerEffectsCard();

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
              'BlocListener — Side Effects',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'BlocListener reacts to state changes without rebuilding the UI. '
              'Use it for one-time side effects such as showing dialogs, '
              'navigating, or logging. Tap "Fetch Data" in the BlocBuilder '
              'card above — when the fetch fails, this listener shows an '
              'AlertDialog. When it succeeds, it logs a message below.',
            ),
            const SizedBox(height: 16),
            const _BlocListenerEffectsContent(),
          ],
        ),
      ),
    );
  }
}

class _BlocListenerEffectsContent extends StatefulWidget {
  const _BlocListenerEffectsContent();

  @override
  State<_BlocListenerEffectsContent> createState() =>
      _BlocListenerEffectsContentState();
}

class _BlocListenerEffectsContentState
    extends State<_BlocListenerEffectsContent> {
  final List<String> _sideEffectLog = <String>[];

  void _log(String message) {
    if (!mounted) {
      return;
    }
    setState(() {
      _sideEffectLog.insert(0, message);
      if (_sideEffectLog.length > 8) {
        _sideEffectLog.removeRange(8, _sideEffectLog.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocListener<_DemoFetchBloc, _DemoFetchState>(
      listenWhen: (_DemoFetchState previous, _DemoFetchState current) =>
          previous.status != current.status,
      listener: (BuildContext context, _DemoFetchState state) {
        final String time =
            '${DateTime.now().hour.toString().padLeft(2, '0')}:'
            '${DateTime.now().minute.toString().padLeft(2, '0')}:'
            '${DateTime.now().second.toString().padLeft(2, '0')}';

        switch (state.status) {
          case _DemoFetchStatus.loading:
            _log('[$time] Side effect: fetch started');
          case _DemoFetchStatus.success:
            _log('[$time] Side effect: fetch succeeded');
          case _DemoFetchStatus.failure:
            _log('[$time] Side effect: fetch failed — showing dialog');
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  icon: const Icon(
                    Icons.error_outline,
                    color: Color(0xFFDC2626),
                    size: 40,
                  ),
                  title: const Text('Fetch Error'),
                  content: Text(state.error ?? 'Unknown error'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('OK'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<_DemoFetchBloc>().add(
                          const _DemoFetchRequested(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            );
          case _DemoFetchStatus.initial:
            _log('[$time] Side effect: reset to initial');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => context.read<_DemoFetchBloc>().add(
                  const _DemoFetchRequested(),
                ),
                icon: const Icon(Icons.cloud_download_outlined),
                label: const Text('Fetch Data'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<_DemoFetchBloc>().add(const _DemoFetchReset()),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<_DemoFetchBloc, _DemoFetchState>(
            builder: (BuildContext context, _DemoFetchState state) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  Chip(label: Text('Fetch status: ${state.status.name}')),
                  if (state.data != null)
                    Chip(label: Text('Items: ${state.data!.length}')),
                  if (state.error != null)
                    Chip(
                      label: const Text('Has error'),
                      backgroundColor: const Color(
                        0xFFDC2626,
                      ).withValues(alpha: 0.15),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.receipt_long, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Side-Effect Log',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_sideEffectLog.isEmpty)
                  const Text(
                    'No side effects triggered yet. Use the buttons above.',
                  )
                else
                  ..._sideEffectLog.map(
                    (String entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        entry,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
