import 'package:flutter_test/flutter_test.dart';

import 'package:forui_example/main.dart';

void main() {
  testWidgets('router app boots on overview page', (WidgetTester tester) async {
    await tester.pumpWidget(const ForuiRouterExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Forui Router Demo'), findsOneWidget);
    expect(find.text('Router-first Forui example'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
  });
}
