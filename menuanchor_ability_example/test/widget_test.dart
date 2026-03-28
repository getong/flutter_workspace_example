import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:menuanchor_ability_example/main.dart';

void main() {
  testWidgets('MenuAnchor page can push and pop routes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Current page level: 1'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Current page level: 2'), findsOneWidget);

    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();

    expect(find.text('Current page level: 1'), findsOneWidget);
  });
}
