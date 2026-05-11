import 'package:widget_layout_example2/features/text_field_persist/domain/entities/text_snapshot.dart';

abstract interface class TextPersistenceRepository {
  TextSnapshot loadText();
  void saveText(String text);
}
