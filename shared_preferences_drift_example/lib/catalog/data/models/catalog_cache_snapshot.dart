import 'package:equatable/equatable.dart';

class CatalogCacheSnapshot extends Equatable {
  const CatalogCacheSnapshot({
    required this.lastSyncAt,
    required this.isExpired,
    required this.localItemCount,
    required this.cacheTtl,
  });

  final DateTime? lastSyncAt;
  final bool isExpired;
  final int localItemCount;
  final Duration cacheTtl;

  @override
  List<Object?> get props => <Object?>[
    lastSyncAt,
    isExpired,
    localItemCount,
    cacheTtl,
  ];
}
