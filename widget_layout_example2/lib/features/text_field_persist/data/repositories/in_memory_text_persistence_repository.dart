import 'package:widget_layout_example2/features/text_field_persist/domain/entities/text_snapshot.dart';
import 'package:widget_layout_example2/features/text_field_persist/domain/repositories/text_persistence_repository.dart';

class InMemoryTextPersistenceRepository implements TextPersistenceRepository {
  String _text = '';

  @override
  TextSnapshot loadText() => TextSnapshot(text: _text);

  @override
  void saveText(String text) {
    _text = text;
  }
}
