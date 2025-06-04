/// {@template analytics_event}
/// Analytics event model
/// {@endtemplate}
class AnalyticsEvent {
  const AnalyticsEvent({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.properties,
  });

  final String id;
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> properties;

  @override
  String toString() => 'AnalyticsEvent(name: $name, timestamp: $timestamp)';
}

/// {@template analytics_repository}
/// Repository for analytics operations
/// {@endtemplate}
abstract class AnalyticsRepository {
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties);
  Future<List<AnalyticsEvent>> getEvents();
  Future<int> getEventCount();
  Future<void> clearEvents();
  Stream<AnalyticsEvent> get eventStream;
}

/// {@template mock_analytics_repository}
/// Mock implementation of AnalyticsRepository
/// {@endtemplate}
class MockAnalyticsRepository implements AnalyticsRepository {
  MockAnalyticsRepository()
      : _eventController =
            const Stream<AnalyticsEvent>.empty().asBroadcastStream() {
    _events.add(AnalyticsEvent(
      id: '1',
      name: 'app_started',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      properties: const {'version': '1.0.0'},
    ));
  }

  final List<AnalyticsEvent> _events = [];
  int _nextId = 2;
  late final Stream<AnalyticsEvent> _eventController;

  @override
  Future<void> trackEvent(
      String eventName, Map<String, dynamic> properties) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final event = AnalyticsEvent(
      id: _nextId.toString(),
      name: eventName,
      timestamp: DateTime.now(),
      properties: Map.from(properties),
    );

    _nextId++;
    _events.add(event);

    // In a real implementation, this would be a proper stream controller
    print('📊 Analytics Event: $eventName with properties: $properties');
  }

  @override
  Future<List<AnalyticsEvent>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_events);
  }

  @override
  Future<int> getEventCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _events.length;
  }

  @override
  Future<void> clearEvents() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _events.clear();
  }

  @override
  Stream<AnalyticsEvent> get eventStream => _eventController;
}
