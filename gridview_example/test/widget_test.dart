import 'package:flutter_test/flutter_test.dart';

import 'package:gridview_example/main.dart';

void main() {
  testWidgets('Home page shows GridView demo entries', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter GridView'), findsOneWidget);
    expect(find.text('Grid Basics'), findsOneWidget);
    expect(find.text('Grid Builder'), findsOneWidget);
  });
}
