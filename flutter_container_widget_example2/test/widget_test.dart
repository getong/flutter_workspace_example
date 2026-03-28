import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_container_widget_example2/main.dart';

void main() {
  testWidgets('navigates to a container page with go_router', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter UI Succinctly'), findsOneWidget);
    expect(find.text('Light Blue Container'), findsOneWidget);

    await tester.tap(find.text('Light Blue Container'));
    await tester.pumpAndSettle();

    expect(
        find.text('Hello! I am inside Light Blue Container.'), findsOneWidget);
  });
}
