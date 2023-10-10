// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DataImpl _$$DataImplFromJson(Map<String, dynamic> json) => _$DataImpl(
      json['value'] as int,
      $type: json['custom-key'] as String?,
    );

Map<String, dynamic> _$$DataImplToJson(_$DataImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'custom-key': instance.$type,
    };

_$LoadingImpl _$$LoadingImplFromJson(Map<String, dynamic> json) =>
    _$LoadingImpl(
      $type: json['custom-key'] as String?,
    );

Map<String, dynamic> _$$LoadingImplToJson(_$LoadingImpl instance) =>
    <String, dynamic>{
      'custom-key': instance.$type,
    };

_$ErrorDetailsImpl _$$ErrorDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ErrorDetailsImpl(
      json['message'] as String?,
      json['custom-key'] as String?,
    );

Map<String, dynamic> _$$ErrorDetailsImplToJson(_$ErrorDetailsImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'custom-key': instance.$type,
    };

_$ComplexImpl _$$ComplexImplFromJson(Map<String, dynamic> json) =>
    _$ComplexImpl(
      json['a'] as int,
      json['b'] as String,
      $type: json['custom-key'] as String?,
    );

Map<String, dynamic> _$$ComplexImplToJson(_$ComplexImpl instance) =>
    <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'custom-key': instance.$type,
    };
