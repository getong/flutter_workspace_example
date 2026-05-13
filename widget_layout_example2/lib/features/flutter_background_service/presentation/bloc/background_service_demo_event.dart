import 'package:widget_layout_example2/features/flutter_background_service/domain/entities/background_service_snapshot.dart';

sealed class BackgroundServiceDemoEvent {
  const BackgroundServiceDemoEvent();
}

final class BackgroundServiceDemoInitializeRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoInitializeRequested();
}

final class BackgroundServiceDemoRefreshRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoRefreshRequested();
}

final class BackgroundServiceDemoRequestPermissionRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoRequestPermissionRequested();
}

final class BackgroundServiceDemoStartRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoStartRequested();
}

final class BackgroundServiceDemoStopRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoStopRequested();
}

final class BackgroundServiceDemoSetForegroundRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoSetForegroundRequested();
}

final class BackgroundServiceDemoSetBackgroundRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoSetBackgroundRequested();
}

final class BackgroundServiceDemoClearDemoDataRequested
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoClearDemoDataRequested();
}

final class BackgroundServiceDemoSnapshotChanged
    extends BackgroundServiceDemoEvent {
  const BackgroundServiceDemoSnapshotChanged({required this.snapshot});

  final BackgroundServiceSnapshot snapshot;
}
