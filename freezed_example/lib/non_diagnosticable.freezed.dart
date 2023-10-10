// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'non_diagnosticable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Example<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int a, String b) $default, {
    required TResult Function(T c) named,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int a, String b)? $default, {
    TResult? Function(T c)? named,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int a, String b)? $default, {
    TResult Function(T c)? named,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Example<T> value) $default, {
    required TResult Function(_Example2<T> value) named,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Example<T> value)? $default, {
    TResult? Function(_Example2<T> value)? named,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Example<T> value)? $default, {
    TResult Function(_Example2<T> value)? named,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExampleCopyWith<T, $Res> {
  factory $ExampleCopyWith(Example<T> value, $Res Function(Example<T>) then) =
      _$ExampleCopyWithImpl<T, $Res, Example<T>>;
}

/// @nodoc
class _$ExampleCopyWithImpl<T, $Res, $Val extends Example<T>>
    implements $ExampleCopyWith<T, $Res> {
  _$ExampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExampleImplCopyWith<T, $Res> {
  factory _$$ExampleImplCopyWith(
          _$ExampleImpl<T> value, $Res Function(_$ExampleImpl<T>) then) =
      __$$ExampleImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({int a, String b});
}

/// @nodoc
class __$$ExampleImplCopyWithImpl<T, $Res>
    extends _$ExampleCopyWithImpl<T, $Res, _$ExampleImpl<T>>
    implements _$$ExampleImplCopyWith<T, $Res> {
  __$$ExampleImplCopyWithImpl(
      _$ExampleImpl<T> _value, $Res Function(_$ExampleImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
  }) {
    return _then(_$ExampleImpl<T>(
      null == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as int,
      null == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExampleImpl<T> implements _Example<T> {
  _$ExampleImpl(this.a, this.b);

  @override
  final int a;
  @override
  final String b;

  @override
  String toString() {
    return 'Example<$T>(a: $a, b: $b)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExampleImpl<T> &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b));
  }

  @override
  int get hashCode => Object.hash(runtimeType, a, b);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExampleImplCopyWith<T, _$ExampleImpl<T>> get copyWith =>
      __$$ExampleImplCopyWithImpl<T, _$ExampleImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int a, String b) $default, {
    required TResult Function(T c) named,
  }) {
    return $default(a, b);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int a, String b)? $default, {
    TResult? Function(T c)? named,
  }) {
    return $default?.call(a, b);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int a, String b)? $default, {
    TResult Function(T c)? named,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(a, b);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Example<T> value) $default, {
    required TResult Function(_Example2<T> value) named,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Example<T> value)? $default, {
    TResult? Function(_Example2<T> value)? named,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Example<T> value)? $default, {
    TResult Function(_Example2<T> value)? named,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _Example<T> implements Example<T> {
  factory _Example(final int a, final String b) = _$ExampleImpl<T>;

  int get a;
  String get b;
  @JsonKey(ignore: true)
  _$$ExampleImplCopyWith<T, _$ExampleImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Example2ImplCopyWith<T, $Res> {
  factory _$$Example2ImplCopyWith(
          _$Example2Impl<T> value, $Res Function(_$Example2Impl<T>) then) =
      __$$Example2ImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T c});
}

/// @nodoc
class __$$Example2ImplCopyWithImpl<T, $Res>
    extends _$ExampleCopyWithImpl<T, $Res, _$Example2Impl<T>>
    implements _$$Example2ImplCopyWith<T, $Res> {
  __$$Example2ImplCopyWithImpl(
      _$Example2Impl<T> _value, $Res Function(_$Example2Impl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? c = freezed,
  }) {
    return _then(_$Example2Impl<T>(
      freezed == c
          ? _value.c
          : c // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$Example2Impl<T> implements _Example2<T> {
  _$Example2Impl(this.c);

  @override
  final T c;

  @override
  String toString() {
    return 'Example<$T>.named(c: $c)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Example2Impl<T> &&
            const DeepCollectionEquality().equals(other.c, c));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(c));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Example2ImplCopyWith<T, _$Example2Impl<T>> get copyWith =>
      __$$Example2ImplCopyWithImpl<T, _$Example2Impl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int a, String b) $default, {
    required TResult Function(T c) named,
  }) {
    return named(c);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int a, String b)? $default, {
    TResult? Function(T c)? named,
  }) {
    return named?.call(c);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int a, String b)? $default, {
    TResult Function(T c)? named,
    required TResult orElse(),
  }) {
    if (named != null) {
      return named(c);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Example<T> value) $default, {
    required TResult Function(_Example2<T> value) named,
  }) {
    return named(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Example<T> value)? $default, {
    TResult? Function(_Example2<T> value)? named,
  }) {
    return named?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Example<T> value)? $default, {
    TResult Function(_Example2<T> value)? named,
    required TResult orElse(),
  }) {
    if (named != null) {
      return named(this);
    }
    return orElse();
  }
}

abstract class _Example2<T> implements Example<T> {
  factory _Example2(final T c) = _$Example2Impl<T>;

  T get c;
  @JsonKey(ignore: true)
  _$$Example2ImplCopyWith<T, _$Example2Impl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SimpleImplements {
  String get name => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name, int population) country,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name, int population)? country,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name, int population)? country,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimplePerson value) person,
    required TResult Function(SimpleStreet value) street,
    required TResult Function(SimpleCity value) city,
    required TResult Function(SimpleCountry value) country,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimplePerson value)? person,
    TResult? Function(SimpleStreet value)? street,
    TResult? Function(SimpleCity value)? city,
    TResult? Function(SimpleCountry value)? country,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimplePerson value)? person,
    TResult Function(SimpleStreet value)? street,
    TResult Function(SimpleCity value)? city,
    TResult Function(SimpleCountry value)? country,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SimpleImplementsCopyWith<SimpleImplements> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimpleImplementsCopyWith<$Res> {
  factory $SimpleImplementsCopyWith(
          SimpleImplements value, $Res Function(SimpleImplements) then) =
      _$SimpleImplementsCopyWithImpl<$Res, SimpleImplements>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$SimpleImplementsCopyWithImpl<$Res, $Val extends SimpleImplements>
    implements $SimpleImplementsCopyWith<$Res> {
  _$SimpleImplementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimplePersonImplCopyWith<$Res>
    implements $SimpleImplementsCopyWith<$Res> {
  factory _$$SimplePersonImplCopyWith(
          _$SimplePersonImpl value, $Res Function(_$SimplePersonImpl) then) =
      __$$SimplePersonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int age});
}

