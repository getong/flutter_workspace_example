import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../data/repositories/layout_catalog_repository.dart';
import '../domain/layout_item.dart';

enum LayoutCatalogStatus { initial, loading, success, failure }

enum LayoutCatalogFilter { all, row, column }

enum LayoutCatalogSource { none, driftCache, network }

const Object _layoutCatalogSentinel = Object();

class LayoutCatalogState {
  const LayoutCatalogState({
    this.status = LayoutCatalogStatus.initial,
    this.items = const <LayoutItem>[],
    this.filter = LayoutCatalogFilter.all,
    this.errorMessage,
    this.lastUpdatedAt,
    this.source = LayoutCatalogSource.none,
  });

  final LayoutCatalogStatus status;
  final List<LayoutItem> items;
  final LayoutCatalogFilter filter;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;
  final LayoutCatalogSource source;

  List<LayoutItem> get visibleItems {
    switch (filter) {
      case LayoutCatalogFilter.all:
        return items;
      case LayoutCatalogFilter.row:
        return items
            .where((LayoutItem item) => item.kind == LayoutKind.row)
            .toList();
      case LayoutCatalogFilter.column:
        return items
            .where((LayoutItem item) => item.kind == LayoutKind.column)
            .toList();
    }
  }

  LayoutCatalogState copyWith({
    LayoutCatalogStatus? status,
    List<LayoutItem>? items,
    LayoutCatalogFilter? filter,
    String? errorMessage,
    Object? lastUpdatedAt = _layoutCatalogSentinel,
    LayoutCatalogSource? source,
    bool clearError = false,
  }) {
    return LayoutCatalogState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdatedAt: identical(lastUpdatedAt, _layoutCatalogSentinel)
          ? this.lastUpdatedAt
          : lastUpdatedAt as DateTime?,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'filter': filter.name};
  }

  factory LayoutCatalogState.fromJson(Map<String, dynamic> json) {
    final String rawFilter = (json['filter'] ?? LayoutCatalogFilter.all.name)
        .toString();

    return LayoutCatalogState(
      filter: LayoutCatalogFilter.values.firstWhere(
        (LayoutCatalogFilter value) => value.name == rawFilter,
        orElse: () => LayoutCatalogFilter.all,
      ),
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

class LayoutCatalogFilterChanged extends LayoutCatalogEvent {
  const LayoutCatalogFilterChanged(this.filter);

  final LayoutCatalogFilter filter;
}

class LayoutCatalogBloc
    extends HydratedBloc<LayoutCatalogEvent, LayoutCatalogState> {
  LayoutCatalogBloc(this._repository) : super(const LayoutCatalogState()) {
    on<LayoutCatalogBootstrapRequested>(_onBootstrapRequested);
    on<LayoutCatalogRefreshRequested>(_onRefreshRequested);
    on<LayoutCatalogFilterChanged>(_onFilterChanged);
  }

  final LayoutCatalogRepository _repository;

  Future<void> _onBootstrapRequested(
    LayoutCatalogBootstrapRequested event,
    Emitter<LayoutCatalogState> emit,
  ) async {
    final CachedLayoutCatalog cachedCatalog = await _repository
        .readCachedCatalog();
    if (cachedCatalog.items.isNotEmpty) {
      emit(
        state.copyWith(
          status: LayoutCatalogStatus.success,
          items: cachedCatalog.items,
          lastUpdatedAt: cachedCatalog.cachedAt,
          source: LayoutCatalogSource.driftCache,
          clearError: true,
        ),
      );
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

  void _onFilterChanged(
    LayoutCatalogFilterChanged event,
    Emitter<LayoutCatalogState> emit,
  ) {
    if (event.filter == state.filter) {
      return;
    }
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _fetchFromNetwork(Emitter<LayoutCatalogState> emit) async {
    emit(state.copyWith(status: LayoutCatalogStatus.loading, clearError: true));

    try {
      final CachedLayoutCatalog refreshedCatalog = await _repository
          .refreshCatalog();
      emit(
        state.copyWith(
          status: LayoutCatalogStatus.success,
          items: refreshedCatalog.items,
          lastUpdatedAt: refreshedCatalog.cachedAt,
          source: LayoutCatalogSource.network,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: LayoutCatalogStatus.failure,
          errorMessage: _toEnglishErrorMessage(error),
        ),
      );
    }
  }

  String _toEnglishErrorMessage(Object error) {
    if (error is DioException) {
      if (_isTimeout(error)) {
        return 'The layout request timed out. Cached Drift data is kept, '
            'so please try refreshing again when the network is stable.';
      }
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

  bool _isTimeout(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.error is TimeoutException;
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
    return LayoutCatalogState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LayoutCatalogState state) {
    return state.toJson();
  }
}
