// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnosticable.dart';

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

class _$ExampleImpl<T> extends _Example<T> with DiagnosticableTreeMixin {
  _$ExampleImpl(this.a, this.b) : super._();

  @override
  final int a;
  @override
  final String b;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Example<$T>(a: $a, b: $b)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Example<$T>'))
      ..add(DiagnosticsProperty('a', a))
      ..add(DiagnosticsProperty('b', b));
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

abstract class _Example<T> extends Example<T> {
  factory _Example(final int a, final String b) = _$ExampleImpl<T>;
  _Example._() : super._();

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

class _$Example2Impl<T> extends _Example2<T> with DiagnosticableTreeMixin {
  _$Example2Impl(this.c) : super._();

  @override
  final T c;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Example<$T>.named(c: $c)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Example<$T>.named'))
      ..add(DiagnosticsProperty('c', c));
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

abstract class _Example2<T> extends Example<T> {
  factory _Example2(final T c) = _$Example2Impl<T>;
  _Example2._() : super._();

  T get c;
  @JsonKey(ignore: true)
  _$$Example2ImplCopyWith<T, _$Example2Impl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConcreteExample<T> {}

/// @nodoc
abstract class $ConcreteExampleCopyWith<T, $Res> {
  factory $ConcreteExampleCopyWith(
          ConcreteExample<T> value, $Res Function(ConcreteExample<T>) then) =
      _$ConcreteExampleCopyWithImpl<T, $Res, ConcreteExample<T>>;
}

/// @nodoc
class _$ConcreteExampleCopyWithImpl<T, $Res, $Val extends ConcreteExample<T>>
    implements $ConcreteExampleCopyWith<T, $Res> {
  _$ConcreteExampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ConcreteExampleImplCopyWith<T, $Res> {
  factory _$$ConcreteExampleImplCopyWith(_$ConcreteExampleImpl<T> value,
          $Res Function(_$ConcreteExampleImpl<T>) then) =
      __$$ConcreteExampleImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ConcreteExampleImplCopyWithImpl<T, $Res>
    extends _$ConcreteExampleCopyWithImpl<T, $Res, _$ConcreteExampleImpl<T>>
    implements _$$ConcreteExampleImplCopyWith<T, $Res> {
  __$$ConcreteExampleImplCopyWithImpl(_$ConcreteExampleImpl<T> _value,
      $Res Function(_$ConcreteExampleImpl<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ConcreteExampleImpl<T> extends _ConcreteExample<T>
    with DiagnosticableTreeMixin {
  _$ConcreteExampleImpl() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ConcreteExample<$T>()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'ConcreteExample<$T>'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ConcreteExampleImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _ConcreteExample<T> extends ConcreteExample<T> {
  factory _ConcreteExample() = _$ConcreteExampleImpl<T>;
  _ConcreteExample._() : super._();
}

/// @nodoc
mixin _$ToString {}

/// @nodoc
abstract class $ToStringCopyWith<$Res> {
  factory $ToStringCopyWith(ToString value, $Res Function(ToString) then) =
      _$ToStringCopyWithImpl<$Res, ToString>;
}

/// @nodoc
class _$ToStringCopyWithImpl<$Res, $Val extends ToString>
    implements $ToStringCopyWith<$Res> {
  _$ToStringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ToStringImplCopyWith<$Res> {
  factory _$$ToStringImplCopyWith(
          _$ToStringImpl value, $Res Function(_$ToStringImpl) then) =
      __$$ToStringImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToStringImplCopyWithImpl<$Res>
    extends _$ToStringCopyWithImpl<$Res, _$ToStringImpl>
    implements _$$ToStringImplCopyWith<$Res> {
  __$$ToStringImplCopyWithImpl(
      _$ToStringImpl _value, $Res Function(_$ToStringImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ToStringImpl extends _ToString {
  _$ToStringImpl() : super._();

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ToStringImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _ToString extends ToString {
  factory _ToString() = _$ToStringImpl;
  _ToString._() : super._();
}
