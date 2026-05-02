import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed_annotation_models.freezed.dart';
part 'freezed_annotation_models.g.dart';

@freezed
abstract class FreezedProfile with _$FreezedProfile {
  const factory FreezedProfile({
    required String id,
    required String name,
    @Default(<String>[]) List<String> tags,
    @Default(false) bool isPro,
    @Default(0) int completedMissions,
  }) = _FreezedProfile;

  factory FreezedProfile.fromJson(Map<String, dynamic> json) =>
      _$FreezedProfileFromJson(json);
}

@freezed
abstract class FreezedSyncState with _$FreezedSyncState {
  const factory FreezedSyncState.idle({required FreezedProfile profile}) =
      _FreezedSyncStateIdle;

  const factory FreezedSyncState.syncing({
    required FreezedProfile profile,
    @Default(0.0) double progress,
  }) = _FreezedSyncStateSyncing;

  const factory FreezedSyncState.success({
    required FreezedProfile profile,
    required DateTime syncedAt,
  }) = _FreezedSyncStateSuccess;

  const factory FreezedSyncState.failure({
    required FreezedProfile profile,
    required String message,
  }) = _FreezedSyncStateFailure;

  factory FreezedSyncState.fromJson(Map<String, dynamic> json) =>
      _$FreezedSyncStateFromJson(json);
}
