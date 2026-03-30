import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc_drift_example/src/domain/layout_item.dart';

void main() {
  test('LayoutItem serializes and deserializes', () {
    const LayoutItem original = LayoutItem(
      id: 7,
      slug: 'row-7-sample',
      title: 'Sample',
      message: 'Demo message',
      kind: LayoutKind.row,
    );

    final Map<String, dynamic> json = original.toJson();
    final LayoutItem restored = LayoutItem.fromJson(json);

    expect(restored.id, original.id);
    expect(restored.slug, original.slug);
    expect(restored.title, original.title);
    expect(restored.message, original.message);
    expect(restored.kind, original.kind);
  });
}
