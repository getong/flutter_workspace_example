import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/entities/libp2p_webrtc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/repositories/libp2p_webrtc_bridge_repository.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/presentation/bloc/libp2p_webrtc_demo_event.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/presentation/bloc/libp2p_webrtc_demo_state.dart';

class Libp2pWebRtcDemoBloc
    extends Bloc<Libp2pWebRtcDemoEvent, Libp2pWebRtcDemoState> {
  Libp2pWebRtcDemoBloc({required Libp2pWebRtcBridgeRepository repository})
    : _repository = repository,
      super(
        Libp2pWebRtcDemoState.initial(snapshot: repository.currentSnapshot),
      ) {
    on<Libp2pWebRtcDemoInitializeRequested>(_onInitializeRequested);
    on<Libp2pWebRtcDemoDialRequested>(_onDialRequested);
    on<Libp2pWebRtcDemoSnapshotChanged>(_onSnapshotChanged);

    _snapshotSubscription = _repository.watchSnapshot().listen((
      Libp2pWebRtcDemoSnapshot snapshot,
    ) {
      add(Libp2pWebRtcDemoSnapshotChanged(snapshot: snapshot));
    });
  }

  final Libp2pWebRtcBridgeRepository _repository;
  late final StreamSubscription<Libp2pWebRtcDemoSnapshot> _snapshotSubscription;

  Future<void> _onInitializeRequested(
    Libp2pWebRtcDemoInitializeRequested event,
    Emitter<Libp2pWebRtcDemoState> emit,
  ) async {
    await _runCommand(emit, _repository.initialize);
  }

  Future<void> _onDialRequested(
    Libp2pWebRtcDemoDialRequested event,
    Emitter<Libp2pWebRtcDemoState> emit,
  ) async {
    await _runCommand(
      emit,
      () => _repository.dialServer(
        serverMultiaddr: event.serverMultiaddr,
        timeoutSeconds: event.timeoutSeconds,
        message: event.message,
      ),
    );
  }

  void _onSnapshotChanged(
    Libp2pWebRtcDemoSnapshotChanged event,
    Emitter<Libp2pWebRtcDemoState> emit,
  ) {
    emit(state.copyWith(snapshot: event.snapshot, isBusy: false));
  }

  Future<void> _runCommand(
    Emitter<Libp2pWebRtcDemoState> emit,
    Future<Libp2pWebRtcDemoSnapshot> Function() action,
  ) async {
    emit(state.copyWith(isBusy: true));
    try {
      final Libp2pWebRtcDemoSnapshot snapshot = await action();
      emit(state.copyWith(snapshot: snapshot, isBusy: false));
    } catch (error) {
      emit(
        state.copyWith(
          snapshot: state.snapshot.copyWith(
            hasSuccessfulDial: false,
            statusMessage: 'Dial failed: $error',
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
