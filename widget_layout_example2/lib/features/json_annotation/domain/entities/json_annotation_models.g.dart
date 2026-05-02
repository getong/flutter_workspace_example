// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_annotation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonCatalogEntry _$JsonCatalogEntryFromJson(Map<String, dynamic> json) =>
    JsonCatalogEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      seller: JsonSeller.fromJson(json['seller'] as Map<String, dynamic>),
      prices: (json['prices'] as List<dynamic>)
          .map((e) => JsonPricePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
      publishedAt: DateTime.parse(json['published_at'] as String),
    );

Map<String, dynamic> _$JsonCatalogEntryToJson(JsonCatalogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'seller': instance.seller.toJson(),
      'prices': instance.prices.map((e) => e.toJson()).toList(),
      'metadata': instance.metadata,
      'published_at': instance.publishedAt.toIso8601String(),
    };

JsonIncomingUser _$JsonIncomingUserFromJson(Map<String, dynamic> json) =>
    JsonIncomingUser(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
    );

JsonSeller _$JsonSellerFromJson(Map<String, dynamic> json) => JsonSeller(
  handle: json['handle'] as String,
  rating: (json['rating'] as num).toDouble(),
  region: json['region'] as String?,
);

Map<String, dynamic> _$JsonSellerToJson(JsonSeller instance) =>
    <String, dynamic>{
      'handle': instance.handle,
      'rating': instance.rating,
      'region': ?instance.region,
    };

JsonPricePoint _$JsonPricePointFromJson(Map<String, dynamic> json) =>
    JsonPricePoint(
      tier: json['tier'] as String,
      unitPrice: _centsToDollars((json['unit_price'] as num).toInt()),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$JsonPricePointToJson(JsonPricePoint instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'unit_price': _dollarsToCents(instance.unitPrice),
      'currency': instance.currency,
    };