/// @nodoc
class __$$SimplePersonImplCopyWithImpl<$Res>
    extends _$SimpleImplementsCopyWithImpl<$Res, _$SimplePersonImpl>
    implements _$$SimplePersonImplCopyWith<$Res> {
  __$$SimplePersonImplCopyWithImpl(
      _$SimplePersonImpl _value, $Res Function(_$SimplePersonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
  }) {
    return _then(_$SimplePersonImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SimplePersonImpl implements SimplePerson {
  const _$SimplePersonImpl(this.name, this.age);

  @override
  final String name;
  @override
  final int age;

  @override
  String toString() {
    return 'SimpleImplements.person(name: $name, age: $age)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimplePersonImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, age);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimplePersonImplCopyWith<_$SimplePersonImpl> get copyWith =>
      __$$SimplePersonImplCopyWithImpl<_$SimplePersonImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name, int population) country,
  }) {
    return person(name, age);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name, int population)? country,
  }) {
    return person?.call(name, age);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name, int population)? country,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(name, age);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimplePerson value) person,
    required TResult Function(SimpleStreet value) street,
    required TResult Function(SimpleCity value) city,
    required TResult Function(SimpleCountry value) country,
  }) {
    return person(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimplePerson value)? person,
    TResult? Function(SimpleStreet value)? street,
    TResult? Function(SimpleCity value)? city,
    TResult? Function(SimpleCountry value)? country,
  }) {
    return person?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimplePerson value)? person,
    TResult Function(SimpleStreet value)? street,
    TResult Function(SimpleCity value)? city,
    TResult Function(SimpleCountry value)? country,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(this);
    }
    return orElse();
  }
}

