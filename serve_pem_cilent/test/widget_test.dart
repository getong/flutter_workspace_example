import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:serve_pem_cilent/core/di/di.dart';
import 'package:serve_pem_cilent/main.dart';

void main() {
  testWidgets('renders the tab scaffold and switches features', (
    WidgetTester tester,
  ) async {
    configureDependencies();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Advice'), findsOneWidget);
    expect(find.text('Serve PEM'), findsOneWidget);
    expect(find.text('Advice Generator'), findsOneWidget);
    expect(
      find.text('Tap the button to fetch advice from the API.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Serve PEM'));
    await tester.pumpAndSettle();

    expect(find.text('Serve PEM Client'), findsOneWidget);
    expect(find.text('Rust service playground'), findsOneWidget);
    expect(find.text('Active server endpoint'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Inspect /public-key'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Inspect /public-key'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Submit /login'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Submit /login'), findsOneWidget);
  });
}
