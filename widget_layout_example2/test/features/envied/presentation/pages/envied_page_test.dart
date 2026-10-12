import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/envied/presentation/pages/envied_page.dart';

void main() {
  testWidgets('switches flavors and reveals the obfuscated key', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: EnviedPage()));

    expect(
      find.text('apiHost (String): https://api.widget.dev'),
      findsOneWidget,
    );
    expect(find.text('apiPort (int): 443'), findsOneWidget);
    expect(find.text('sk_demo_${'•' * 12}'), findsOneWidget);

    await tester.tap(find.text('Show apiKey'));
    await tester.pump();
    expect(find.text('sk_demo_7f3a9c21e4b84d0b'), findsOneWidget);

    await tester.tap(find.text('staging'));
    await tester.pumpAndSettle();

    expect(
      find.text('apiHost (String): http://staging.widget.dev'),
      findsOneWidget,
    );
    expect(find.text('apiPort (int): 8080'), findsOneWidget);
    expect(find.text('timeoutSeconds (double): 2.5'), findsOneWidget);
    // Switching flavors hides the key again.
    expect(find.text('sk_stagi${'•' * 12}'), findsOneWidget);
  });
}