abstract class SimplePerson implements SimpleImplements {
  const factory SimplePerson(final String name, final int age) =
      _$SimplePersonImpl;

  @override
  String get name;
  int get age;
  @override
  @JsonKey(ignore: true)
  _$$SimplePersonImplCopyWith<_$SimplePersonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SimpleStreetImplCopyWith<$Res>
    implements $SimpleImplementsCopyWith<$Res> {
  factory _$$SimpleStreetImplCopyWith(
          _$SimpleStreetImpl value, $Res Function(_$SimpleStreetImpl) then) =
      __$$SimpleStreetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$SimpleStreetImplCopyWithImpl<$Res>
    extends _$SimpleImplementsCopyWithImpl<$Res, _$SimpleStreetImpl>
    implements _$$SimpleStreetImplCopyWith<$Res> {
  __$$SimpleStreetImplCopyWithImpl(
      _$SimpleStreetImpl _value, $Res Function(_$SimpleStreetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$SimpleStreetImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SimpleStreetImpl
    with AdministrativeArea<House>
    implements SimpleStreet {
  const _$SimpleStreetImpl(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'SimpleImplements.street(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleStreetImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleStreetImplCopyWith<_$SimpleStreetImpl> get copyWith =>
      __$$SimpleStreetImplCopyWithImpl<_$SimpleStreetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name, int population) country,
  }) {
    return street(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name, int population)? country,
  }) {
    return street?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name, int population)? country,
    required TResult orElse(),
  }) {
    if (street != null) {
      return street(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimplePerson value) person,
    required TResult Function(SimpleStreet value) street,
    required TResult Function(SimpleCity value) city,
    required TResult Function(SimpleCountry value) country,
  }) {
    return street(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimplePerson value)? person,
    TResult? Function(SimpleStreet value)? street,
    TResult? Function(SimpleCity value)? city,
    TResult? Function(SimpleCountry value)? country,
  }) {
    return street?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimplePerson value)? person,
    TResult Function(SimpleStreet value)? street,
    TResult Function(SimpleCity value)? city,
    TResult Function(SimpleCountry value)? country,
    required TResult orElse(),
  }) {
    if (street != null) {
      return street(this);
    }
    return orElse();
  }
}

abstract class SimpleStreet
    implements SimpleImplements, AdministrativeArea<House> {
  const factory SimpleStreet(final String name) = _$SimpleStreetImpl;

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$SimpleStreetImplCopyWith<_$SimpleStreetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SimpleCityImplCopyWith<$Res>
    implements $SimpleImplementsCopyWith<$Res> {
  factory _$$SimpleCityImplCopyWith(
          _$SimpleCityImpl value, $Res Function(_$SimpleCityImpl) then) =
      __$$SimpleCityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int population});
}

/// @nodoc
class __$$SimpleCityImplCopyWithImpl<$Res>
    extends _$SimpleImplementsCopyWithImpl<$Res, _$SimpleCityImpl>
    implements _$$SimpleCityImplCopyWith<$Res> {
  __$$SimpleCityImplCopyWithImpl(
      _$SimpleCityImpl _value, $Res Function(_$SimpleCityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? population = null,
  }) {
    return _then(_$SimpleCityImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SimpleCityImpl with House implements SimpleCity {
  const _$SimpleCityImpl(this.name, this.population);

  @override
  final String name;
  @override
  final int population;

  @override
  String toString() {
    return 'SimpleImplements.city(name: $name, population: $population)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleCityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.population, population) ||
                other.population == population));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, population);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleCityImplCopyWith<_$SimpleCityImpl> get copyWith =>
      __$$SimpleCityImplCopyWithImpl<_$SimpleCityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name, int population) country,
  }) {
    return city(name, population);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name, int population)? country,
  }) {
    return city?.call(name, population);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name, int population)? country,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(name, population);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimplePerson value) person,
    required TResult Function(SimpleStreet value) street,
    required TResult Function(SimpleCity value) city,
    required TResult Function(SimpleCountry value) country,
  }) {
    return city(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimplePerson value)? person,
    TResult? Function(SimpleStreet value)? street,
    TResult? Function(SimpleCity value)? city,
    TResult? Function(SimpleCountry value)? country,
  }) {
    return city?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimplePerson value)? person,
    TResult Function(SimpleStreet value)? street,
    TResult Function(SimpleCity value)? city,
    TResult Function(SimpleCountry value)? country,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(this);
    }
    return orElse();
  }
}

