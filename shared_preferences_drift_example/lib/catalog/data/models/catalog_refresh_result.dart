import 'package:equatable/equatable.dart';

class CatalogRefreshResult extends Equatable {
  const CatalogRefreshResult({
    required this.didRefresh,
    required this.servedFromCache,
    required this.message,
  });

  final bool didRefresh;
  final bool servedFromCache;
  final String message;

  @override
  List<Object?> get props => <Object?>[didRefresh, servedFromCache, message];
}
