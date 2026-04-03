import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:widget_layout_example2/main.dart';

void main() {
  testWidgets('Home page shows tabbed module lists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Layout Modules'), findsOneWidget);
    expect(find.text('Center Box Module'), findsOneWidget);
    expect(find.text('Constrained Box Module'), findsOneWidget);
    expect(find.text('Layout'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Animation'), findsOneWidget);

    await tester.tap(find.text('Content'));
    await tester.pumpAndSettle();

    expect(find.text('Content Modules'), findsOneWidget);
    expect(find.text('auto_route Module'), findsOneWidget);
    expect(find.text('Intl Module'), findsOneWidget);
    expect(find.text('Text.rich Module'), findsOneWidget);
    expect(find.text('FutureBuilder Module'), findsOneWidget);
    expect(find.text('StreamBuilder Module'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Semantics Module'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Semantics Module'), findsOneWidget);

    await tester.tap(find.text('Animation'));
    await tester.pumpAndSettle();

    expect(find.text('Animation Modules'), findsOneWidget);
    expect(find.text('AnimatedSwitcher Module'), findsOneWidget);
    expect(find.text('AnimatedDefaultTextStyle Module'), findsOneWidget);
    expect(find.text('CustomPaint Module'), findsOneWidget);
  });
}
