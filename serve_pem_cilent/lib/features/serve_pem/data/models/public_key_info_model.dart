import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/public_key_info.dart';

part 'public_key_info_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class PublicKeyInfoModel extends PublicKeyInfo {
  const PublicKeyInfoModel({
    required super.algorithm,
    required super.keyFormat,
    required super.publicKeyPem,
    required super.publicKeyDerBase64,
    required super.sha256Hash,
    required super.maxPlaintextBytes,
  });

  factory PublicKeyInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      final keyInfo = _$PublicKeyInfoModelFromJson(json);

      if (keyInfo.publicKeyPem.isEmpty || keyInfo.sha256Hash.isEmpty) {
        throw const FormatException('Public key payload is malformed.');
      }

      return keyInfo;
    } on CheckedFromJsonException {
      throw const FormatException('Public key payload is malformed.');
    }
  }

  @override
  String get algorithm;

  @JsonKey(name: 'key_format')
  @override
  String get keyFormat;

  @JsonKey(name: 'public_key_pem')
  @override
  String get publicKeyPem;

  @JsonKey(name: 'public_key_der_base64')
  @override
  String get publicKeyDerBase64;

  @JsonKey(name: 'sha256_hash')
  @override
  String get sha256Hash;

  @JsonKey(name: 'max_plaintext_bytes')
  @override
  int get maxPlaintextBytes;
}
