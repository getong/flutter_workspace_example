import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift_example/data/app_database.dart';
import 'package:drift_example/main.dart';

void main() {
  testWidgets('Home page renders', (WidgetTester tester) async {
    final AppDatabase database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    await tester.pumpWidget(DriftExampleApp(database: database));
    await tester.pumpAndSettle();

    expect(find.text('Drift Todo Home'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });
}
