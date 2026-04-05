import 'package:bloc_spawn_ws_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders websocket page shell', (WidgetTester tester) async {
    await tester.pumpWidget(const WsApp());

    expect(find.text('BLoC + Spawned Isolate WebSocket'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Latest binary payload'), findsOneWidget);
    expect(find.text('Event log'), findsOneWidget);
  });
}