abstract class SimpleCity implements SimpleImplements, House {
  const factory SimpleCity(final String name, final int population) =
      _$SimpleCityImpl;

  @override
  String get name;
  int get population;
  @override
  @JsonKey(ignore: true)
  _$$SimpleCityImplCopyWith<_$SimpleCityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SimpleCountryImplCopyWith<$Res>
    implements $SimpleImplementsCopyWith<$Res> {
  factory _$$SimpleCountryImplCopyWith(
          _$SimpleCountryImpl value, $Res Function(_$SimpleCountryImpl) then) =
      __$$SimpleCountryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int population});
}

/// @nodoc
class __$$SimpleCountryImplCopyWithImpl<$Res>
    extends _$SimpleImplementsCopyWithImpl<$Res, _$SimpleCountryImpl>
    implements _$$SimpleCountryImplCopyWith<$Res> {
  __$$SimpleCountryImplCopyWithImpl(
      _$SimpleCountryImpl _value, $Res Function(_$SimpleCountryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? population = null,
  }) {
    return _then(_$SimpleCountryImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SimpleCountryImpl with House implements SimpleCountry {
  const _$SimpleCountryImpl(this.name, this.population);

  @override
  final String name;
  @override
  final int population;

  @override
  String toString() {
    return 'SimpleImplements.country(name: $name, population: $population)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleCountryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.population, population) ||
                other.population == population));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, population);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleCountryImplCopyWith<_$SimpleCountryImpl> get copyWith =>
      __$$SimpleCountryImplCopyWithImpl<_$SimpleCountryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name, int population) country,
  }) {
    return country(name, population);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name, int population)? country,
  }) {
    return country?.call(name, population);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name, int population)? country,
    required TResult orElse(),
  }) {
    if (country != null) {
      return country(name, population);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimplePerson value) person,
    required TResult Function(SimpleStreet value) street,
    required TResult Function(SimpleCity value) city,
    required TResult Function(SimpleCountry value) country,
  }) {
    return country(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimplePerson value)? person,
    TResult? Function(SimpleStreet value)? street,
    TResult? Function(SimpleCity value)? city,
    TResult? Function(SimpleCountry value)? country,
  }) {
    return country?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimplePerson value)? person,
    TResult Function(SimpleStreet value)? street,
    TResult Function(SimpleCity value)? city,
    TResult Function(SimpleCountry value)? country,
    required TResult orElse(),
  }) {
    if (country != null) {
      return country(this);
    }
    return orElse();
  }
}

abstract class SimpleCountry
    implements SimpleImplements, GeographicArea, House {
  const factory SimpleCountry(final String name, final int population) =
      _$SimpleCountryImpl;

  @override
  String get name;
  int get population;
  @override
  @JsonKey(ignore: true)
  _$$SimpleCountryImplCopyWith<_$SimpleCountryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CustomMethodImplements {
  String get name => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name) duplex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name)? duplex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name)? duplex,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonCustomMethod value) person,
    required TResult Function(StreetCustomMethod value) street,
    required TResult Function(CityCustomMethod value) city,
    required TResult Function(DuplexCustomMethod value) duplex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonCustomMethod value)? person,
    TResult? Function(StreetCustomMethod value)? street,
    TResult? Function(CityCustomMethod value)? city,
    TResult? Function(DuplexCustomMethod value)? duplex,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonCustomMethod value)? person,
    TResult Function(StreetCustomMethod value)? street,
    TResult Function(CityCustomMethod value)? city,
    TResult Function(DuplexCustomMethod value)? duplex,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomMethodImplementsCopyWith<CustomMethodImplements> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomMethodImplementsCopyWith<$Res> {
  factory $CustomMethodImplementsCopyWith(CustomMethodImplements value,
          $Res Function(CustomMethodImplements) then) =
      _$CustomMethodImplementsCopyWithImpl<$Res, CustomMethodImplements>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$CustomMethodImplementsCopyWithImpl<$Res,
        $Val extends CustomMethodImplements>
    implements $CustomMethodImplementsCopyWith<$Res> {
  _$CustomMethodImplementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonCustomMethodImplCopyWith<$Res>
    implements $CustomMethodImplementsCopyWith<$Res> {
  factory _$$PersonCustomMethodImplCopyWith(_$PersonCustomMethodImpl value,
          $Res Function(_$PersonCustomMethodImpl) then) =
      __$$PersonCustomMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int age});
}

