import 'package:flutter_test/flutter_test.dart';

import 'package:widget_layout_example/main.dart';

void main() {
  testWidgets('Home page shows module list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Widget Layout Modules'), findsOneWidget);
    expect(find.text('Center Box Module'), findsOneWidget);
    expect(find.text('Constrained Box Module'), findsOneWidget);
    expect(find.text('Table Module'), findsOneWidget);
  });
}
