import 'dart:async';

import 'package:widget_layout_example2/features/home_widget/data/services/home_widget_demo_runtime.dart';
import 'package:widget_layout_example2/features/home_widget/domain/entities/home_widget_demo_snapshot.dart';
import 'package:widget_layout_example2/features/home_widget/domain/repositories/home_widget_repository.dart';

class HomeWidgetDemoRepository implements HomeWidgetRepository {
  HomeWidgetDemoRepository({HomeWidgetDemoRuntime? runtime})
    : _runtime = runtime ?? HomeWidgetDemoRuntime(),
      _snapshot = HomeWidgetDemoSnapshot.initial(
        platformLabel: (runtime ?? HomeWidgetDemoRuntime()).platformLabel,
        isSupported: (runtime ?? HomeWidgetDemoRuntime()).isSupported,
      ) {
    _runtime.watchState().listen((HomeWidgetRuntimeState runtimeState) {
      final HomeWidgetDemoSnapshot snapshot = _mapRuntimeState(runtimeState);
      _snapshot = snapshot;
      _controller.add(snapshot);
    });
  }

  final HomeWidgetDemoRuntime _runtime;
  final StreamController<HomeWidgetDemoSnapshot> _controller =
      StreamController<HomeWidgetDemoSnapshot>.broadcast();
  HomeWidgetDemoSnapshot _snapshot;

  @override
  HomeWidgetDemoSnapshot get currentSnapshot => _snapshot;

  @override
  Stream<HomeWidgetDemoSnapshot> watchSnapshot() => _controller.stream;

  @override
  Future<HomeWidgetDemoSnapshot> initialize() async {
    await _runtime.initialize();
    return refresh();
  }

  @override
  Future<HomeWidgetDemoSnapshot> refresh() async {
    final HomeWidgetRuntimeState runtimeState = await _runtime.refresh();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<HomeWidgetDemoSnapshot> updateDraft({
    required String title,
    required String message,
  }) async {
    final HomeWidgetRuntimeState runtimeState = await _runtime.updateDraft(
      title: title,
      message: message,
    );
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<HomeWidgetDemoSnapshot> pushWidgetData() async {
    final HomeWidgetRuntimeState runtimeState = await _runtime.pushWidgetData();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<HomeWidgetDemoSnapshot> readWidgetData() async {
    final HomeWidgetRuntimeState runtimeState = await _runtime
        .readPersistedData();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<HomeWidgetDemoSnapshot> renderDemoImage() async {
    final HomeWidgetRuntimeState runtimeState = await _runtime
        .renderDemoImage();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<HomeWidgetDemoSnapshot> requestPinWidget() async {
    final HomeWidgetRuntimeState runtimeState = await _runtime
        .requestPinWidget();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<HomeWidgetDemoSnapshot> loadInstalledWidgets() async {
    final HomeWidgetRuntimeState runtimeState = await _runtime
        .loadInstalledWidgets();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  HomeWidgetDemoSnapshot _mapRuntimeState(HomeWidgetRuntimeState runtimeState) {
    return _snapshot.copyWith(
      isConfigured: runtimeState.isConfigured,
      isPinSupported: runtimeState.isPinSupported,
      widgetTitle: runtimeState.title,
      widgetMessage: runtimeState.message,
      widgetLaunchSummary: runtimeState.widgetLaunchSummary,
      statusMessage: runtimeState.statusMessage,
      renderedImagePath: runtimeState.renderedImagePath,
      installedWidgets: runtimeState.installedWidgets,
      logEntries: runtimeState.logEntries,
    );
  }

  HomeWidgetDemoSnapshot _emitSnapshot(HomeWidgetDemoSnapshot snapshot) {
    _snapshot = snapshot;
    return _snapshot;
  }
}