/// @nodoc
class __$$PersonCustomMethodImplCopyWithImpl<$Res>
    extends _$CustomMethodImplementsCopyWithImpl<$Res, _$PersonCustomMethodImpl>
    implements _$$PersonCustomMethodImplCopyWith<$Res> {
  __$$PersonCustomMethodImplCopyWithImpl(_$PersonCustomMethodImpl _value,
      $Res Function(_$PersonCustomMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
  }) {
    return _then(_$PersonCustomMethodImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PersonCustomMethodImpl extends PersonCustomMethod {
  const _$PersonCustomMethodImpl(this.name, this.age) : super._();

  @override
  final String name;
  @override
  final int age;

  @override
  String toString() {
    return 'CustomMethodImplements.person(name: $name, age: $age)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonCustomMethodImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, age);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonCustomMethodImplCopyWith<_$PersonCustomMethodImpl> get copyWith =>
      __$$PersonCustomMethodImplCopyWithImpl<_$PersonCustomMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name) duplex,
  }) {
    return person(name, age);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name)? duplex,
  }) {
    return person?.call(name, age);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name)? duplex,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(name, age);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonCustomMethod value) person,
    required TResult Function(StreetCustomMethod value) street,
    required TResult Function(CityCustomMethod value) city,
    required TResult Function(DuplexCustomMethod value) duplex,
  }) {
    return person(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonCustomMethod value)? person,
    TResult? Function(StreetCustomMethod value)? street,
    TResult? Function(CityCustomMethod value)? city,
    TResult? Function(DuplexCustomMethod value)? duplex,
  }) {
    return person?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonCustomMethod value)? person,
    TResult Function(StreetCustomMethod value)? street,
    TResult Function(CityCustomMethod value)? city,
    TResult Function(DuplexCustomMethod value)? duplex,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(this);
    }
    return orElse();
  }
}

abstract class PersonCustomMethod extends CustomMethodImplements {
  const factory PersonCustomMethod(final String name, final int age) =
      _$PersonCustomMethodImpl;
  const PersonCustomMethod._() : super._();

  @override
  String get name;
  int get age;
  @override
  @JsonKey(ignore: true)
  _$$PersonCustomMethodImplCopyWith<_$PersonCustomMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreetCustomMethodImplCopyWith<$Res>
    implements $CustomMethodImplementsCopyWith<$Res> {
  factory _$$StreetCustomMethodImplCopyWith(_$StreetCustomMethodImpl value,
          $Res Function(_$StreetCustomMethodImpl) then) =
      __$$StreetCustomMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$StreetCustomMethodImplCopyWithImpl<$Res>
    extends _$CustomMethodImplementsCopyWithImpl<$Res, _$StreetCustomMethodImpl>
    implements _$$StreetCustomMethodImplCopyWith<$Res> {
  __$$StreetCustomMethodImplCopyWithImpl(_$StreetCustomMethodImpl _value,
      $Res Function(_$StreetCustomMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$StreetCustomMethodImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StreetCustomMethodImpl extends StreetCustomMethod
    with Shop, AdministrativeArea<House> {
  const _$StreetCustomMethodImpl(this.name) : super._();

  @override
  final String name;

  @override
  String toString() {
    return 'CustomMethodImplements.street(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreetCustomMethodImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreetCustomMethodImplCopyWith<_$StreetCustomMethodImpl> get copyWith =>
      __$$StreetCustomMethodImplCopyWithImpl<_$StreetCustomMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name) duplex,
  }) {
    return street(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name)? duplex,
  }) {
    return street?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name)? duplex,
    required TResult orElse(),
  }) {
    if (street != null) {
      return street(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonCustomMethod value) person,
    required TResult Function(StreetCustomMethod value) street,
    required TResult Function(CityCustomMethod value) city,
    required TResult Function(DuplexCustomMethod value) duplex,
  }) {
    return street(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonCustomMethod value)? person,
    TResult? Function(StreetCustomMethod value)? street,
    TResult? Function(CityCustomMethod value)? city,
    TResult? Function(DuplexCustomMethod value)? duplex,
  }) {
    return street?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonCustomMethod value)? person,
    TResult Function(StreetCustomMethod value)? street,
    TResult Function(CityCustomMethod value)? city,
    TResult Function(DuplexCustomMethod value)? duplex,
    required TResult orElse(),
  }) {
    if (street != null) {
      return street(this);
    }
    return orElse();
  }
}

