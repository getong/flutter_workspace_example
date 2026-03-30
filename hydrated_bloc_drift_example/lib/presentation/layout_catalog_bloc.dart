import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dio/dio.dart';

import '../data/remote/layout_api_client.dart';
import '../domain/layout_item.dart';

enum LayoutCatalogStatus { initial, loading, success, failure }

class LayoutCatalogState {
  const LayoutCatalogState({
    this.status = LayoutCatalogStatus.initial,
    this.items = const <LayoutItem>[],
    this.errorMessage,
    this.lastUpdatedAt,
    this.loadedFromDrift = false,
  });

  final LayoutCatalogStatus status;
  final List<LayoutItem> items;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;
  final bool loadedFromDrift;

  LayoutCatalogState copyWith({
    LayoutCatalogStatus? status,
    List<LayoutItem>? items,
    String? errorMessage,
    DateTime? lastUpdatedAt,
    bool? loadedFromDrift,
    bool clearError = false,
  }) {
    return LayoutCatalogState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      loadedFromDrift: loadedFromDrift ?? this.loadedFromDrift,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status.name,
      'items': items.map((LayoutItem item) => item.toJson()).toList(),
      'errorMessage': errorMessage,
      'lastUpdatedAt': lastUpdatedAt?.millisecondsSinceEpoch,
      'loadedFromDrift': loadedFromDrift,
    };
  }

  factory LayoutCatalogState.fromJson(Map<String, dynamic> json) {
    final List<LayoutItem> deserializedItems = <LayoutItem>[];
    final dynamic rawItems = json['items'];
    if (rawItems is List) {
      for (final dynamic item in rawItems) {
        if (item is Map) {
          deserializedItems.add(
            LayoutItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    final String statusName =
        (json['status'] ?? LayoutCatalogStatus.initial.name).toString();
    final int? rawUpdatedAt = (json['lastUpdatedAt'] as num?)?.toInt();

    return LayoutCatalogState(
      status: LayoutCatalogStatus.values.firstWhere(
        (LayoutCatalogStatus status) => status.name == statusName,
        orElse: () => LayoutCatalogStatus.initial,
      ),
      items: deserializedItems,
      errorMessage: json['errorMessage']?.toString(),
      lastUpdatedAt: rawUpdatedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(rawUpdatedAt),
      loadedFromDrift: json['loadedFromDrift'] == true,
    );
  }
}

sealed class LayoutCatalogEvent {
  const LayoutCatalogEvent();
}

class LayoutCatalogBootstrapRequested extends LayoutCatalogEvent {
  const LayoutCatalogBootstrapRequested();
}

class LayoutCatalogRefreshRequested extends LayoutCatalogEvent {
  const LayoutCatalogRefreshRequested();
}

class LayoutCatalogBloc
    extends HydratedBloc<LayoutCatalogEvent, LayoutCatalogState> {
  LayoutCatalogBloc(this._apiClient) : super(const LayoutCatalogState()) {
    on<LayoutCatalogBootstrapRequested>(_onBootstrapRequested);
    on<LayoutCatalogRefreshRequested>(_onRefreshRequested);
  }

  final LayoutApiClient _apiClient;

  Future<void> _onBootstrapRequested(
    LayoutCatalogBootstrapRequested event,
    Emitter<LayoutCatalogState> emit,
  ) async {
    if (state.items.isNotEmpty) {
      emit(state.copyWith(loadedFromDrift: true, clearError: true));
      return;
    }
    await _fetchFromNetwork(emit);
  }

  Future<void> _onRefreshRequested(
    LayoutCatalogRefreshRequested event,
    Emitter<LayoutCatalogState> emit,
  ) async {
    await _fetchFromNetwork(emit);
  }

  Future<void> _fetchFromNetwork(Emitter<LayoutCatalogState> emit) async {
    emit(
      state.copyWith(
        status: LayoutCatalogStatus.loading,
        clearError: true,
        loadedFromDrift: false,
      ),
    );

    try {
      final List<LayoutItem> layouts = await _apiClient.fetchLayouts();
      emit(
        state.copyWith(
          status: LayoutCatalogStatus.success,
          items: layouts,
          lastUpdatedAt: DateTime.now(),
          loadedFromDrift: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: LayoutCatalogStatus.failure,
          errorMessage: _toEnglishErrorMessage(error),
          loadedFromDrift: false,
        ),
      );
    }
  }

  String _toEnglishErrorMessage(Object error) {
    if (error is DioException) {
      final int? statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return 'Request failed with HTTP status code $statusCode. '
            'Please check your network or try again later.';
      }
      return 'Network request failed. Please check your internet connection '
          'and try again.';
    }
    return 'Unexpected error: $error';
  }

  LayoutItem? findBySlug(String slug) {
    for (final LayoutItem item in state.items) {
      if (item.slug == slug) {
        return item;
      }
    }
    return null;
  }

  @override
  LayoutCatalogState? fromJson(Map<String, dynamic> json) {
    return LayoutCatalogState.fromJson(json).copyWith(loadedFromDrift: true);
  }

  @override
  Map<String, dynamic>? toJson(LayoutCatalogState state) {
    return state.toJson();
  }
}
