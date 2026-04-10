import 'package:equatable/equatable.dart';

import '../data/models/catalog_item.dart';

enum CatalogStatus { initial, loading, loaded, failure }

final class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.items = const <CatalogItem>[],
    this.isRefreshing = false,
    this.lastSyncAt,
    this.isCacheExpired = true,
    this.statusMessage = 'Waiting for the first cache lookup.',
    this.errorMessage,
    this.cacheTtl = const Duration(minutes: 5),
  });

  final CatalogStatus status;
  final List<CatalogItem> items;
  final bool isRefreshing;
  final DateTime? lastSyncAt;
  final bool isCacheExpired;
  final String statusMessage;
  final String? errorMessage;
  final Duration cacheTtl;

  bool get showInitialLoader =>
      status == CatalogStatus.loading && items.isEmpty;

  CatalogState copyWith({
    CatalogStatus? status,
    List<CatalogItem>? items,
    bool? isRefreshing,
    DateTime? lastSyncAt,
    bool clearLastSyncAt = false,
    bool? isCacheExpired,
    String? statusMessage,
    String? errorMessage,
    bool clearErrorMessage = false,
    Duration? cacheTtl,
  }) {
    return CatalogState(
      status: status ?? this.status,
      items: items ?? this.items,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastSyncAt: clearLastSyncAt ? null : lastSyncAt ?? this.lastSyncAt,
      isCacheExpired: isCacheExpired ?? this.isCacheExpired,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      cacheTtl: cacheTtl ?? this.cacheTtl,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    items,
    isRefreshing,
    lastSyncAt,
    isCacheExpired,
    statusMessage,
    errorMessage,
    cacheTtl,
  ];
}
