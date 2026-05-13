import 'dart:async';

import 'package:widget_layout_example2/features/flutter_background_service/data/services/flutter_background_service_demo_runtime.dart';
import 'package:widget_layout_example2/features/flutter_background_service/domain/entities/background_service_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_background_service/domain/repositories/background_service_repository.dart';

class FlutterBackgroundServiceDemoRepository
    implements BackgroundServiceRepository {
  FlutterBackgroundServiceDemoRepository({
    BackgroundServiceDemoRuntime? runtime,
  }) : _runtime = runtime ?? BackgroundServiceDemoRuntime() {
    _snapshot = BackgroundServiceSnapshot.initial(
      isSupported: _runtime.isSupported,
      platformLabel: _runtime.platformLabel,
    );
    _runtime.watchState().listen(_handleRuntimeState);
  }

  final BackgroundServiceDemoRuntime _runtime;
  final StreamController<BackgroundServiceSnapshot> _controller =
      StreamController<BackgroundServiceSnapshot>.broadcast();
  late BackgroundServiceSnapshot _snapshot;

  @override
  BackgroundServiceSnapshot get currentSnapshot => _snapshot;

  @override
  Stream<BackgroundServiceSnapshot> watchSnapshot() => _controller.stream;

  @override
  Future<BackgroundServiceSnapshot> initialize() async {
    await _runtime.initialize();
    if (!_runtime.isSupported) {
      return _emitSnapshot(
        _snapshot.copyWith(
          statusMessage:
              'This page still explains the architecture, but only Android/iOS can run the plugin.',
        ),
      );
    }
    return refresh();
  }

  @override
  Future<BackgroundServiceSnapshot> refresh() async {
    if (!_runtime.isSupported) {
      return _emitSnapshot(_snapshot);
    }
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .readPersistedState();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<BackgroundServiceSnapshot> requestNotificationPermission() async {
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .requestNotificationPermission();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<BackgroundServiceSnapshot> startService() async {
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .startService();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<BackgroundServiceSnapshot> stopService() async {
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .stopService();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<BackgroundServiceSnapshot> setForegroundMode() async {
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .setForegroundMode();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<BackgroundServiceSnapshot> setBackgroundMode() async {
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .setBackgroundMode();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  @override
  Future<BackgroundServiceSnapshot> clearDemoData() async {
    final BackgroundServiceRuntimeState runtimeState = await _runtime
        .clearDemoData();
    return _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  void _handleRuntimeState(BackgroundServiceRuntimeState runtimeState) {
    _emitSnapshot(_mapRuntimeState(runtimeState));
  }

  BackgroundServiceSnapshot _mapRuntimeState(
    BackgroundServiceRuntimeState runtimeState,
  ) {
    return _snapshot.copyWith(
      isConfigured: _runtime.isInitialized,
      isRunning: runtimeState.isRunning,
      isForegroundMode: runtimeState.isForegroundMode,
      tickCount: runtimeState.tickCount,
      lastTickAt: runtimeState.lastTickAt,
      permissionSummary: runtimeState.permissionSummary,
      statusMessage: runtimeState.lastMessage,
      logEntries: runtimeState.logEntries,
    );
  }

  BackgroundServiceSnapshot _emitSnapshot(
    BackgroundServiceSnapshot nextSnapshot,
  ) {
    _snapshot = nextSnapshot;
    _controller.add(_snapshot);
    return _snapshot;
  }
}
