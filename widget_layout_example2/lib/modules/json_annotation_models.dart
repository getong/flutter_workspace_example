import 'package:json_annotation/json_annotation.dart';

part 'json_annotation_models.g.dart';

double _centsToDollars(int cents) => cents / 100;

int _dollarsToCents(double dollars) => (dollars * 100).round();

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class JsonCatalogEntry {
  const JsonCatalogEntry({
    required this.id,
    required this.title,
    required this.seller,
    required this.prices,
    required this.metadata,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final JsonSeller seller;
  final List<JsonPricePoint> prices;
  final Map<String, dynamic> metadata;
  final DateTime publishedAt;

  factory JsonCatalogEntry.fromJson(Map<String, dynamic> json) =>
      _$JsonCatalogEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCatalogEntryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class JsonSeller {
  const JsonSeller({required this.handle, required this.rating, this.region});

  final String handle;
  final double rating;
  final String? region;

  factory JsonSeller.fromJson(Map<String, dynamic> json) =>
      _$JsonSellerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSellerToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class JsonPricePoint {
  const JsonPricePoint({
    required this.tier,
    required this.unitPrice,
    required this.currency,
  });

  final String tier;

  @JsonKey(fromJson: _centsToDollars, toJson: _dollarsToCents)
  final double unitPrice;

  final String currency;

  factory JsonPricePoint.fromJson(Map<String, dynamic> json) =>
      _$JsonPricePointFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPricePointToJson(this);
}
