// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Equals {
  String? get name => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EqualsCopyWith<Equals> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EqualsCopyWith<$Res> {
  factory $EqualsCopyWith(Equals value, $Res Function(Equals) then) =
      _$EqualsCopyWithImpl<$Res, Equals>;
  @useResult
  $Res call({String? name, int? age});
}

/// @nodoc
class _$EqualsCopyWithImpl<$Res, $Val extends Equals>
    implements $EqualsCopyWith<$Res> {
  _$EqualsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? age = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EqualsImplCopyWith<$Res> implements $EqualsCopyWith<$Res> {
  factory _$$EqualsImplCopyWith(
          _$EqualsImpl value, $Res Function(_$EqualsImpl) then) =
      __$$EqualsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? age});
}

/// @nodoc
class __$$EqualsImplCopyWithImpl<$Res>
    extends _$EqualsCopyWithImpl<$Res, _$EqualsImpl>
    implements _$$EqualsImplCopyWith<$Res> {
  __$$EqualsImplCopyWithImpl(
      _$EqualsImpl _value, $Res Function(_$EqualsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? age = freezed,
  }) {
    return _then(_$EqualsImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$EqualsImpl extends _Equals {
  _$EqualsImpl({this.name, this.age}) : super._();

  @override
  final String? name;
  @override
  final int? age;

  @override
  String toString() {
    return 'Equals(name: $name, age: $age)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EqualsImplCopyWith<_$EqualsImpl> get copyWith =>
      __$$EqualsImplCopyWithImpl<_$EqualsImpl>(this, _$identity);
}

abstract class _Equals extends Equals {
  factory _Equals({final String? name, final int? age}) = _$EqualsImpl;
  _Equals._() : super._();

  @override
  String? get name;
  @override
  int? get age;
  @override
  @JsonKey(ignore: true)
  _$$EqualsImplCopyWith<_$EqualsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
