import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/advice.dart';

part 'advice_model.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class AdviceModel extends Advice {
  const AdviceModel({
    required super.id,
    required super.message,
    required super.source,
    super.author,
  });

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    try {
      final advice = _$AdviceModelFromJson(json);

      if (advice.message.isEmpty || advice.source.isEmpty) {
        throw const FormatException('Advice payload is malformed.');
      }

      return advice;
    } on CheckedFromJsonException {
      throw const FormatException('Advice payload is malformed.');
    }
  }

  @JsonKey(fromJson: _idFromJson)
  @override
  int get id;

  @JsonKey(name: 'hitokoto')
  @override
  String get message;

  @JsonKey(name: 'from')
  @override
  String get source;

  @JsonKey(name: 'from_who', fromJson: _authorFromJson)
  @override
  String? get author;

  static int _idFromJson(Object? value) {
    return switch (value) {
          int value => value,
          String value => int.tryParse(value),
          _ => null,
        } ??
        (throw const FormatException('Advice payload is malformed.'));
  }

  static String? _authorFromJson(Object? value) {
    return switch (value) {
      String value when value.isNotEmpty => value,
      _ => null,
    };
  }
}
