import 'package:equatable/equatable.dart';

import '../app_database.dart';

class CatalogItem extends Equatable {
  const CatalogItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.price,
    required this.stock,
    required this.isPopular,
    required this.remoteUpdatedAt,
    required this.cachedAt,
  });

  final String id;
  final String title;
  final String summary;
  final String category;
  final double price;
  final int stock;
  final bool isPopular;
  final DateTime remoteUpdatedAt;
  final DateTime cachedAt;

  factory CatalogItem.fromRow(CatalogEntry row) {
    return CatalogItem(
      id: row.id,
      title: row.title,
      summary: row.summary,
      category: row.category,
      price: row.price,
      stock: row.stock,
      isPopular: row.isPopular,
      remoteUpdatedAt: row.remoteUpdatedAt,
      cachedAt: row.cachedAt,
    );
  }

  CatalogEntriesCompanion toCompanion() {
    return CatalogEntriesCompanion.insert(
      id: id,
      title: title,
      summary: summary,
      category: category,
      price: price,
      stock: stock,
      isPopular: isPopular,
      remoteUpdatedAt: remoteUpdatedAt,
      cachedAt: cachedAt,
    );
  }

  CatalogItem copyWith({
    String? id,
    String? title,
    String? summary,
    String? category,
    double? price,
    int? stock,
    bool? isPopular,
    DateTime? remoteUpdatedAt,
    DateTime? cachedAt,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      isPopular: isPopular ?? this.isPopular,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    summary,
    category,
    price,
    stock,
    isPopular,
    remoteUpdatedAt,
    cachedAt,
  ];
}
