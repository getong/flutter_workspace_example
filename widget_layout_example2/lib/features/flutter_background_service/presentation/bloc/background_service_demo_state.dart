import 'package:widget_layout_example2/features/flutter_background_service/domain/entities/background_service_snapshot.dart';

class BackgroundServiceDemoState {
  const BackgroundServiceDemoState({
    required this.snapshot,
    this.isBusy = false,
  });

  factory BackgroundServiceDemoState.initial({
    required BackgroundServiceSnapshot snapshot,
  }) {
    return BackgroundServiceDemoState(snapshot: snapshot);
  }

  final BackgroundServiceSnapshot snapshot;
  final bool isBusy;

  BackgroundServiceDemoState copyWith({
    BackgroundServiceSnapshot? snapshot,
    bool? isBusy,
  }) {
    return BackgroundServiceDemoState(
      snapshot: snapshot ?? this.snapshot,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
