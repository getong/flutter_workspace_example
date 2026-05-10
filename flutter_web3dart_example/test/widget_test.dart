import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_web3dart_example/main.dart';

void main() {
  testWidgets('renders web3dart showcase shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Flutter web3dart Showcase'), findsOneWidget);
    expect(find.text('web3dart 功能演示台'), findsOneWidget);
    expect(find.text('交互式 Demo Controls'), findsOneWidget);
  });
}
