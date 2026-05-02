import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'built_value_models.g.dart';

class BuiltValueReleaseStatus extends EnumClass {
  const BuiltValueReleaseStatus._(super.name);

  static const BuiltValueReleaseStatus draft = _$draft;
  static const BuiltValueReleaseStatus review = _$review;
  static const BuiltValueReleaseStatus shipped = _$shipped;

  static BuiltSet<BuiltValueReleaseStatus> get values =>
      _$builtValueReleaseStatusValues;

  static BuiltValueReleaseStatus valueOf(String name) =>
      _$builtValueReleaseStatusValueOf(name);

  static Serializer<BuiltValueReleaseStatus> get serializer =>
      _$builtValueReleaseStatusSerializer;
}

abstract class BuiltValueFeatureBadge
    implements Built<BuiltValueFeatureBadge, BuiltValueFeatureBadgeBuilder> {
  factory BuiltValueFeatureBadge([
    void Function(BuiltValueFeatureBadgeBuilder) updates,
  ]) = _$BuiltValueFeatureBadge;

  BuiltValueFeatureBadge._();

  String get label;
  String get tone;

  static Serializer<BuiltValueFeatureBadge> get serializer =>
      _$builtValueFeatureBadgeSerializer;
}

abstract class BuiltValueDemoPackage
    implements Built<BuiltValueDemoPackage, BuiltValueDemoPackageBuilder> {
  factory BuiltValueDemoPackage([
    void Function(BuiltValueDemoPackageBuilder) updates,
  ]) = _$BuiltValueDemoPackage;

  BuiltValueDemoPackage._() {
    if (weeklyDownloads < 0) {
      throw ArgumentError.value(
        weeklyDownloads,
        'weeklyDownloads',
        'Must not be negative.',
      );
    }
  }

  static void _initializeBuilder(BuiltValueDemoPackageBuilder builder) =>
      builder
        ..maintainer = 'Flutter UI Lab'
        ..status = BuiltValueReleaseStatus.review
        ..weeklyDownloads = 0;

  String get id;

  @BuiltValueField(wireName: 'package_name')
  String get packageName;

  String get maintainer;

  BuiltValueReleaseStatus get status;

  @BuiltValueField(wireName: 'weekly_downloads')
  int get weeklyDownloads;

  BuiltList<BuiltValueFeatureBadge> get badges;

  @BuiltValueField(wireName: 'updated_at')
  DateTime get updatedAt;

  static Serializer<BuiltValueDemoPackage> get serializer =>
      _$builtValueDemoPackageSerializer;

  Map<String, dynamic> toJson() {
    final Object? serialized = serializers.serializeWith(
      BuiltValueDemoPackage.serializer,
      this,
    );
    return Map<String, dynamic>.from(serialized! as Map<Object?, Object?>);
  }

  static BuiltValueDemoPackage fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuiltValueDemoPackage.serializer, json)!;
  }
}

@SerializersFor(<Type>[
  BuiltValueFeatureBadge,
  BuiltValueDemoPackage,
  BuiltValueReleaseStatus,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
