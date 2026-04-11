// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezed_annotation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FreezedProfile _$FreezedProfileFromJson(Map<String, dynamic> json) =>
    _FreezedProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      isPro: json['isPro'] as bool? ?? false,
      completedMissions: (json['completedMissions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FreezedProfileToJson(_FreezedProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tags': instance.tags,
      'isPro': instance.isPro,
      'completedMissions': instance.completedMissions,
    };

_FreezedSyncStateIdle _$FreezedSyncStateIdleFromJson(
  Map<String, dynamic> json,
) => _FreezedSyncStateIdle(
  profile: FreezedProfile.fromJson(json['profile'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FreezedSyncStateIdleToJson(
  _FreezedSyncStateIdle instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'runtimeType': instance.$type,
};

_FreezedSyncStateSyncing _$FreezedSyncStateSyncingFromJson(
  Map<String, dynamic> json,
) => _FreezedSyncStateSyncing(
  profile: FreezedProfile.fromJson(json['profile'] as Map<String, dynamic>),
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FreezedSyncStateSyncingToJson(
  _FreezedSyncStateSyncing instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'progress': instance.progress,
  'runtimeType': instance.$type,
};

_FreezedSyncStateSuccess _$FreezedSyncStateSuccessFromJson(
  Map<String, dynamic> json,
) => _FreezedSyncStateSuccess(
  profile: FreezedProfile.fromJson(json['profile'] as Map<String, dynamic>),
  syncedAt: DateTime.parse(json['syncedAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FreezedSyncStateSuccessToJson(
  _FreezedSyncStateSuccess instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'syncedAt': instance.syncedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

_FreezedSyncStateFailure _$FreezedSyncStateFailureFromJson(
  Map<String, dynamic> json,
) => _FreezedSyncStateFailure(
  profile: FreezedProfile.fromJson(json['profile'] as Map<String, dynamic>),
  message: json['message'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FreezedSyncStateFailureToJson(
  _FreezedSyncStateFailure instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'message': instance.message,
  'runtimeType': instance.$type,
};
