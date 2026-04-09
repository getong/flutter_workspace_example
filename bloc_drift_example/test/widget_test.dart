import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_drift_example/home/view/home_page.dart';

void main() {
  testWidgets('home page shows offline example entry', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('Offline Patterns Demo'), findsOneWidget);
    expect(find.text('Bloc + Drift Offline Orders'), findsOneWidget);
  });
}
