import 'package:flutter_test/flutter_test.dart';

import 'package:transform_example/main.dart';

void main() {
  testWidgets('Transform catalog navigation smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter Transform'), findsOneWidget);
    expect(find.text('Transform.rotate'), findsOneWidget);

    await tester.tap(find.text('Transform.rotate'));
    await tester.pumpAndSettle();

    expect(find.text('Dynamic route: /transforms/rotate'), findsOneWidget);
    expect(
      find.text('Rotate widgets around an alignment point.'),
      findsOneWidget,
    );
  });
}
