// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_value_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuiltValueReleaseStatus _$draft = const BuiltValueReleaseStatus._(
  'draft',
);
const BuiltValueReleaseStatus _$review = const BuiltValueReleaseStatus._(
  'review',
);
const BuiltValueReleaseStatus _$shipped = const BuiltValueReleaseStatus._(
  'shipped',
);

BuiltValueReleaseStatus _$builtValueReleaseStatusValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$draft;
    case 'review':
      return _$review;
    case 'shipped':
      return _$shipped;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuiltValueReleaseStatus> _$builtValueReleaseStatusValues =
    BuiltSet<BuiltValueReleaseStatus>(const <BuiltValueReleaseStatus>[
      _$draft,
      _$review,
      _$shipped,
    ]);

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(BuiltValueDemoPackage.serializer)
          ..add(BuiltValueFeatureBadge.serializer)
          ..add(BuiltValueReleaseStatus.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(BuiltValueFeatureBadge),
            ]),
            () => ListBuilder<BuiltValueFeatureBadge>(),
          ))
        .build();
Serializer<BuiltValueReleaseStatus> _$builtValueReleaseStatusSerializer =
    _$BuiltValueReleaseStatusSerializer();
Serializer<BuiltValueFeatureBadge> _$builtValueFeatureBadgeSerializer =
    _$BuiltValueFeatureBadgeSerializer();
Serializer<BuiltValueDemoPackage> _$builtValueDemoPackageSerializer =
    _$BuiltValueDemoPackageSerializer();

class _$BuiltValueReleaseStatusSerializer
    implements PrimitiveSerializer<BuiltValueReleaseStatus> {
  @override
  final Iterable<Type> types = const <Type>[BuiltValueReleaseStatus];
  @override
  final String wireName = 'BuiltValueReleaseStatus';

  @override
  Object serialize(
    Serializers serializers,
    BuiltValueReleaseStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => object.name;

  @override
  BuiltValueReleaseStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => BuiltValueReleaseStatus.valueOf(serialized as String);
}

class _$BuiltValueFeatureBadgeSerializer
    implements StructuredSerializer<BuiltValueFeatureBadge> {
  @override
  final Iterable<Type> types = const [
    BuiltValueFeatureBadge,
    _$BuiltValueFeatureBadge,
  ];
  @override
  final String wireName = 'BuiltValueFeatureBadge';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    BuiltValueFeatureBadge object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'label',
      serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      ),
      'tone',
      serializers.serialize(object.tone, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BuiltValueFeatureBadge deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuiltValueFeatureBadgeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'label':
          result.label =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'tone':
          result.tone =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltValueDemoPackageSerializer
    implements StructuredSerializer<BuiltValueDemoPackage> {
  @override
  final Iterable<Type> types = const [
    BuiltValueDemoPackage,
    _$BuiltValueDemoPackage,
  ];
  @override
  final String wireName = 'BuiltValueDemoPackage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    BuiltValueDemoPackage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'package_name',
      serializers.serialize(
        object.packageName,
        specifiedType: const FullType(String),
      ),
      'maintainer',
      serializers.serialize(
        object.maintainer,
        specifiedType: const FullType(String),
      ),
      'status',
      serializers.serialize(
        object.status,
        specifiedType: const FullType(BuiltValueReleaseStatus),
      ),
      'weekly_downloads',
      serializers.serialize(
        object.weeklyDownloads,
        specifiedType: const FullType(int),
      ),
      'badges',
      serializers.serialize(
        object.badges,
        specifiedType: const FullType(BuiltList, const [
          const FullType(BuiltValueFeatureBadge),
        ]),
      ),
      'updated_at',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      ),
    ];

    return result;
  }

  @override
  BuiltValueDemoPackage deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuiltValueDemoPackageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'package_name':
          result.packageName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'maintainer':
          result.maintainer =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltValueReleaseStatus),
                  )!
                  as BuiltValueReleaseStatus;
          break;
        case 'weekly_downloads':
          result.weeklyDownloads =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'badges':
          result.badges.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(BuiltValueFeatureBadge),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'updated_at':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltValueFeatureBadge extends BuiltValueFeatureBadge {
  @override
  final String label;
  @override
  final String tone;

  factory _$BuiltValueFeatureBadge([
    void Function(BuiltValueFeatureBadgeBuilder)? updates,
  ]) => (BuiltValueFeatureBadgeBuilder()..update(updates))._build();

  _$BuiltValueFeatureBadge._({required this.label, required this.tone})
    : super._();
  @override
  BuiltValueFeatureBadge rebuild(
    void Function(BuiltValueFeatureBadgeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BuiltValueFeatureBadgeBuilder toBuilder() =>
      BuiltValueFeatureBadgeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltValueFeatureBadge &&
        label == other.label &&
        tone == other.tone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, tone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuiltValueFeatureBadge')
          ..add('label', label)
          ..add('tone', tone))
        .toString();
  }
}

