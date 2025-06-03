import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/analytics_repository.dart';

/// {@template analytics_state}
/// State for analytics management
/// {@endtemplate}
class AnalyticsState {
  const AnalyticsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    this.totalEvents = 0,
  });

  final List<AnalyticsEvent> events;
  final bool isLoading;
  final String? error;
  final int totalEvents;

  AnalyticsState copyWith({
    List<AnalyticsEvent>? events,
    bool? isLoading,
    String? error,
    int? totalEvents,
  }) {
    return AnalyticsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalEvents: totalEvents ?? this.totalEvents,
    );
  }
}

/// Event for analytics operations (using Sink)
abstract class AnalyticsSinkEvent {}

class LoadAnalyticsSinkEvent extends AnalyticsSinkEvent {}

class TrackAnalyticsSinkEvent extends AnalyticsSinkEvent {
  final String eventName;
  final Map<String, dynamic> properties;
  TrackAnalyticsSinkEvent(this.eventName, this.properties);
}

class ClearAnalyticsSinkEvent extends AnalyticsSinkEvent {}

class BatchAnalyticsSinkEvent extends AnalyticsSinkEvent {
  final List<TrackAnalyticsSinkEvent> events;
  BatchAnalyticsSinkEvent(this.events);
}

/// {@template analytics_cubit}
/// Cubit for managing analytics events using RepositoryProvider and Sink patterns
/// {@endtemplate}
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._analyticsRepository) : super(const AnalyticsState()) {
    // Set up real-time event processing
    _eventStreamSubscription =
        _eventController.stream.listen(_handleAnalyticsSinkEvent);

    // Set up periodic batch processing
    _batchTimer = Timer.periodic(
        const Duration(seconds: 5), (_) => _processBatchedEvents());
  }

  final AnalyticsRepository _analyticsRepository;

  // Sink for real-time analytics events
  final StreamController<AnalyticsSinkEvent> _eventController =
      StreamController<AnalyticsSinkEvent>();
  late final StreamSubscription<AnalyticsSinkEvent> _eventStreamSubscription;

  // Batch processing
  final List<TrackAnalyticsSinkEvent> _batchedEvents = [];
  Timer? _batchTimer;

  /// Sink for adding analytics events
  Sink<AnalyticsSinkEvent> get eventSink => _eventController.sink;

  /// Stream of analytics events for monitoring
  Stream<AnalyticsSinkEvent> get eventStream => _eventController.stream;

  // Handle events from sink
  void _handleAnalyticsSinkEvent(AnalyticsSinkEvent event) {
    switch (event) {
      case LoadAnalyticsSinkEvent():
        loadEvents();
        break;
      case TrackAnalyticsSinkEvent():
        _batchedEvents.add(event);
        // Process immediately for important events
        if (event.eventName.contains('error') ||
            event.eventName.contains('crash')) {
          _processEventImmediately(event);
        }
        break;
      case ClearAnalyticsSinkEvent():
        clearEvents();
        break;
      case BatchAnalyticsSinkEvent():
        _batchedEvents.addAll(event.events);
        break;
    }
  }

  // Process batched events
  void _processBatchedEvents() async {
    if (_batchedEvents.isEmpty) return;

    final eventsToProcess = List<TrackAnalyticsSinkEvent>.from(_batchedEvents);
    _batchedEvents.clear();

    for (final event in eventsToProcess) {
      try {
        await _analyticsRepository.trackEvent(
            event.eventName, event.properties);
      } catch (e) {
        // Re-queue failed events
        _batchedEvents.add(event);
      }
    }

    // Refresh state after batch processing
    if (eventsToProcess.isNotEmpty) {
      loadEvents();
    }
  }

  // Process critical events immediately
  void _processEventImmediately(TrackAnalyticsSinkEvent event) async {
    try {
      await _analyticsRepository.trackEvent(event.eventName, event.properties);
      loadEvents();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadEvents() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final events = await _analyticsRepository.getEvents();
      emit(state.copyWith(
        events: events,
        totalEvents: events.length,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> trackEvent(
      String eventName, Map<String, dynamic> properties) async {
    try {
      await _analyticsRepository.trackEvent(eventName, properties);
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

  /// Queue analytics event via sink
  void queueEvent(String eventName, Map<String, dynamic> properties) {
    eventSink.add(TrackAnalyticsSinkEvent(eventName, properties));
  }

  /// Queue multiple events via sink
  void queueBatchEvents(List<Map<String, String>> eventData) {
    final events = eventData
        .map((data) =>
            TrackAnalyticsSinkEvent(data['name']!, {'data': data['data']}))
        .toList();
    eventSink.add(BatchAnalyticsSinkEvent(events));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    _batchTimer?.cancel();
    _eventStreamSubscription.cancel();
    _eventController.close();
    return super.close();
  }
}
