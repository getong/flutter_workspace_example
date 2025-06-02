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

/// {@template analytics_cubit}
/// Cubit for managing analytics events using RepositoryProvider
/// {@endtemplate}
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._analyticsRepository) : super(const AnalyticsState());

  final AnalyticsRepository _analyticsRepository;

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

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
