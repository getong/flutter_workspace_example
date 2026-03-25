import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rust_bridge_sui_example/main.dart';

void main() {
  testWidgets('renders bridge page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter -> Rust -> Sui'), findsAtLeastNWidgets(1));
    expect(find.text('1) 查询 Sui API 版本'), findsOneWidget);
    expect(find.text('2) Sui 地址规范化'), findsOneWidget);
  });
}
