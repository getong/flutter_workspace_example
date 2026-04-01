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
    expect(find.text('Intl Module'), findsOneWidget);
    expect(find.text('Text.rich Module'), findsOneWidget);
    expect(find.text('SingleChildScrollView Module'), findsOneWidget);
    expect(find.text('Scrollbar Module'), findsOneWidget);
    expect(find.text('FilledButton Module'), findsOneWidget);
    expect(find.text('DecoratedBox Module'), findsOneWidget);
    expect(find.text('Semantics Module'), findsOneWidget);
    expect(find.text('ExcludeSemantics Module'), findsOneWidget);
    expect(find.text('MergeSemantics Module'), findsOneWidget);
  });
}