abstract class StreetCustomMethod extends CustomMethodImplements
    implements Shop, AdministrativeArea<House> {
  const factory StreetCustomMethod(final String name) =
      _$StreetCustomMethodImpl;
  const StreetCustomMethod._() : super._();

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$StreetCustomMethodImplCopyWith<_$StreetCustomMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CityCustomMethodImplCopyWith<$Res>
    implements $CustomMethodImplementsCopyWith<$Res> {
  factory _$$CityCustomMethodImplCopyWith(_$CityCustomMethodImpl value,
          $Res Function(_$CityCustomMethodImpl) then) =
      __$$CityCustomMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int population});
}

/// @nodoc
class __$$CityCustomMethodImplCopyWithImpl<$Res>
    extends _$CustomMethodImplementsCopyWithImpl<$Res, _$CityCustomMethodImpl>
    implements _$$CityCustomMethodImplCopyWith<$Res> {
  __$$CityCustomMethodImplCopyWithImpl(_$CityCustomMethodImpl _value,
      $Res Function(_$CityCustomMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? population = null,
  }) {
    return _then(_$CityCustomMethodImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CityCustomMethodImpl extends CityCustomMethod with House {
  const _$CityCustomMethodImpl(this.name, this.population) : super._();

  @override
  final String name;
  @override
  final int population;

  @override
  String toString() {
    return 'CustomMethodImplements.city(name: $name, population: $population)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityCustomMethodImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.population, population) ||
                other.population == population));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, population);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CityCustomMethodImplCopyWith<_$CityCustomMethodImpl> get copyWith =>
      __$$CityCustomMethodImplCopyWithImpl<_$CityCustomMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name) duplex,
  }) {
    return city(name, population);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name)? duplex,
  }) {
    return city?.call(name, population);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name)? duplex,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(name, population);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonCustomMethod value) person,
    required TResult Function(StreetCustomMethod value) street,
    required TResult Function(CityCustomMethod value) city,
    required TResult Function(DuplexCustomMethod value) duplex,
  }) {
    return city(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonCustomMethod value)? person,
    TResult? Function(StreetCustomMethod value)? street,
    TResult? Function(CityCustomMethod value)? city,
    TResult? Function(DuplexCustomMethod value)? duplex,
  }) {
    return city?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonCustomMethod value)? person,
    TResult Function(StreetCustomMethod value)? street,
    TResult Function(CityCustomMethod value)? city,
    TResult Function(DuplexCustomMethod value)? duplex,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(this);
    }
    return orElse();
  }
}

