// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdviceModel _$AdviceModelFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AdviceModel',
  json,
  ($checkedConvert) {
    final val = AdviceModel(
      id: $checkedConvert('id', (v) => AdviceModel._idFromJson(v)),
      message: $checkedConvert('hitokoto', (v) => v as String),
      source: $checkedConvert('from', (v) => v as String),
      author: $checkedConvert(
        'from_who',
        (v) => AdviceModel._authorFromJson(v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'message': 'hitokoto',
    'source': 'from',
    'author': 'from_who',
  },
);
