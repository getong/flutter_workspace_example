import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/registration_result.dart';

part 'registration_result_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class RegistrationResultModel extends RegistrationResult {
  const RegistrationResultModel({
    required super.status,
    required super.clientPublicKeySha256,
    required super.passwordSha256,
  });

  factory RegistrationResultModel.fromJson(Map<String, dynamic> json) {
    try {
      final result = _$RegistrationResultModelFromJson(json);

      if (result.status.isEmpty) {
        throw const FormatException('Register response payload is malformed.');
      }

      return result;
    } on CheckedFromJsonException {
      throw const FormatException('Register response payload is malformed.');
    }
  }

  @override
  String get status;

  @JsonKey(name: 'client_public_key_sha256')
  @override
  String get clientPublicKeySha256;

  @JsonKey(name: 'password_sha256')
  @override
  String get passwordSha256;
}
