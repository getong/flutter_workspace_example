// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_key_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicKeyInfoModel _$PublicKeyInfoModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PublicKeyInfoModel',
      json,
      ($checkedConvert) {
        final val = PublicKeyInfoModel(
          transport: $checkedConvert('transport', (v) => v as String),
          keyEncryptionAlgorithm: $checkedConvert(
            'key_encryption_algorithm',
            (v) => v as String,
          ),
          contentEncryptionAlgorithm: $checkedConvert(
            'content_encryption_algorithm',
            (v) => v as String,
          ),
          keyFormat: $checkedConvert('key_format', (v) => v as String),
          publicKeyPem: $checkedConvert('public_key_pem', (v) => v as String),
          publicKeyDerBase64: $checkedConvert(
            'public_key_der_base64',
            (v) => v as String,
          ),
          sha256Hash: $checkedConvert('sha256_hash', (v) => v as String),
          wrappedKeyBytes: $checkedConvert(
            'wrapped_key_bytes',
            (v) => (v as num).toInt(),
          ),
          nonceBytes: $checkedConvert('nonce_bytes', (v) => (v as num).toInt()),
          maxWrappedKeyPlaintextBytes: $checkedConvert(
            'max_wrapped_key_plaintext_bytes',
            (v) => (v as num).toInt(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'keyEncryptionAlgorithm': 'key_encryption_algorithm',
        'contentEncryptionAlgorithm': 'content_encryption_algorithm',
        'keyFormat': 'key_format',
        'publicKeyPem': 'public_key_pem',
        'publicKeyDerBase64': 'public_key_der_base64',
        'sha256Hash': 'sha256_hash',
        'wrappedKeyBytes': 'wrapped_key_bytes',
        'nonceBytes': 'nonce_bytes',
        'maxWrappedKeyPlaintextBytes': 'max_wrapped_key_plaintext_bytes',
      },
    );
