import 'package:flutter_test/flutter_test.dart';

import 'package:stack_example/main.dart';

void main() {
  testWidgets('Stack home page renders demo links', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter Stack Examples'), findsOneWidget);
    expect(find.text('Stack Basics'), findsOneWidget);
    expect(find.text('/stack_basics'), findsOneWidget);
  });
}
