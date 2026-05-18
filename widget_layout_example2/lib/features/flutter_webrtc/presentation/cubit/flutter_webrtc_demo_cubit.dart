import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/entities/flutter_webrtc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/repositories/flutter_webrtc_repository.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/presentation/cubit/flutter_webrtc_demo_state.dart';

class FlutterWebRtcDemoCubit extends Cubit<FlutterWebRtcDemoState> {
  FlutterWebRtcDemoCubit({required FlutterWebRtcRepository repository})
    : _repository = repository,
      super(
        FlutterWebRtcDemoState(
          snapshot: repository.currentSnapshot,
          localRenderer: repository.localRenderer,
          remoteRenderer: repository.remoteRenderer,
        ),
      ) {
    _snapshotSubscription = _repository.watchSnapshot().listen((
      FlutterWebRtcDemoSnapshot snapshot,
    ) {
      emit(state.copyWith(snapshot: snapshot));
    });
  }

  final FlutterWebRtcRepository _repository;
  late final StreamSubscription<FlutterWebRtcDemoSnapshot>
  _snapshotSubscription;

  Future<void> initialize() => _repository.initialize();

  Future<void> restartLoopback() => _repository.restartLoopback();

  Future<void> toggleCameraEnabled() => _repository.toggleCameraEnabled();

  Future<void> toggleMicrophoneEnabled() =>
      _repository.toggleMicrophoneEnabled();

  Future<void> switchCamera() => _repository.switchCamera();

  @override
  Future<void> close() async {
    await _snapshotSubscription.cancel();
    await _repository.dispose();
    return super.close();
  }
}
