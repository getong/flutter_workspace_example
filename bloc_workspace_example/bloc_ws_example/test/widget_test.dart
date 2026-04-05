import 'package:bloc_ws_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders websocket bloc page', (WidgetTester tester) async {
    await tester.pumpWidget(const WsApp());

    expect(find.text('BLoC + WebSocket Demo'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Disconnect'), findsOneWidget);
    expect(find.text('No messages yet.'), findsOneWidget);
  });
}