abstract class CityCustomMethod extends CustomMethodImplements
    implements GeographicArea, House {
  const factory CityCustomMethod(final String name, final int population) =
      _$CityCustomMethodImpl;
  const CityCustomMethod._() : super._();

  @override
  String get name;
  int get population;
  @override
  @JsonKey(ignore: true)
  _$$CityCustomMethodImplCopyWith<_$CityCustomMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DuplexCustomMethodImplCopyWith<$Res>
    implements $CustomMethodImplementsCopyWith<$Res> {
  factory _$$DuplexCustomMethodImplCopyWith(_$DuplexCustomMethodImpl value,
          $Res Function(_$DuplexCustomMethodImpl) then) =
      __$$DuplexCustomMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$DuplexCustomMethodImplCopyWithImpl<$Res>
    extends _$CustomMethodImplementsCopyWithImpl<$Res, _$DuplexCustomMethodImpl>
    implements _$$DuplexCustomMethodImplCopyWith<$Res> {
  __$$DuplexCustomMethodImplCopyWithImpl(_$DuplexCustomMethodImpl _value,
      $Res Function(_$DuplexCustomMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$DuplexCustomMethodImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DuplexCustomMethodImpl extends DuplexCustomMethod {
  const _$DuplexCustomMethodImpl(this.name) : super._();

  @override
  final String name;

  @override
  String toString() {
    return 'CustomMethodImplements.duplex(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuplexCustomMethodImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DuplexCustomMethodImplCopyWith<_$DuplexCustomMethodImpl> get copyWith =>
      __$$DuplexCustomMethodImplCopyWithImpl<_$DuplexCustomMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name) street,
    required TResult Function(String name, int population) city,
    required TResult Function(String name) duplex,
  }) {
    return duplex(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name)? street,
    TResult? Function(String name, int population)? city,
    TResult? Function(String name)? duplex,
  }) {
    return duplex?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name)? street,
    TResult Function(String name, int population)? city,
    TResult Function(String name)? duplex,
    required TResult orElse(),
  }) {
    if (duplex != null) {
      return duplex(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PersonCustomMethod value) person,
    required TResult Function(StreetCustomMethod value) street,
    required TResult Function(CityCustomMethod value) city,
    required TResult Function(DuplexCustomMethod value) duplex,
  }) {
    return duplex(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PersonCustomMethod value)? person,
    TResult? Function(StreetCustomMethod value)? street,
    TResult? Function(CityCustomMethod value)? city,
    TResult? Function(DuplexCustomMethod value)? duplex,
  }) {
    return duplex?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PersonCustomMethod value)? person,
    TResult Function(StreetCustomMethod value)? street,
    TResult Function(CityCustomMethod value)? city,
    TResult Function(DuplexCustomMethod value)? duplex,
    required TResult orElse(),
  }) {
    if (duplex != null) {
      return duplex(this);
    }
    return orElse();
  }
}

abstract class DuplexCustomMethod extends CustomMethodImplements
    implements Shop, GeographicArea {
  const factory DuplexCustomMethod(final String name) =
      _$DuplexCustomMethodImpl;
  const DuplexCustomMethod._() : super._();

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$DuplexCustomMethodImplCopyWith<_$DuplexCustomMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GenericImplements<T> {
  String get name => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name, int population) city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name, int population)? city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name, int population)? city,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericPerson<T> value) person,
    required TResult Function(GenericCity<T> value) city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericPerson<T> value)? person,
    TResult? Function(GenericCity<T> value)? city,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericPerson<T> value)? person,
    TResult Function(GenericCity<T> value)? city,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GenericImplementsCopyWith<T, GenericImplements<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericImplementsCopyWith<T, $Res> {
  factory $GenericImplementsCopyWith(GenericImplements<T> value,
          $Res Function(GenericImplements<T>) then) =
      _$GenericImplementsCopyWithImpl<T, $Res, GenericImplements<T>>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$GenericImplementsCopyWithImpl<T, $Res,
        $Val extends GenericImplements<T>>
    implements $GenericImplementsCopyWith<T, $Res> {
  _$GenericImplementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenericPersonImplCopyWith<T, $Res>
    implements $GenericImplementsCopyWith<T, $Res> {
  factory _$$GenericPersonImplCopyWith(_$GenericPersonImpl<T> value,
          $Res Function(_$GenericPersonImpl<T>) then) =
      __$$GenericPersonImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String name, int age});
}

