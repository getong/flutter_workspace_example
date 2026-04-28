import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/registration_result.dart';

part 'registration_result_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class RegistrationResultModel extends RegistrationResult {
  const RegistrationResultModel({
    required super.status,
    required super.userId,
    required super.clientPublicKeySha256,
  });

  factory RegistrationResultModel.fromJson(Map<String, dynamic> json) {
    try {
      final result = _$RegistrationResultModelFromJson(json);

      if (result.status.isEmpty) {
        throw const FormatException('Auth response payload is malformed.');
      }

      return result;
    } on CheckedFromJsonException {
      throw const FormatException('Auth response payload is malformed.');
    }
  }

  @override
  String get status;

  @JsonKey(name: 'user_id')
  @override
  int get userId;

  @JsonKey(name: 'client_public_key_sha256')
  @override
  String get clientPublicKeySha256;
}
