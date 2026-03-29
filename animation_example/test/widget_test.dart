import 'package:flutter_test/flutter_test.dart';

import 'package:animation_example/main.dart';

void main() {
  testWidgets('Home page renders go_router demo entries', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter Animation Router Demos'), findsOneWidget);
    expect(find.text('TickerProvider + AnimationController'), findsOneWidget);
    expect(find.text('Raw Ticker'), findsOneWidget);
    expect(find.text('CurvedAnimation'), findsOneWidget);
    expect(find.text('Tween + TweenSequence'), findsOneWidget);
  });

  testWidgets('Can navigate to ticker provider page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('TickerProvider + AnimationController'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'SingleTickerProviderStateMixin provides vsync for the controller.',
      ),
      findsOneWidget,
    );
    expect(find.text('Forward'), findsOneWidget);
  });
}
