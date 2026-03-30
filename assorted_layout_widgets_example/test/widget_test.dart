import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assorted_layout_widgets_example/main.dart';

void main() {
  testWidgets('home page renders router catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const AssortedLayoutWidgetsApp());
    await tester.pumpAndSettle();

    expect(find.text('Assorted Layout Widgets'), findsWidgets);
    expect(find.text('Core Widget Demos'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Box + Pad'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Box + Pad'), findsOneWidget);
    expect(find.text('RowSuper'), findsOneWidget);
  });

  testWidgets('can navigate to a detail page', (WidgetTester tester) async {
    await tester.pumpWidget(const AssortedLayoutWidgetsApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Box + Pad'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Box + Pad'));
    await tester.pumpAndSettle();

    expect(find.text('Surface composition'), findsOneWidget);
  });
}
