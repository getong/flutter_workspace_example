// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture_dio_example/main.dart';
import 'package:clean_architecture_dio_example/core/di/di.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    configureDependencies();
  });

  testWidgets('shows advice generator shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Advice Generator'), findsOneWidget);
    expect(
      find.text('Tap the button to fetch advice from the API.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.tips_and_updates_outlined), findsOneWidget);
  });
}
