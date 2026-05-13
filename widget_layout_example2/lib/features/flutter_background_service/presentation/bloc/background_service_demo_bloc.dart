import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:widget_layout_example2/features/flutter_background_service/domain/entities/background_service_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_background_service/domain/repositories/background_service_repository.dart';
import 'package:widget_layout_example2/features/flutter_background_service/presentation/bloc/background_service_demo_event.dart';
import 'package:widget_layout_example2/features/flutter_background_service/presentation/bloc/background_service_demo_state.dart';

class BackgroundServiceDemoBloc
    extends Bloc<BackgroundServiceDemoEvent, BackgroundServiceDemoState> {
  BackgroundServiceDemoBloc({required BackgroundServiceRepository repository})
    : _repository = repository,
      super(
        BackgroundServiceDemoState.initial(
          snapshot: repository.currentSnapshot,
        ),
      ) {
    on<BackgroundServiceDemoInitializeRequested>(_onInitializeRequested);
    on<BackgroundServiceDemoRefreshRequested>(_onRefreshRequested);
    on<BackgroundServiceDemoRequestPermissionRequested>(
      _onRequestPermissionRequested,
    );
    on<BackgroundServiceDemoStartRequested>(_onStartRequested);
    on<BackgroundServiceDemoStopRequested>(_onStopRequested);
    on<BackgroundServiceDemoSetForegroundRequested>(_onSetForegroundRequested);
    on<BackgroundServiceDemoSetBackgroundRequested>(_onSetBackgroundRequested);
    on<BackgroundServiceDemoClearDemoDataRequested>(_onClearDemoDataRequested);
    on<BackgroundServiceDemoSnapshotChanged>(_onSnapshotChanged);

    _snapshotSubscription = _repository.watchSnapshot().listen((
      BackgroundServiceSnapshot snapshot,
    ) {
      add(BackgroundServiceDemoSnapshotChanged(snapshot: snapshot));
    });
  }

  final BackgroundServiceRepository _repository;
  late final StreamSubscription<BackgroundServiceSnapshot>
  _snapshotSubscription;

  Future<void> _onInitializeRequested(
    BackgroundServiceDemoInitializeRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.initialize);
  }

  Future<void> _onRefreshRequested(
    BackgroundServiceDemoRefreshRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.refresh);
  }

  Future<void> _onRequestPermissionRequested(
    BackgroundServiceDemoRequestPermissionRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.requestNotificationPermission);
  }

  Future<void> _onStartRequested(
    BackgroundServiceDemoStartRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.startService);
  }

  Future<void> _onStopRequested(
    BackgroundServiceDemoStopRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.stopService);
  }

  Future<void> _onSetForegroundRequested(
    BackgroundServiceDemoSetForegroundRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.setForegroundMode);
  }

  Future<void> _onSetBackgroundRequested(
    BackgroundServiceDemoSetBackgroundRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.setBackgroundMode);
  }

  Future<void> _onClearDemoDataRequested(
    BackgroundServiceDemoClearDemoDataRequested event,
    Emitter<BackgroundServiceDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.clearDemoData);
  }

  void _onSnapshotChanged(
    BackgroundServiceDemoSnapshotChanged event,
    Emitter<BackgroundServiceDemoState> emit,
  ) {
    emit(state.copyWith(snapshot: event.snapshot, isBusy: false));
  }

  Future<void> _runCommand(
    Emitter<BackgroundServiceDemoState> emit,
    Future<BackgroundServiceSnapshot> Function() action,
  ) async {
    emit(state.copyWith(isBusy: true));
    try {
      final BackgroundServiceSnapshot snapshot = await action();
      emit(state.copyWith(snapshot: snapshot, isBusy: false));
    } catch (error) {
      emit(
        state.copyWith(
          snapshot: state.snapshot.copyWith(
            statusMessage: 'Unexpected error: $error',
          ),
          isBusy: false,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _snapshotSubscription.cancel();
    return super.close();
  }
}
