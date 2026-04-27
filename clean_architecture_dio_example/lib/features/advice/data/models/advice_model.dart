import '../../domain/entities/advice.dart';

class AdviceModel extends Advice {
  const AdviceModel({
    required super.id,
    required super.message,
    required super.source,
    super.author,
  });

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawMessage = json['hitokoto'];
    final rawSource = json['from'];
    final rawAuthor = json['from_who'];

    final id = switch (rawId) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };

    if (id == null ||
        rawMessage is! String ||
        rawMessage.isEmpty ||
        rawSource is! String ||
        rawSource.isEmpty) {
      throw const FormatException('Advice payload is malformed.');
    }

    return AdviceModel(
      id: id,
      message: rawMessage,
      source: rawSource,
      author: rawAuthor is String && rawAuthor.isNotEmpty ? rawAuthor : null,
    );
  }
}
