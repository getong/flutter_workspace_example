// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationResultModel _$RegistrationResultModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'RegistrationResultModel',
  json,
  ($checkedConvert) {
    final val = RegistrationResultModel(
      status: $checkedConvert('status', (v) => v as String),
      userId: $checkedConvert('user_id', (v) => (v as num).toInt()),
      clientPublicKeySha256: $checkedConvert(
        'client_public_key_sha256',
        (v) => v as String,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'userId': 'user_id',
    'clientPublicKeySha256': 'client_public_key_sha256',
  },
);