class BuiltValueFeatureBadgeBuilder
    implements Builder<BuiltValueFeatureBadge, BuiltValueFeatureBadgeBuilder> {
  _$BuiltValueFeatureBadge? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _tone;
  String? get tone => _$this._tone;
  set tone(String? tone) => _$this._tone = tone;

  BuiltValueFeatureBadgeBuilder();

  BuiltValueFeatureBadgeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _tone = $v.tone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltValueFeatureBadge other) {
    _$v = other as _$BuiltValueFeatureBadge;
  }

  @override
  void update(void Function(BuiltValueFeatureBadgeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuiltValueFeatureBadge build() => _build();

  _$BuiltValueFeatureBadge _build() {
    final _$result =
        _$v ??
        _$BuiltValueFeatureBadge._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'BuiltValueFeatureBadge',
            'label',
          ),
          tone: BuiltValueNullFieldError.checkNotNull(
            tone,
            r'BuiltValueFeatureBadge',
            'tone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

class _$BuiltValueDemoPackage extends BuiltValueDemoPackage {
  @override
  final String id;
  @override
  final String packageName;
  @override
  final String maintainer;
  @override
  final BuiltValueReleaseStatus status;
  @override
  final int weeklyDownloads;
  @override
  final BuiltList<BuiltValueFeatureBadge> badges;
  @override
  final DateTime updatedAt;

  factory _$BuiltValueDemoPackage([
    void Function(BuiltValueDemoPackageBuilder)? updates,
  ]) => (BuiltValueDemoPackageBuilder()..update(updates))._build();

  _$BuiltValueDemoPackage._({
    required this.id,
    required this.packageName,
    required this.maintainer,
    required this.status,
    required this.weeklyDownloads,
    required this.badges,
    required this.updatedAt,
  }) : super._();
  @override
  BuiltValueDemoPackage rebuild(
    void Function(BuiltValueDemoPackageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BuiltValueDemoPackageBuilder toBuilder() =>
      BuiltValueDemoPackageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltValueDemoPackage &&
        id == other.id &&
        packageName == other.packageName &&
        maintainer == other.maintainer &&
        status == other.status &&
        weeklyDownloads == other.weeklyDownloads &&
        badges == other.badges &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, packageName.hashCode);
    _$hash = $jc(_$hash, maintainer.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, weeklyDownloads.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuiltValueDemoPackage')
          ..add('id', id)
          ..add('packageName', packageName)
          ..add('maintainer', maintainer)
          ..add('status', status)
          ..add('weeklyDownloads', weeklyDownloads)
          ..add('badges', badges)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class BuiltValueDemoPackageBuilder
    implements Builder<BuiltValueDemoPackage, BuiltValueDemoPackageBuilder> {
  _$BuiltValueDemoPackage? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _packageName;
  String? get packageName => _$this._packageName;
  set packageName(String? packageName) => _$this._packageName = packageName;

  String? _maintainer;
  String? get maintainer => _$this._maintainer;
  set maintainer(String? maintainer) => _$this._maintainer = maintainer;

  BuiltValueReleaseStatus? _status;
  BuiltValueReleaseStatus? get status => _$this._status;
  set status(BuiltValueReleaseStatus? status) => _$this._status = status;

  int? _weeklyDownloads;
  int? get weeklyDownloads => _$this._weeklyDownloads;
  set weeklyDownloads(int? weeklyDownloads) =>
      _$this._weeklyDownloads = weeklyDownloads;

  ListBuilder<BuiltValueFeatureBadge>? _badges;
  ListBuilder<BuiltValueFeatureBadge> get badges =>
      _$this._badges ??= ListBuilder<BuiltValueFeatureBadge>();
  set badges(ListBuilder<BuiltValueFeatureBadge>? badges) =>
      _$this._badges = badges;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  BuiltValueDemoPackageBuilder() {
    BuiltValueDemoPackage._initializeBuilder(this);
  }

  BuiltValueDemoPackageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _packageName = $v.packageName;
      _maintainer = $v.maintainer;
      _status = $v.status;
      _weeklyDownloads = $v.weeklyDownloads;
      _badges = $v.badges.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltValueDemoPackage other) {
    _$v = other as _$BuiltValueDemoPackage;
  }

  @override
  void update(void Function(BuiltValueDemoPackageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuiltValueDemoPackage build() => _build();

  _$BuiltValueDemoPackage _build() {
    _$BuiltValueDemoPackage _$result;
    try {
      _$result =
          _$v ??
          _$BuiltValueDemoPackage._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'BuiltValueDemoPackage',
              'id',
            ),
            packageName: BuiltValueNullFieldError.checkNotNull(
              packageName,
              r'BuiltValueDemoPackage',
              'packageName',
            ),
            maintainer: BuiltValueNullFieldError.checkNotNull(
              maintainer,
              r'BuiltValueDemoPackage',
              'maintainer',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'BuiltValueDemoPackage',
              'status',
            ),
            weeklyDownloads: BuiltValueNullFieldError.checkNotNull(
              weeklyDownloads,
              r'BuiltValueDemoPackage',
              'weeklyDownloads',
            ),
            badges: badges.build(),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'BuiltValueDemoPackage',
              'updatedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'badges';
        badges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'BuiltValueDemoPackage',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