/// @nodoc
class __$$GenericPersonImplCopyWithImpl<T, $Res>
    extends _$GenericImplementsCopyWithImpl<T, $Res, _$GenericPersonImpl<T>>
    implements _$$GenericPersonImplCopyWith<T, $Res> {
  __$$GenericPersonImplCopyWithImpl(_$GenericPersonImpl<T> _value,
      $Res Function(_$GenericPersonImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
  }) {
    return _then(_$GenericPersonImpl<T>(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$GenericPersonImpl<T> implements GenericPerson<T> {
  const _$GenericPersonImpl(this.name, this.age);

  @override
  final String name;
  @override
  final int age;

  @override
  String toString() {
    return 'GenericImplements<$T>.person(name: $name, age: $age)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericPersonImpl<T> &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, age);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericPersonImplCopyWith<T, _$GenericPersonImpl<T>> get copyWith =>
      __$$GenericPersonImplCopyWithImpl<T, _$GenericPersonImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name, int population) city,
  }) {
    return person(name, age);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name, int population)? city,
  }) {
    return person?.call(name, age);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name, int population)? city,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(name, age);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericPerson<T> value) person,
    required TResult Function(GenericCity<T> value) city,
  }) {
    return person(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericPerson<T> value)? person,
    TResult? Function(GenericCity<T> value)? city,
  }) {
    return person?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericPerson<T> value)? person,
    TResult Function(GenericCity<T> value)? city,
    required TResult orElse(),
  }) {
    if (person != null) {
      return person(this);
    }
    return orElse();
  }
}

abstract class GenericPerson<T> implements GenericImplements<T> {
  const factory GenericPerson(final String name, final int age) =
      _$GenericPersonImpl<T>;

  @override
  String get name;
  int get age;
  @override
  @JsonKey(ignore: true)
  _$$GenericPersonImplCopyWith<T, _$GenericPersonImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GenericCityImplCopyWith<T, $Res>
    implements $GenericImplementsCopyWith<T, $Res> {
  factory _$$GenericCityImplCopyWith(_$GenericCityImpl<T> value,
          $Res Function(_$GenericCityImpl<T>) then) =
      __$$GenericCityImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String name, int population});
}

/// @nodoc
class __$$GenericCityImplCopyWithImpl<T, $Res>
    extends _$GenericImplementsCopyWithImpl<T, $Res, _$GenericCityImpl<T>>
    implements _$$GenericCityImplCopyWith<T, $Res> {
  __$$GenericCityImplCopyWithImpl(
      _$GenericCityImpl<T> _value, $Res Function(_$GenericCityImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? population = null,
  }) {
    return _then(_$GenericCityImpl<T>(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == population
          ? _value.population
          : population // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$GenericCityImpl<T> with House implements GenericCity<T> {
  const _$GenericCityImpl(this.name, this.population);

  @override
  final String name;
  @override
  final int population;

  @override
  String toString() {
    return 'GenericImplements<$T>.city(name: $name, population: $population)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericCityImpl<T> &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.population, population) ||
                other.population == population));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, population);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericCityImplCopyWith<T, _$GenericCityImpl<T>> get copyWith =>
      __$$GenericCityImplCopyWithImpl<T, _$GenericCityImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, int age) person,
    required TResult Function(String name, int population) city,
  }) {
    return city(name, population);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, int age)? person,
    TResult? Function(String name, int population)? city,
  }) {
    return city?.call(name, population);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, int age)? person,
    TResult Function(String name, int population)? city,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(name, population);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericPerson<T> value) person,
    required TResult Function(GenericCity<T> value) city,
  }) {
    return city(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericPerson<T> value)? person,
    TResult? Function(GenericCity<T> value)? city,
  }) {
    return city?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericPerson<T> value)? person,
    TResult Function(GenericCity<T> value)? city,
    required TResult orElse(),
  }) {
    if (city != null) {
      return city(this);
    }
    return orElse();
  }
}

abstract class GenericCity<T>
    implements GenericImplements<T>, GeographicArea, House {
  const factory GenericCity(final String name, final int population) =
      _$GenericCityImpl<T>;

  @override
  String get name;
  int get population;
  @override
  @JsonKey(ignore: true)
  _$$GenericCityImplCopyWith<T, _$GenericCityImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
