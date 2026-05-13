import 'package:bloc/bloc.dart';
import 'package:widget_layout_example2/features/home_widget/domain/entities/home_widget_demo_snapshot.dart';
import 'package:widget_layout_example2/features/home_widget/domain/repositories/home_widget_repository.dart';
import 'package:widget_layout_example2/features/home_widget/presentation/bloc/home_widget_demo_event.dart';
import 'package:widget_layout_example2/features/home_widget/presentation/bloc/home_widget_demo_state.dart';

class HomeWidgetDemoBloc
    extends Bloc<HomeWidgetDemoEvent, HomeWidgetDemoState> {
  HomeWidgetDemoBloc({required HomeWidgetRepository repository})
    : _repository = repository,
      super(HomeWidgetDemoState.initial(snapshot: repository.currentSnapshot)) {
    on<HomeWidgetDemoInitializeRequested>(_onInitializeRequested);
    on<HomeWidgetDemoRefreshRequested>(_onRefreshRequested);
    on<HomeWidgetDemoDraftChanged>(_onDraftChanged);
    on<HomeWidgetDemoPushRequested>(_onPushRequested);
    on<HomeWidgetDemoReadRequested>(_onReadRequested);
    on<HomeWidgetDemoRenderImageRequested>(_onRenderImageRequested);
    on<HomeWidgetDemoRequestPinRequested>(_onRequestPinRequested);
    on<HomeWidgetDemoInstalledWidgetsRequested>(_onInstalledWidgetsRequested);
  }

  final HomeWidgetRepository _repository;

  Future<void> _onInitializeRequested(
    HomeWidgetDemoInitializeRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.initialize);
  }

  Future<void> _onRefreshRequested(
    HomeWidgetDemoRefreshRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.refresh);
  }

  Future<void> _onDraftChanged(
    HomeWidgetDemoDraftChanged event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    final HomeWidgetDemoSnapshot snapshot = await _repository.updateDraft(
      title: event.title,
      message: event.message,
    );
    emit(state.copyWith(snapshot: snapshot, isBusy: false));
  }

  Future<void> _onPushRequested(
    HomeWidgetDemoPushRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.pushWidgetData);
  }

  Future<void> _onReadRequested(
    HomeWidgetDemoReadRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.readWidgetData);
  }

  Future<void> _onRenderImageRequested(
    HomeWidgetDemoRenderImageRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.renderDemoImage);
  }

  Future<void> _onRequestPinRequested(
    HomeWidgetDemoRequestPinRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.requestPinWidget);
  }

  Future<void> _onInstalledWidgetsRequested(
    HomeWidgetDemoInstalledWidgetsRequested event,
    Emitter<HomeWidgetDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.loadInstalledWidgets);
  }

  Future<void> _runCommand(
    Emitter<HomeWidgetDemoState> emit,
    Future<HomeWidgetDemoSnapshot> Function() action,
  ) async {
    emit(state.copyWith(isBusy: true));
    try {
      final HomeWidgetDemoSnapshot snapshot = await action();
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
}
