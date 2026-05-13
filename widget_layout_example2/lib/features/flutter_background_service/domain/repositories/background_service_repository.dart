import 'package:widget_layout_example2/features/flutter_background_service/domain/entities/background_service_snapshot.dart';

abstract interface class BackgroundServiceRepository {
  BackgroundServiceSnapshot get currentSnapshot;

  Stream<BackgroundServiceSnapshot> watchSnapshot();

  Future<BackgroundServiceSnapshot> initialize();

  Future<BackgroundServiceSnapshot> refresh();

  Future<BackgroundServiceSnapshot> requestNotificationPermission();

  Future<BackgroundServiceSnapshot> startService();

  Future<BackgroundServiceSnapshot> stopService();

  Future<BackgroundServiceSnapshot> setForegroundMode();

  Future<BackgroundServiceSnapshot> setBackgroundMode();

  Future<BackgroundServiceSnapshot> clearDemoData();
}
