// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed_annotation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreezedProfile {

 String get id; String get name; List<String> get tags; bool get isPro; int get completedMissions;
/// Create a copy of FreezedProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreezedProfileCopyWith<FreezedProfile> get copyWith => _$FreezedProfileCopyWithImpl<FreezedProfile>(this as FreezedProfile, _$identity);

  /// Serializes this FreezedProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreezedProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.completedMissions, completedMissions) || other.completedMissions == completedMissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(tags),isPro,completedMissions);

@override
String toString() {
  return 'FreezedProfile(id: $id, name: $name, tags: $tags, isPro: $isPro, completedMissions: $completedMissions)';
}


}

/// @nodoc
abstract mixin class $FreezedProfileCopyWith<$Res>  {
  factory $FreezedProfileCopyWith(FreezedProfile value, $Res Function(FreezedProfile) _then) = _$FreezedProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> tags, bool isPro, int completedMissions
});




}
/// @nodoc
class _$FreezedProfileCopyWithImpl<$Res>
    implements $FreezedProfileCopyWith<$Res> {
  _$FreezedProfileCopyWithImpl(this._self, this._then);

  final FreezedProfile _self;
  final $Res Function(FreezedProfile) _then;

/// Create a copy of FreezedProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tags = null,Object? isPro = null,Object? completedMissions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,completedMissions: null == completedMissions ? _self.completedMissions : completedMissions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FreezedProfile].
extension FreezedProfilePatterns on FreezedProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FreezedProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreezedProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FreezedProfile value)  $default,){
final _that = this;
switch (_that) {
case _FreezedProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FreezedProfile value)?  $default,){
final _that = this;
switch (_that) {
case _FreezedProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> tags,  bool isPro,  int completedMissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreezedProfile() when $default != null:
return $default(_that.id,_that.name,_that.tags,_that.isPro,_that.completedMissions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> tags,  bool isPro,  int completedMissions)  $default,) {final _that = this;
switch (_that) {
case _FreezedProfile():
return $default(_that.id,_that.name,_that.tags,_that.isPro,_that.completedMissions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> tags,  bool isPro,  int completedMissions)?  $default,) {final _that = this;
switch (_that) {
case _FreezedProfile() when $default != null:
return $default(_that.id,_that.name,_that.tags,_that.isPro,_that.completedMissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FreezedProfile implements FreezedProfile {
  const _FreezedProfile({required this.id, required this.name, final  List<String> tags = const <String>[], this.isPro = false, this.completedMissions = 0}): _tags = tags;
  factory _FreezedProfile.fromJson(Map<String, dynamic> json) => _$FreezedProfileFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  bool isPro;
@override@JsonKey() final  int completedMissions;

/// Create a copy of FreezedProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreezedProfileCopyWith<_FreezedProfile> get copyWith => __$FreezedProfileCopyWithImpl<_FreezedProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreezedProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreezedProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.completedMissions, completedMissions) || other.completedMissions == completedMissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_tags),isPro,completedMissions);

@override
String toString() {
  return 'FreezedProfile(id: $id, name: $name, tags: $tags, isPro: $isPro, completedMissions: $completedMissions)';
}


}

/// @nodoc
abstract mixin class _$FreezedProfileCopyWith<$Res> implements $FreezedProfileCopyWith<$Res> {
  factory _$FreezedProfileCopyWith(_FreezedProfile value, $Res Function(_FreezedProfile) _then) = __$FreezedProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> tags, bool isPro, int completedMissions
});




}
/// @nodoc
class __$FreezedProfileCopyWithImpl<$Res>
    implements _$FreezedProfileCopyWith<$Res> {
  __$FreezedProfileCopyWithImpl(this._self, this._then);

  final _FreezedProfile _self;
  final $Res Function(_FreezedProfile) _then;

/// Create a copy of FreezedProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tags = null,Object? isPro = null,Object? completedMissions = null,}) {
  return _then(_FreezedProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,completedMissions: null == completedMissions ? _self.completedMissions : completedMissions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

FreezedSyncState _$FreezedSyncStateFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'idle':
          return _FreezedSyncStateIdle.fromJson(
            json
          );
                case 'syncing':
          return _FreezedSyncStateSyncing.fromJson(
            json
          );
                case 'success':
          return _FreezedSyncStateSuccess.fromJson(
            json
          );
                case 'failure':
          return _FreezedSyncStateFailure.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'FreezedSyncState',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$FreezedSyncState {

 FreezedProfile get profile;
/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreezedSyncStateCopyWith<FreezedSyncState> get copyWith => _$FreezedSyncStateCopyWithImpl<FreezedSyncState>(this as FreezedSyncState, _$identity);

  /// Serializes this FreezedSyncState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreezedSyncState&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'FreezedSyncState(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $FreezedSyncStateCopyWith<$Res>  {
  factory $FreezedSyncStateCopyWith(FreezedSyncState value, $Res Function(FreezedSyncState) _then) = _$FreezedSyncStateCopyWithImpl;
@useResult
$Res call({
 FreezedProfile profile
});


$FreezedProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$FreezedSyncStateCopyWithImpl<$Res>
    implements $FreezedSyncStateCopyWith<$Res> {
  _$FreezedSyncStateCopyWithImpl(this._self, this._then);

  final FreezedSyncState _self;
  final $Res Function(FreezedSyncState) _then;

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,}) {
  return _then(_self.copyWith(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as FreezedProfile,
  ));
}
/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreezedProfileCopyWith<$Res> get profile {
  
  return $FreezedProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [FreezedSyncState].
extension FreezedSyncStatePatterns on FreezedSyncState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _FreezedSyncStateIdle value)?  idle,TResult Function( _FreezedSyncStateSyncing value)?  syncing,TResult Function( _FreezedSyncStateSuccess value)?  success,TResult Function( _FreezedSyncStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreezedSyncStateIdle() when idle != null:
return idle(_that);case _FreezedSyncStateSyncing() when syncing != null:
return syncing(_that);case _FreezedSyncStateSuccess() when success != null:
return success(_that);case _FreezedSyncStateFailure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _FreezedSyncStateIdle value)  idle,required TResult Function( _FreezedSyncStateSyncing value)  syncing,required TResult Function( _FreezedSyncStateSuccess value)  success,required TResult Function( _FreezedSyncStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case _FreezedSyncStateIdle():
return idle(_that);case _FreezedSyncStateSyncing():
return syncing(_that);case _FreezedSyncStateSuccess():
return success(_that);case _FreezedSyncStateFailure():
return failure(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _FreezedSyncStateIdle value)?  idle,TResult? Function( _FreezedSyncStateSyncing value)?  syncing,TResult? Function( _FreezedSyncStateSuccess value)?  success,TResult? Function( _FreezedSyncStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case _FreezedSyncStateIdle() when idle != null:
return idle(_that);case _FreezedSyncStateSyncing() when syncing != null:
return syncing(_that);case _FreezedSyncStateSuccess() when success != null:
return success(_that);case _FreezedSyncStateFailure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FreezedProfile profile)?  idle,TResult Function( FreezedProfile profile,  double progress)?  syncing,TResult Function( FreezedProfile profile,  DateTime syncedAt)?  success,TResult Function( FreezedProfile profile,  String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreezedSyncStateIdle() when idle != null:
return idle(_that.profile);case _FreezedSyncStateSyncing() when syncing != null:
return syncing(_that.profile,_that.progress);case _FreezedSyncStateSuccess() when success != null:
return success(_that.profile,_that.syncedAt);case _FreezedSyncStateFailure() when failure != null:
return failure(_that.profile,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FreezedProfile profile)  idle,required TResult Function( FreezedProfile profile,  double progress)  syncing,required TResult Function( FreezedProfile profile,  DateTime syncedAt)  success,required TResult Function( FreezedProfile profile,  String message)  failure,}) {final _that = this;
switch (_that) {
case _FreezedSyncStateIdle():
return idle(_that.profile);case _FreezedSyncStateSyncing():
return syncing(_that.profile,_that.progress);case _FreezedSyncStateSuccess():
return success(_that.profile,_that.syncedAt);case _FreezedSyncStateFailure():
return failure(_that.profile,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FreezedProfile profile)?  idle,TResult? Function( FreezedProfile profile,  double progress)?  syncing,TResult? Function( FreezedProfile profile,  DateTime syncedAt)?  success,TResult? Function( FreezedProfile profile,  String message)?  failure,}) {final _that = this;
switch (_that) {
case _FreezedSyncStateIdle() when idle != null:
return idle(_that.profile);case _FreezedSyncStateSyncing() when syncing != null:
return syncing(_that.profile,_that.progress);case _FreezedSyncStateSuccess() when success != null:
return success(_that.profile,_that.syncedAt);case _FreezedSyncStateFailure() when failure != null:
return failure(_that.profile,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FreezedSyncStateIdle implements FreezedSyncState {
  const _FreezedSyncStateIdle({required this.profile, final  String? $type}): $type = $type ?? 'idle';
  factory _FreezedSyncStateIdle.fromJson(Map<String, dynamic> json) => _$FreezedSyncStateIdleFromJson(json);

@override final  FreezedProfile profile;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreezedSyncStateIdleCopyWith<_FreezedSyncStateIdle> get copyWith => __$FreezedSyncStateIdleCopyWithImpl<_FreezedSyncStateIdle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreezedSyncStateIdleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreezedSyncStateIdle&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'FreezedSyncState.idle(profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$FreezedSyncStateIdleCopyWith<$Res> implements $FreezedSyncStateCopyWith<$Res> {
  factory _$FreezedSyncStateIdleCopyWith(_FreezedSyncStateIdle value, $Res Function(_FreezedSyncStateIdle) _then) = __$FreezedSyncStateIdleCopyWithImpl;
@override @useResult
$Res call({
 FreezedProfile profile
});


@override $FreezedProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$FreezedSyncStateIdleCopyWithImpl<$Res>
    implements _$FreezedSyncStateIdleCopyWith<$Res> {
  __$FreezedSyncStateIdleCopyWithImpl(this._self, this._then);

  final _FreezedSyncStateIdle _self;
  final $Res Function(_FreezedSyncStateIdle) _then;

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(_FreezedSyncStateIdle(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as FreezedProfile,
  ));
}

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreezedProfileCopyWith<$Res> get profile {
  
  return $FreezedProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class _FreezedSyncStateSyncing implements FreezedSyncState {
  const _FreezedSyncStateSyncing({required this.profile, this.progress = 0.0, final  String? $type}): $type = $type ?? 'syncing';
  factory _FreezedSyncStateSyncing.fromJson(Map<String, dynamic> json) => _$FreezedSyncStateSyncingFromJson(json);

@override final  FreezedProfile profile;
@JsonKey() final  double progress;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreezedSyncStateSyncingCopyWith<_FreezedSyncStateSyncing> get copyWith => __$FreezedSyncStateSyncingCopyWithImpl<_FreezedSyncStateSyncing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreezedSyncStateSyncingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreezedSyncStateSyncing&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,progress);

@override
String toString() {
  return 'FreezedSyncState.syncing(profile: $profile, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$FreezedSyncStateSyncingCopyWith<$Res> implements $FreezedSyncStateCopyWith<$Res> {
  factory _$FreezedSyncStateSyncingCopyWith(_FreezedSyncStateSyncing value, $Res Function(_FreezedSyncStateSyncing) _then) = __$FreezedSyncStateSyncingCopyWithImpl;
@override @useResult
$Res call({
 FreezedProfile profile, double progress
});


@override $FreezedProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$FreezedSyncStateSyncingCopyWithImpl<$Res>
    implements _$FreezedSyncStateSyncingCopyWith<$Res> {
  __$FreezedSyncStateSyncingCopyWithImpl(this._self, this._then);

  final _FreezedSyncStateSyncing _self;
  final $Res Function(_FreezedSyncStateSyncing) _then;

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? progress = null,}) {
  return _then(_FreezedSyncStateSyncing(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as FreezedProfile,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreezedProfileCopyWith<$Res> get profile {
  
  return $FreezedProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class _FreezedSyncStateSuccess implements FreezedSyncState {
  const _FreezedSyncStateSuccess({required this.profile, required this.syncedAt, final  String? $type}): $type = $type ?? 'success';
  factory _FreezedSyncStateSuccess.fromJson(Map<String, dynamic> json) => _$FreezedSyncStateSuccessFromJson(json);

@override final  FreezedProfile profile;
 final  DateTime syncedAt;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreezedSyncStateSuccessCopyWith<_FreezedSyncStateSuccess> get copyWith => __$FreezedSyncStateSuccessCopyWithImpl<_FreezedSyncStateSuccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreezedSyncStateSuccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreezedSyncStateSuccess&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,syncedAt);

@override
String toString() {
  return 'FreezedSyncState.success(profile: $profile, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class _$FreezedSyncStateSuccessCopyWith<$Res> implements $FreezedSyncStateCopyWith<$Res> {
  factory _$FreezedSyncStateSuccessCopyWith(_FreezedSyncStateSuccess value, $Res Function(_FreezedSyncStateSuccess) _then) = __$FreezedSyncStateSuccessCopyWithImpl;
@override @useResult
$Res call({
 FreezedProfile profile, DateTime syncedAt
});


@override $FreezedProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$FreezedSyncStateSuccessCopyWithImpl<$Res>
    implements _$FreezedSyncStateSuccessCopyWith<$Res> {
  __$FreezedSyncStateSuccessCopyWithImpl(this._self, this._then);

  final _FreezedSyncStateSuccess _self;
  final $Res Function(_FreezedSyncStateSuccess) _then;

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? syncedAt = null,}) {
  return _then(_FreezedSyncStateSuccess(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as FreezedProfile,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreezedProfileCopyWith<$Res> get profile {
  
  return $FreezedProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class _FreezedSyncStateFailure implements FreezedSyncState {
  const _FreezedSyncStateFailure({required this.profile, required this.message, final  String? $type}): $type = $type ?? 'failure';
  factory _FreezedSyncStateFailure.fromJson(Map<String, dynamic> json) => _$FreezedSyncStateFailureFromJson(json);

@override final  FreezedProfile profile;
 final  String message;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreezedSyncStateFailureCopyWith<_FreezedSyncStateFailure> get copyWith => __$FreezedSyncStateFailureCopyWithImpl<_FreezedSyncStateFailure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreezedSyncStateFailureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreezedSyncStateFailure&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,message);

@override
String toString() {
  return 'FreezedSyncState.failure(profile: $profile, message: $message)';
}


}

/// @nodoc
abstract mixin class _$FreezedSyncStateFailureCopyWith<$Res> implements $FreezedSyncStateCopyWith<$Res> {
  factory _$FreezedSyncStateFailureCopyWith(_FreezedSyncStateFailure value, $Res Function(_FreezedSyncStateFailure) _then) = __$FreezedSyncStateFailureCopyWithImpl;
@override @useResult
$Res call({
 FreezedProfile profile, String message
});


@override $FreezedProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$FreezedSyncStateFailureCopyWithImpl<$Res>
    implements _$FreezedSyncStateFailureCopyWith<$Res> {
  __$FreezedSyncStateFailureCopyWithImpl(this._self, this._then);

  final _FreezedSyncStateFailure _self;
  final $Res Function(_FreezedSyncStateFailure) _then;

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? message = null,}) {
  return _then(_FreezedSyncStateFailure(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as FreezedProfile,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of FreezedSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreezedProfileCopyWith<$Res> get profile {
  
  return $FreezedProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
