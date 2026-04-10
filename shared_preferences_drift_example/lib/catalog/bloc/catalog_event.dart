import 'package:equatable/equatable.dart';

import '../data/models/catalog_item.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class CatalogStarted extends CatalogEvent {
  const CatalogStarted();
}

final class CatalogRefreshRequested extends CatalogEvent {
  const CatalogRefreshRequested({this.force = true});

  final bool force;

  @override
  List<Object?> get props => <Object?>[force];
}

final class CatalogItemsUpdated extends CatalogEvent {
  const CatalogItemsUpdated(this.items);

  final List<CatalogItem> items;

  @override
  List<Object?> get props => <Object?>[items];
}
