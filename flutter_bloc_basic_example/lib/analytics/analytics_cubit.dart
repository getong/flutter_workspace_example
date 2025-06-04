import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/analytics_repository.dart';

/// {@template analytics_state}
/// State for analytics management
/// {@endtemplate}
class AnalyticsState {
  const AnalyticsState({
    this.events = const [],
    this.totalEvents = 0,
    this.isLoading = false,
    this.error,
  });

  final List<AnalyticsEvent> events;
  final int totalEvents;
  final bool isLoading;
  final String? error;

  AnalyticsState copyWith({
    List<AnalyticsEvent>? events,
    int? totalEvents,
    bool? isLoading,
    String? error,
  }) {
    return AnalyticsState(
      events: events ?? this.events,
      totalEvents: totalEvents ?? this.totalEvents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// {@template analytics_cubit}
/// Cubit for managing analytics events
/// {@endtemplate}
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._analyticsRepository) : super(const AnalyticsState()) {
    _eventStreamSubscription = _eventController.stream.listen(_handleEvent);
  }

  final AnalyticsRepository _analyticsRepository;
  final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>();
  late final StreamSubscription<Map<String, dynamic>> _eventStreamSubscription;

  void _handleEvent(Map<String, dynamic> eventData) {
    final name = eventData['name'] as String;
    final data =
        eventData['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    trackEvent(name, data);
  }

  Future<void> loadEvents() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final events = await _analyticsRepository.getEvents();
      final totalEvents = await _analyticsRepository.getEventCount();
      emit(state.copyWith(
        events: events,
        totalEvents: totalEvents,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> trackEvent(String name, Map<String, dynamic> properties) async {
    try {
      await _analyticsRepository.trackEvent(name, properties);
      // Reload events to show the new one
      await loadEvents();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> clearEvents() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _analyticsRepository.clearEvents();
      emit(state.copyWith(
        events: [],
        totalEvents: 0,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void queueEvent(String name, Map<String, dynamic> properties) {
    _eventController.sink.add({'name': name, 'data': properties});
  }

  void queueBatchEvents(List<Map<String, dynamic>> events) {
    for (final event in events) {
      // Ensure the event has the correct structure
      if (event.containsKey('name') && event.containsKey('data')) {
        _eventController.sink.add(event);
      } else {
        // Handle legacy format where the whole map might be the data
        final name = event['name']?.toString() ?? 'unknown_event';
        final data = Map<String, dynamic>.from(event);
        data.remove('name'); // Remove name from data if it exists
        _eventController.sink.add({'name': name, 'data': data});
      }
    }
  }

  @override
  Future<void> close() {
    _eventStreamSubscription.cancel();
    _eventController.close();
    return super.close();
  }
}
