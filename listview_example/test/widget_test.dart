import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:listview_example/main.dart';

void main() {
  testWidgets('home page shows listview demos', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter ListView'), findsOneWidget);
    expect(find.text('ListView Basics'), findsOneWidget);

    await tester.tap(find.text('ListView.builder'));
    await tester.pump();

    expect(find.text('ListView.builder'), findsWidgets);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
