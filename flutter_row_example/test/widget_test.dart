import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_row_example/main.dart';

void main() {
  testWidgets('Home page renders row and column navigation links',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter Row + Column'), findsOneWidget);
    expect(find.text('Row Basics'), findsOneWidget);
    expect(find.text('Column Basics'), findsOneWidget);
  });

  testWidgets('Navigates to Row Basics and back home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Row Basics'));
    await tester.pumpAndSettle();

    expect(find.text('Row Basics'), findsAtLeastNWidgets(1));
    expect(find.text('Example 1: spaceEvenly + fixed boxes'), findsOneWidget);

    await tester.tap(find.text('Back Home'));
    await tester.pumpAndSettle();

    expect(find.text('Flutter Row + Column'), findsOneWidget);
  });
}
