import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/data.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required CatalogRepository repository})
    : _repository = repository,
      super(const CatalogState()) {
    on<CatalogStarted>(_onStarted);
    on<CatalogRefreshRequested>(_onRefreshRequested);
    on<CatalogItemsUpdated>(_onItemsUpdated);
  }

  final CatalogRepository _repository;
  StreamSubscription<List<CatalogItem>>? _itemsSubscription;

  Future<void> _onStarted(
    CatalogStarted event,
    Emitter<CatalogState> emit,
  ) async {
    await _ensureItemsSubscription();
    emit(
      state.copyWith(
        status: CatalogStatus.loading,
        isRefreshing: true,
        statusMessage: 'Reading drift cache and sync metadata...',
        clearErrorMessage: true,
      ),
    );

    try {
      final result = await _repository.ensureHydrated();
      await _emitSnapshot(emit, statusMessage: result.message);
    } catch (error) {
      emit(
        state.copyWith(
          status: state.items.isEmpty
              ? CatalogStatus.failure
              : CatalogStatus.loaded,
          isRefreshing: false,
          errorMessage: 'Unable to hydrate the catalogue cache: $error',
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    CatalogRefreshRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(
      state.copyWith(
        status: state.items.isEmpty ? CatalogStatus.loading : state.status,
        isRefreshing: true,
        statusMessage: 'Refreshing from the fake remote datasource...',
        clearErrorMessage: true,
      ),
    );

    try {
      final result = await _repository.refresh(force: event.force);
      await _emitSnapshot(emit, statusMessage: result.message);
    } catch (error) {
      emit(
        state.copyWith(
          status: state.items.isEmpty
              ? CatalogStatus.failure
              : CatalogStatus.loaded,
          isRefreshing: false,
          errorMessage:
              'Refresh failed. Serving local data when available. $error',
        ),
      );
    }
  }

  void _onItemsUpdated(CatalogItemsUpdated event, Emitter<CatalogState> emit) {
    emit(state.copyWith(items: event.items, status: CatalogStatus.loaded));
  }

  Future<void> _ensureItemsSubscription() async {
    _itemsSubscription ??= _repository.watchItems().listen(
      (List<CatalogItem> items) => add(CatalogItemsUpdated(items)),
    );
  }

  Future<void> _emitSnapshot(
    Emitter<CatalogState> emit, {
    required String statusMessage,
  }) async {
    final snapshot = await _repository.getCacheSnapshot();
    emit(
      state.copyWith(
        status: CatalogStatus.loaded,
        isRefreshing: false,
        lastSyncAt: snapshot.lastSyncAt,
        isCacheExpired: snapshot.isExpired,
        statusMessage: statusMessage,
        cacheTtl: snapshot.cacheTtl,
        clearErrorMessage: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _itemsSubscription?.cancel();
    return super.close();
  }
}
