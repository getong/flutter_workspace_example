import 'package:flutter_test/flutter_test.dart';

import 'package:squadron_example/main.dart';

void main() {
  testWidgets('renders the Squadron demo shell', (tester) async {
    await tester.pumpWidget(const SquadronExampleApp());

    expect(find.text('Squadron Prime Lab'), findsOneWidget);
    expect(find.text('Single worker run'), findsOneWidget);
    expect(find.text('Worker pool batch'), findsOneWidget);
    expect(find.text('Benchmark Controls'), findsOneWidget);
  });
}
