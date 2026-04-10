import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:widget_layout_example2/main.dart';

void main() {
  testWidgets('Home page shows tabbed module lists', (
    WidgetTester tester,
  ) async {
    Future<void> dragUntilTextVisible(String text) async {
      for (int i = 0; i < 20; i += 1) {
        if (find.text(text).evaluate().isNotEmpty) {
          return;
        }

        await tester.drag(find.byType(ListView).last, const Offset(0, -300));
        await tester.pumpAndSettle();
      }
    }

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Layout Modules'), findsOneWidget);
    expect(find.text('Center Box Module'), findsOneWidget);
    await dragUntilTextVisible('Constrained Box Module');
    expect(find.text('Constrained Box Module'), findsOneWidget);
    expect(find.text('Layout'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Animation'), findsOneWidget);

    await tester.tap(find.text('Content'));
    await tester.pumpAndSettle();

    expect(find.text('Content Modules'), findsOneWidget);
    expect(find.text('auto_route Module'), findsOneWidget);
    await dragUntilTextVisible('fluttertoast Module');
    expect(find.text('fluttertoast Module'), findsOneWidget);
    await dragUntilTextVisible('FutureBuilder Module');
    expect(find.text('FutureBuilder Module'), findsOneWidget);
    await dragUntilTextVisible('Intl Module');
    expect(find.text('Intl Module'), findsOneWidget);
    await dragUntilTextVisible('Semantics Module');
    expect(find.text('Semantics Module'), findsOneWidget);
    await dragUntilTextVisible('StreamBuilder Module');
    expect(find.text('StreamBuilder Module'), findsOneWidget);
    await dragUntilTextVisible('Text.rich Module');
    expect(find.text('Text.rich Module'), findsOneWidget);
    await dragUntilTextVisible('url_launcher Module');
    expect(find.text('url_launcher Module'), findsOneWidget);
    await dragUntilTextVisible('webview_flutter Module');
    expect(find.text('webview_flutter Module'), findsOneWidget);

    await tester.tap(find.text('Animation'));
    await tester.pumpAndSettle();

    expect(find.text('Animation Modules'), findsOneWidget);
    expect(find.text('AnimatedSwitcher Module'), findsOneWidget);
    expect(find.text('AnimatedDefaultTextStyle Module'), findsOneWidget);
    expect(find.text('CustomPaint Module'), findsOneWidget);
  });
}
