import 'package:flutter_test/flutter_test.dart';

import 'package:nb_utils_example/main.dart';

void main() {
  testWidgets('home page routes to components page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('go_router + nb_utils'), findsOneWidget);
    expect(find.text('Components Gallery'), findsOneWidget);

    await tester.tap(find.text('Components Gallery').last);
    await tester.pumpAndSettle();

    expect(find.text('Reusable widgets'), findsOneWidget);
    expect(find.text('Show toast'), findsOneWidget);
  });
}
