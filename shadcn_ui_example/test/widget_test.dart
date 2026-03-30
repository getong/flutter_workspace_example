import 'package:flutter_test/flutter_test.dart';

import 'package:shadcn_ui_example/main.dart';

void main() {
  testWidgets('home page renders router showcase', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('GoRouter + shadcn_ui'), findsOneWidget);
    expect(find.text('Browse Examples'), findsOneWidget);
    expect(find.text('shadcn_ui example'), findsWidgets);
  });
}
