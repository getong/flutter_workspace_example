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
      clientPublicKeySha256: $checkedConvert(
        'client_public_key_sha256',
        (v) => v as String,
      ),
      passwordSha256: $checkedConvert('password_sha256', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'clientPublicKeySha256': 'client_public_key_sha256',
    'passwordSha256': 'password_sha256',
  },
);
