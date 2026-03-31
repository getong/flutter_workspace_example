import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:listview_example/main.dart';

void main() {
  testWidgets('home page shows listview and key demos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter ListView'), findsOneWidget);
    expect(find.text('ListView Basics'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('GlobalKey Form'), 300);
    expect(find.text('GlobalKey Form'), findsOneWidget);

    await tester.tap(find.text('GlobalKey Form'));
    await tester.pumpAndSettle();

    expect(find.text('GlobalKey Form'), findsWidgets);
    expect(find.text('Validate form'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
